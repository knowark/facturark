#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""The setup script."""

from setuptools import setup, find_packages

with open('README.rst') as readme_file:
    readme = readme_file.read()

with open('HISTORY.rst') as history_file:
    history = history_file.read()

requirements = ['lxml>=3.7.1', 'zeep>=3.1.0', 'qrcode>=5.3', 'cryptography', 'pyOpenSSL']

setup_requirements = ['pytest-runner', ]

test_requirements = ['pytest', ]

setup(
    author="Nubark",
    author_email='info@nubark.com',
    classifiers=[
        'Development Status :: 2 - Pre-Alpha',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: GNU General Public License v3 (GPLv3)',
        'Natural Language :: English',
        "Programming Language :: Python :: 2",
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.5',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: Python :: 3.7',
    ],
    description="Librería de Generación de Factura Electrónica en Python",
    entry_points={
        'console_scripts': [
            'facturark=facturark.cli:main',
        ],
    },
    install_requires=requirements,
    license="GNU General Public License v3",
    long_description=readme + '\n\n' + history,
    package_data={
        '': [
            'XSD/DIAN/*.xsd',
            'XSD/DIAN/UBL2/common/*.xsd',
            'XSD/XADES/*.xsd',
            'XSD/XADES/XMLDSIG/*.xsd',
            'assets/*'
            ],
    },
    keywords='facturark',
    name='facturark',
    packages=find_packages(exclude=["*.tests", "*.tests.*", "tests.*", "tests"]),
    setup_requires=setup_requirements,
    test_suite='tests',
    tests_require=test_requirements,
    url='https://github.com/nubark/facturark',
    version='0.3.0',
    zip_safe=False,
)
