#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p "python3.withPackages(ps: with ps; [ requests pyquery click ])"

# To use, just execute this script with --help to display help.

import subprocess
import json
import sys

import click
import requests
from pyquery import PyQuery as pq

def map_dict (f, d):
    for k,v in d.items():
        d[k] = f(v)

maintainers_json = subprocess.check_output([
    'nix-instantiate', '-A', 'lib.maintainers', '--eval', '--strict', '--json'
])
maintainers = json.loads(maintainers_json)
MAINTAINERS = map_dict(lambda v: v.get('github', None), maintainers)

def get_response_text(url):
    return pq(requests.get(url).text)  # IO

EVAL_FILE = {
    'nixos': 'nixos/release.nix',
    'nixpkgs': 'pkgs/top-level/release.nix',
}


def get_maintainers(attr_name):
    try:
        nixname = attr_name.split('.')
        meta_json = subprocess.check_output([
            'nix-instantiate',
            '--eval',
            '--strict',
            '-A',
            '.'.join(nixname[1:]) + '.meta',
            EVAL_FILE[nixname[0]],
            '--arg',
            'nixpkgs',
            './.',
            '--json'])
        meta = json.loads(meta_json)
        return meta.get('maintainers', [])
    except:
       return []

def filter_github_users(maintainers):
    return [i for i in maintainers if i.get('github')]

def print_build(table_row):
    a = pq(table_row)('a')[1]
    print(f"- [ ] [{a.text}]({a.get('href')})", flush=True)

    if job_maintainers := filter_github_users(get_maintainers(a.text)):
        print(
            f"""  - maintainers: {" ".join(map(lambda u: '@' + u.get('github'), job_maintainers))}"""
        )
    # TODO: print last three persons that touched this file
    # TODO: pinpoint the diff that broke this build, or maybe it's transient or maybe it never worked?

    sys.stdout.flush()

@click.command()
@click.option(
    '--jobset',
    default="nixos/release-19.09",
    help='Hydra project like nixos/release-19.09')
def cli(jobset):
    """
    Given a Hydra project, inspect latest evaluation
    and print a summary of failed builds
    """

    url = f"https://hydra.nixos.org/jobset/{jobset}"

    # get the last evaluation
    click.echo(click.style(f'Getting latest evaluation for {url}', fg='green'))
    d = get_response_text(url)
    evaluations = d('#tabs-evaluations').find('a[class="row-link"]')
    latest_eval_url = evaluations[0].get('href')

    # parse last evaluation page
    click.echo(click.style(f'Parsing evaluation {latest_eval_url}', fg='green'))
    d = get_response_text(f'{latest_eval_url}?full=1')

    # TODO: aborted evaluations
    # TODO: dependency failed without propagated builds
    print('\nFailures:')
    for tr in d('img[alt="Failed"]').parents('tr'):
        print_build(tr)

    print('\nDependency failures:')
    for tr in d('img[alt="Dependency failed"]').parents('tr'):
        print_build(tr)



if __name__ == "__main__":
    try:
        cli()
    except Exception as e:
        import pdb;pdb.post_mortem()
