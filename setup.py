#!/usr/bin/env python3

from setuptools import setup, find_packages

setup(
    long_description_content_type='text/markdown',
    packages=find_packages(include=['tinygrad', 'tinygrad.*']),
    include_package_data=True,
)
