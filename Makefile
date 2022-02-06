VENV=venv
BRANCH=stable/ussuri-m3
.PHONY: activate clean
.DEFAULT: activate


activate: ${VENV}/bin/activate
	bash --rcfile $<

${VENV}/bin/activate: requirements octavia octavia-f5-provider-driver
	mkdir -p ${VENV}
	nix-shell -p python38Packages.virtualenv --run 'virtualenv ${VENV} && . $@ && pip install -c requirements/upper-constraints.txt -e octavia && pip install -c requirements/upper-constraints.txt -e octavia-f5-provider-driver'


# repos

requirements:
	git clone -b ${BRANCH} https://github.com/sapcc/requirements

octavia:
	git clone -b ${BRANCH} https://github.com/sapcc/octavia

octavia-f5-provider-driver:
	git clone -b ${BRANCH} https://github.com/sapcc/octavia-f5-provider-driver

update: requirements octavia octavia-f5-provider-driver
	$(foreach repo, $+, git -C ${repo} pull;)
