#!/bin/bash

readonly PIP_PATH="${HOME}/.local/bin"

CURRENT_DIR="$(pwd)"
readonly CURRENT_DIR

readonly NAO_BASE_DIR="${HOME}/NAO4"
readonly NAO_SDKS_DIR="${NAO_BASE_DIR}/SDKs"

readonly NAO_CPP_DIR="${NAO_SDKS_DIR}/cpp"
readonly NAO_PYTHON2_DIR="${NAO_SDKS_DIR}/python2"
readonly NAO_CTC_DIR="${NAO_SDKS_DIR}/ctc"
readonly NAO_DOWNLOADS_DIR="${NAO_BASE_DIR}/downloads"
readonly NAO_PROGRAMS_DIR="${NAO_BASE_DIR}/programs"
readonly NAO_DOCS_DIR="${NAO_BASE_DIR}/docs"
readonly NAO_QIBUILD_WORKSPACE="${NAO_BASE_DIR}/workspace"

readonly NAO_CHOREGRAPHE_DIR="${NAO_PROGRAMS_DIR}/choregraphe"
readonly CHOREGRAPHE_KEY='562a-750a-252e-143c-0f2a-4550-505e-4f40-5f48-504c'

readonly NAO_FLASHER_DIR="${NAO_PROGRAMS_DIR}/flasher"

readonly NAOQI_CPP_QIBUILD_TOOLCHAIN='naov4-toolchain'
readonly NAOQI_CPP_QIBUILD_CONFIG="${NAOQI_CPP_QIBUILD_TOOLCHAIN}-config"
readonly NAOQI_QIBUILD_CTC='cross-atom-naov4'
readonly NAOQI_QIBUILD_CTC_CONFIG="${NAOQI_QIBUILD_CTC}-config"

readonly NAOQI_CMAKE_CONFIG='naov4-config.cmake'
readonly QIBUILD_CONFIGURATION='naov4-qibuild.xml'

readonly NAOQI_DOCS_URL='http://doc.aldebaran.com/download/aldeb-doc-2.1.4.13.zip'
readonly CHOREGRAPHE_SETUP_URL='https://community-static.aldebaran.com/resources/2.1.4.13/choregraphe/choregraphe-suite-2.1.4.13-linux64-setup.run'
readonly CHOREGRAPHE_BINARIES_URL='https://community-static.aldebaran.com/resources/2.1.4.13/choregraphe/choregraphe-suite-2.1.4.13-linux64.tar.gz'
readonly NAOQI_CPP_URL='https://community-static.aldebaran.com/resources/2.1.4.13/sdk-c%2B%2B/naoqi-sdk-2.1.4.13-linux64.tar.gz'
readonly NAOQI_PYTHON_URL='https://community-static.aldebaran.com/resources/2.1.4.13/sdk-python/pynaoqi-python2.7-2.1.4.13-linux64.tar.gz'
readonly NAO_FLASHER_URL='https://community-static.aldebaran.com/resources/2.1.0.19/flasher-2.1.0.19-linux64.tar.gz'
readonly NAO_CTC_URL='https://community-static.aldebaran.com/resources/2.8.7/cross+toolchain/ctc-linux64-atom-2.8.7.4-20210818_162500.zip'

readonly NAOQI_DOCS_FILE="${NAOQI_DOCS_URL##*/}"
readonly CHOREGRAPHE_SETUP_FILE="${CHOREGRAPHE_SETUP_URL##*/}"
readonly CHOREGRAPHE_BINARIES_FILE="${CHOREGRAPHE_BINARIES_URL##*/}"
readonly NAOQI_CPP_FILE="${NAOQI_CPP_URL##*/}"
readonly NAOQI_PYTHON_FILE="${NAOQI_PYTHON_URL##*/}"
readonly NAO_FLASHER_FILE="${NAO_FLASHER_URL##*/}"
readonly NAO_CTC_FILE="${NAO_CTC_URL##*/}"

readonly NAOQI_DOCS="${NAOQI_DOCS_FILE%*.zip}"
readonly CHOREGRAPHE_BINARIES="${CHOREGRAPHE_BINARIES_FILE%*.tar.*}"
readonly NAOQI_CPP="${NAOQI_CPP_FILE%*.tar.*}"
readonly NAOQI_PYTHON="${NAOQI_PYTHON_FILE%*.tar.*}"
readonly NAO_FLASHER="${NAO_FLASHER_FILE%*.tar.*}"
readonly NAO_CTC="${NAO_CTC_FILE%*.zip}"

readonly DOWNLOAD_URLS=(
	"${CHOREGRAPHE_BINARIES_URL}"
	"${NAOQI_CPP_URL}"
	"${NAOQI_PYTHON_URL}"
	"${NAOQI_DOCS_URL}"
	"${NAO_FLASHER_URL}"
	"${NAO_CTC_URL}"
)

readonly DIRECTORIES=(
	"${NAO_CPP_DIR}"
	"${NAO_PYTHON2_DIR}"
	"${NAO_DOWNLOADS_DIR}"
	"${NAO_PROGRAMS_DIR}"
	"${NAO_DOCS_DIR}"
	"${NAO_CHOREGRAPHE_DIR}"
	"${NAO_FLASHER_DIR}"
	"${NAO_CTC_DIR}"
	"${NAO_QIBUILD_WORKSPACE}"
)

sudo apt-get update

printf 'Install C++, Python dependencies and downloader\n'
sudo apt-get install --yes build-essential cmake wget

printf 'Install editors\n'
sudo apt-get install --yes vim vim-gtk

printf 'Create directories\n'
for directory in "${DIRECTORIES[@]}"; do
	mkdir -pv "${directory}"
done

printf 'Install qibuild\n'
"${PIP_PATH}/pip2" install qibuild pyreadline
printf '# NAOv4 installation\n' >> "${HOME}/.bashrc"
printf 'readonly PIP_PATH="%s"\n' "${PIP_PATH}" >> "${HOME}/.bashrc"
printf 'export PATH="${PATH}:${PIP_PATH}"\n' >> "${HOME}/.bashrc"

printf 'Configure qibuild\n'
mkdir -pv "${HOME}/.config/qi"
mv -v "${QIBUILD_CONFIGURATION}" "${HOME}/.config/qi/qibuild.xml"

cd "${NAO_QIBUILD_WORKSPACE}"
"${PIP_PATH}/qibuild" init
cd "${CURRENT_DIR}"

printf 'Download packages\n'
for url in "${DOWNLOAD_URLS[@]}"; do
	wget "${url}" --directory-prefix="${NAO_DOWNLOADS_DIR}"
done

printf 'Extract packages\n'
for f in "${NAO_DOWNLOADS_DIR}"/{*.zip,*.tar.gz}; do
	if [[ "$f" =~ .*\.zip ]]; then
		printf "File '%s' is a zip\n" "${f}"
		rootdirs="$(zipinfo -1 "$f" | awk -F / '{ print $1; }' | sort | uniq)"
		rootdirs_count=$(echo "${rootdirs}" | wc -l)
		if (( rootdirs_count == 1 )); then
			printf "File '%s' has a root directory '%s'\n" "${f}" "${rootdirs}"
			unzip -q -d "${NAO_DOWNLOADS_DIR}" "${f}"
			expected="${f##*/}"
			expected="${expected%*.zip}"
			if [[ "${rootdirs}" != "${expected}" ]]; then
				printf "File '%s's root '%s' has a different name than expected '%s'\n" "${f}" "${rootdirs}" "${expected}"
				mv -v "${NAO_DOWNLOADS_DIR}/${rootdirs}" "${NAO_DOWNLOADS_DIR}/${f%*.zip}"
			fi
		else
			printf "File '%s' lacks a root directory\n" "${f}"
			unzip -q -d "${f%*.zip}" "$f"
		fi
	else
		printf "File '%s' is a tar\n" "${f}"
		tar --extract --file="$f" --directory "${NAO_DOWNLOADS_DIR}"
	fi
done

printf 'Move packages\n'
for f in "${NAO_DOWNLOADS_DIR}"/*; do
	if [[ -d "$f" ]]; then
		case "$f" in
		"${NAO_DOWNLOADS_DIR}/${NAOQI_DOCS}")
			mv -v "$f" "${NAO_DOCS_DIR}/"
			;;
		"${NAO_DOWNLOADS_DIR}/${CHOREGRAPHE_BINARIES}")
			mv -v "$f" "${NAO_CHOREGRAPHE_DIR}/"
			;;
		"${NAO_DOWNLOADS_DIR}/${NAOQI_CPP}")
			mv -v "$f" "${NAO_CPP_DIR}/"
			;;
		"${NAO_DOWNLOADS_DIR}/${NAOQI_PYTHON}")
			mv -v "$f" "${NAO_PYTHON2_DIR}/"
			;;
		"${NAO_DOWNLOADS_DIR}/${NAO_FLASHER}")
			mv -v "$f" "${NAO_FLASHER_DIR}/"
			;;
		"${NAO_DOWNLOADS_DIR}/${NAO_CTC}")
			mv -v "$f" "${NAO_CTC_DIR}/"
			;;
		*)
			printf "Unknown file '%s'\n" "${f}"
			;;
		esac
	fi
done

printf 'Patching NAOv4 C++ SDK\n'
mv -v "${NAOQI_CMAKE_CONFIG}" "${NAO_CPP_DIR}/${NAOQI_CPP}/config.cmake"

printf 'Installing Python library\n'
printf '# NAOv4 Python SDK\n' >> "${HOME}/.bashrc"
printf 'readonly NAO4_PYTHON_SDK_PATH="%s"\n' "${NAO_PYTHON2_DIR}/${NAOQI_PYTHON}" >> "${HOME}/.bashrc"
printf 'export PYTHONPATH="${PYTHONPATH}:${NAO4_PYTHON_SDK_PATH}"\n' >> "${HOME}/.bashrc"

printf 'Installing Choreographe\n'
printf '# Choregraphe path\n' >> "${HOME}/.bashrc"
printf 'readonly CHOREGRAPHE_PATH="%s"\n' "${NAO_CHOREGRAPHE_DIR}/${CHOREGRAPHE_BINARIES}" >> "${HOME}/.bashrc"
printf 'export PATH="${PATH}:${CHOREGRAPHE_PATH}"\n' >> "${HOME}/.bashrc"
printf 'export CHOREGRAPHE_KEY="%s"\n' "${CHOREGRAPHE_KEY}" >> "${HOME}/.bashrc"
printf "CHOREGRAPHE_KEY='%s'\n" "${CHOREGRAPHE_KEY}"

printf 'Installing NAO Flasher\n'
printf '# NAO Flasher path\n' >> "${HOME}/.bashrc"
printf 'readonly NAO_FLASHER_PATH="%s"\n' "${NAO_FLASHER_DIR}/${NAO_FLASHER}" >> "${HOME}/.bashrc"
printf 'export PATH="${PATH}:${NAO_FLASHER_PATH}"\n' >> "${HOME}/.bashrc"

printf 'Installing CPP library\n'
"${PIP_PATH}/qitoolchain" create "${NAOQI_CPP_QIBUILD_TOOLCHAIN}" "${NAO_CPP_DIR}/${NAOQI_CPP}/toolchain.xml"
cd "${NAO_QIBUILD_WORKSPACE}"
"${PIP_PATH}/qibuild" add-config "${NAOQI_CPP_QIBUILD_CONFIG}" -t "${NAOQI_CPP_QIBUILD_TOOLCHAIN}" --default
cd "${CURRENT_DIR}"

printf 'Installing Cross Toolchain\n'
"${PIP_PATH}/qitoolchain" create "${NAOQI_QIBUILD_CTC}" "${NAO_CTC_DIR}/${NAO_CTC}/toolchain.xml"
cd "${NAO_QIBUILD_WORKSPACE}"
"${PIP_PATH}/qibuild" add-config "${NAOQI_QIBUILD_CTC_CONFIG}" -t "${NAOQI_QIBUILD_CTC}"
cd "${CURRENT_DIR}"

printf 'Saving qibuild workspace settings\n'
printf 'export NAO_QIBUILD_WORKSPACE="%s"\n' "${NAO_QIBUILD_WORKSPACE}" >> "${HOME}/.bashrc"
printf 'NAO_QIBUILD_WORKSPACE=%s\n' "${NAO_QIBUILD_WORKSPACE}"

printf 'export NAOQI_CPP_QIBUILD_TOOLCHAIN="%s"\n' "${NAOQI_CPP_QIBUILD_TOOLCHAIN}" >> "${HOME}/.bashrc"
printf 'NAOQI_CPP_QIBUILD_TOOLCHAIN=%s\n' "${NAOQI_CPP_QIBUILD_TOOLCHAIN}"
printf 'export NAOQI_CPP_QIBUILD_CONFIG="%s"\n' "${NAOQI_CPP_QIBUILD_CONFIG}" >> "${HOME}/.bashrc"
printf 'NAOQI_CPP_QIBUILD_CONFIG=%s\n' "${NAOQI_CPP_QIBUILD_CONFIG}"

printf 'export NAOQI_QIBUILD_CTC="%s"\n' "${NAOQI_QIBUILD_CTC}" >> "${HOME}/.bashrc"
printf 'NAOQI_QIBUILD_CTC=%s\n' "${NAOQI_QIBUILD_CTC}"
printf 'export NAOQI_QIBUILD_CTC_CONFIG="%s"\n' "${NAOQI_QIBUILD_CTC_CONFIG}" >> "${HOME}/.bashrc"
printf 'NAOQI_QIBUILD_CTC_CONFIG=%s\n' "${NAOQI_QIBUILD_CTC_CONFIG}"

exit 0
