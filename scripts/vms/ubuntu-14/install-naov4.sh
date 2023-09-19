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

echo 'Install C++, Python dependencies and downloader'
sudo apt-get install --yes build-essential cmake wget

echo 'Create directories'
for directory in "${DIRECTORIES[@]}"; do
	mkdir -pv "${directory}"
done

echo 'Install qibuild'
"${PIP_PATH}/pip2" install qibuild pyreadline
echo '# NAOv4 installation' >> "${HOME}/.bashrc"
echo "readonly PIP_PATH=\"${PIP_PATH}\"" >> "${HOME}/.bashrc"
echo 'export PATH="${PATH}:${PIP_PATH}"' >> "${HOME}/.bashrc"

echo 'Configure qibuild'
mkdir -pv "${HOME}/.config/qi"
mv -v "${QIBUILD_CONFIGURATION}" "${HOME}/.config/qi/qibuild.xml"

cd "${NAO_QIBUILD_WORKSPACE}"
"${PIP_PATH}/qibuild" init
cd "${CURRENT_DIR}"

echo 'Download packages'
for url in "${DOWNLOAD_URLS[@]}"; do
	wget "${url}" --directory-prefix="${NAO_DOWNLOADS_DIR}"
done

echo 'Extract packages'
for f in "${NAO_DOWNLOADS_DIR}"/{*.zip,*.tar.gz}; do
	if [[ "$f" =~ .*\.zip ]]; then
		unzip -d "${f%*.zip}" "$f"
	else
		tar --extract --file="$f" --directory "${NAO_DOWNLOADS_DIR}"
	fi
done

echo 'Move packages'
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
			mv -v "$f" "${NAO_CTC_DIR}"
			;;
		*)
			echo "Unknown file '$f'"
			;;
		esac
	else
		echo "Not a directory: '$f'"
	fi
done

echo 'Patching NAOv4 C++ SDK'
mv -v "${NAOQI_CMAKE_CONFIG}" "${NAO_CPP_DIR}/${NAOQI_CPP}/config.cmake"

echo 'Installing Python library'
echo '# NAOv4 Python SDK' >> "${HOME}/.bashrc"
echo "readonly NAO4_PYTHON_SDK_PATH=\"${NAO_PYTHON2_DIR}/${NAOQI_PYTHON}\"" >> "${HOME}/.bashrc"
echo 'export PYTHONPATH="${PYTHONPATH}:${NAO4_PYTHON_SDK_PATH}"' >> "${HOME}/.bashrc"

echo 'Installing Choreographe'
echo '# Choregraphe path' >> "${HOME}/.bashrc"
echo "readonly CHOREGRAPHE_PATH=\"${NAO_CHOREGRAPHE_DIR}/${CHOREGRAPHE_BINARIES}\"" >> "${HOME}/.bashrc"
echo 'export PATH="${PATH}:${CHOREGRAPHE_PATH}"' >> "${HOME}/.bashrc"
echo "Choregraphe key: '${CHOREGRAPHE_KEY}'"

echo 'Installing NAO Flasher'
echo '# NAO Flasher path' >> "${HOME}/.bashrc"
echo "readonly NAO_FLASHER_PATH=\"${NAO_FLASHER_DIR}/${NAO_FLASHER}\"" >> "${HOME}/.bashrc"
echo 'export PATH="${PATH}:${NAO_FLASHER_PATH}"' >> "${HOME}/.bashrc"

echo 'Installing CPP library'
"${PIP_PATH}/qitoolchain" create "${NAOQI_CPP_QIBUILD_TOOLCHAIN}" "${NAO_CPP_DIR}/${NAOQI_CPP}/toolchain.xml"
cd "${NAO_QIBUILD_WORKSPACE}"
"${PIP_PATH}/qibuild" add-config "${NAOQI_CPP_QIBUILD_CONFIG}" -t "${NAOQI_CPP_QIBUILD_TOOLCHAIN}" --default
cd "${CURRENT_DIR}"

exit 0
