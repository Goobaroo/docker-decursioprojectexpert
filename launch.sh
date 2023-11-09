#!/bin/bash

set -x

FORGE_VERSION=1.16.5-36.2.34
cd /data

if ! [[ "$EULA" = "false" ]] || grep -i true eula.txt; then
	echo "eula=true" > eula.txt
else
	echo "You must accept the EULA by in the container settings."
	exit 9
fi

if ! [[ -f 'Decursio Project - Expert-r1.0.5 SERVER.zip' ]]; then
	rm -fr config defaultconfigs kubejs mods scripts *.zip forge*.jar
	curl -Lo 'Decursio Project - Expert-r1.0.5 SERVER.zip' 'https://edge.forgecdn.net/files/4533/172/Decursio Project - Expert-r1.0.5 SERVER.zip' && unzip -u -o 'Decursio Project - Expert-r1.0.5 SERVER.zip' -d /data
	DIR_TEST=$(find . -type d -maxdepth 1 | tail -1 | sed 's/^.\{2\}//g')
	if [[ $(find . -type d -maxdepth 1 | wc -l) -gt 1 ]]; then
		cd "${DIR_TEST}"
		mv -f * /data
		cd /data
		rm -fr "$DIR_TEST"
	fi
fi

if [[ -n "$JVM_OPTS" ]]; then
	sed -i "s/^ARGS=.*/ARGS=${JVM_OPTS}/g" start.sh
fi
if [[ -n "$MOTD" ]]; then
    sed -i "/motd\s*=/ c motd=$MOTD" /data/server.properties
fi
if [[ -n "$LEVEL" ]]; then
    sed -i "/level-name\s*=/ c level-name=$LEVEL" /data/server.properties
fi
if [[ -n "$OPS" ]]; then
    echo $OPS | awk -v RS=, '{print}' > ops.txt
fi
if [[ -n "$ALLOWLIST" ]]; then
    echo $ALLOWLIST | awk -v RS=, '{print}' > white-list.txt
fi

sed -i 's/server-port.*/server-port=25565/g' server.properties

chmod +x start.sh
./start.sh