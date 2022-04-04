.PHONY: activate clean
.DEFAULT: activate

VIRTUALENV_PACKAGE=python38Packages.virtualenv
BRANCH=stable/ussuri-m3


# virtual environment

activate: venv/bin/activate venv/virtualenv
	bash --rcfile $<

venv/bin/activate: requirements octavia octavia-f5-provider-driver
	nix-shell -p ${VIRTUALENV_PACKAGE} --run 'virtualenv venv && . $@ && pip install -c requirements/upper-constraints.txt -e octavia && pip install -c requirements/upper-constraints.txt -e octavia-f5-provider-driver'

venv/virtualenv:
	# this is to ensure that venv/bin/python etc. always point to an existing store path
	mkdir -p venv
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
