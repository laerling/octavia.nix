.PHONY: activate clean
.DEFAULT: activate

VENV=venv # same as in .gitignore
VIRTUALENV_PACKAGE=python38Packages.virtualenv
BRANCH=stable/ussuri-m3


# virtual environment

activate: ${VENV}/bin/activate ${VENV}/virtualenv
	bash --rcfile $<

${VENV}/bin/activate: requirements octavia octavia-f5-provider-driver
	nix-shell -p ${VIRTUALENV_PACKAGE} --run 'virtualenv ${VENV} && . $@ && pip install -c requirements/upper-constraints.txt -e octavia && pip install -c requirements/upper-constraints.txt -e octavia-f5-provider-driver'

${VENV}/virtualenv:
	# this is to ensure that ${VENV}/bin/python etc. always point to an existing store path
	mkdir -p ${VENV}
	nix-build -A ${VIRTUALENV_PACKAGE} -o $@ '<nixpkgs>'


# repos

requirements:
	git clone -b ${BRANCH} https://github.com/sapcc/requirements

octavia:
	git clone -b ${BRANCH} https://github.com/sapcc/octavia

octavia-f5-provider-driver:
	git clone -b ${BRANCH} https://github.com/sapcc/octavia-f5-provider-driver

update: requirements octavia octavia-f5-provider-driver
	$(foreach repo, $+, git -C ${repo} pull;)
