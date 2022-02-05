OUTLINK=result # should be included in .gitignore
.PHONY: activate clean
.DEFAULT: activate


activate: octavia octavia-f5-provider-driver ${OUTLINK}
	bash -c 'exec ${OUTLINK}/bin/activate.sh'

${OUTLINK}: default.nix builder.sh
	nix-build $< -o ${OUTLINK}


# repos

octavia:
	git clone https://github.com/sapcc/octavia

octavia-f5-provider-driver:
	git clone https://github.com/sapcc/octavia-f5-provider-driver

update: octavia octavia-f5-provider-driver
	$(foreach repo, $+, git -C ${repo} pull;)


# other

clean:
	rm ${OUTLINK}
