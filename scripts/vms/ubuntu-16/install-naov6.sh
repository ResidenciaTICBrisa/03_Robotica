#!/bin/bash

readonly PIP_PATH="${HOME}/.local/bin"

CURRENT_DIR="$(pwd)"
readonly CURRENT_DIR

readonly NAO_BASE_DIR="${HOME}/NAO6"
readonly NAO_SDKS_DIR="${NAO_BASE_DIR}/SDKs"

readonly NAO_CPP_DIR="${NAO_SDKS_DIR}/cpp"
readonly NAO_PYTHON2_DIR="${NAO_SDKS_DIR}/python2"
readonly NAO_CTC_DIR="${NAO_SDKS_DIR}/ctc"
readonly NAO_DOWNLOADS_DIR="${NAO_BASE_DIR}/downloads"
readonly NAO_PROGRAMS_DIR="${NAO_BASE_DIR}/programs"
readonly NAO_DOCS_DIR="${NAO_BASE_DIR}/docs"
readonly NAO_QIBUILD_WORKSPACE="${NAO_BASE_DIR}/workspace"

readonly NAO_CHOREGRAPHE_DIR="${NAO_PROGRAMS_DIR}/choregraphe"
readonly CHOREGRAPHE_KEY='654e-4564-153c-6518-2f44-7562-206e-4c60-5f47-5f45'

readonly NAO_FLASHER_DIR="${NAO_PROGRAMS_DIR}/flasher"
readonly NAO_ROBOT_SETTINGS_DIR="${NAO_PROGRAMS_DIR}/robot-settings"

readonly NAOQI_CPP_QIBUILD_TOOLCHAIN='naov6-toolchain'
readonly NAOQI_CPP_QIBUILD_CONFIG="${NAOQI_CPP_QIBUILD_TOOLCHAIN}-config"
readonly NAOQI_QIBUILD_CTC='cross-atom-naov6'
readonly NAOQI_QIBUILD_CTC_CONFIG="${NAOQI_QIBUILD_CTC}-config"

# readonly NAOQI_CMAKE_CONFIG='naov6-config.cmake'
readonly QIBUILD_CONFIGURATION='naov6-qibuild.xml'

readonly NAOQI_DOCS_URL='http://doc.aldebaran.com/download/aldeb-doc-2.8.7.4.zip'
readonly CHOREGRAPHE_SETUP_URL='https://community-static.aldebaran.com/resources/2.8.7/Choregraphe+Suite/Linux64/choregraphe-suite-2.8.7.4-linux64-setup.run'
readonly CHOREGRAPHE_BINARIES_URL='https://community-static.aldebaran.com/resources/2.8.7/Choregraphe+Suite/Linux64/choregraphe-suite-2.8.7.4-linux64.tar.gz'
readonly NAOQI_CPP_URL='https://community-static.aldebaran.com/resources/2.8.5/naoqi-sdk-2.8.5.10-linux64.tar.gz'
readonly NAOQI_PYTHON_URL='https://community-static.aldebaran.com/resources/2.8.7/Python+SDK/pynaoqi-python2.7-2.8.7.4-linux64-20210819_141148.tar.gz'
readonly NAO_FLASHER_URL='https://community-static.aldebaran.com/resources/2.1.0.19/flasher-2.1.0.19-linux64.tar.gz'
readonly NAO_ROBOT_SETTINGS_SETUP_URL='https://community-static.aldebaran.com/resources/2.8.7/Robot+settings+1.2.1/Linux64/robot-settings_linux64_1.2.1-6c3a1204f_20210902-182550_setup.run'
readonly NAO_ROBOT_SETTINGS_BINARIES_URL='https://community-static.aldebaran.com/resources/2.8.7/Robot+settings+1.2.1/Linux64/robot-settings_linux64_1.2.1-6c3a1204f_20210902-182550.tar.gz'
readonly NAO_CTC_URL='https://community-static.aldebaran.com/resources/2.8.7/cross+toolchain/ctc-linux64-atom-2.8.7.4-20210818_162500.zip'

readonly NAOQI_DOCS_FILE="${NAOQI_DOCS_URL##*/}"
readonly CHOREGRAPHE_SETUP_FILE="${CHOREGRAPHE_SETUP_URL##*/}"
readonly CHOREGRAPHE_BINARIES_FILE="${CHOREGRAPHE_BINARIES_URL##*/}"
readonly NAOQI_CPP_FILE="${NAOQI_CPP_URL##*/}"
readonly NAOQI_PYTHON_FILE="${NAOQI_PYTHON_URL##*/}"
readonly NAO_FLASHER_FILE="${NAO_FLASHER_URL##*/}"
readonly NAO_ROBOT_SETTINGS_SETUP_FILE="${NAO_ROBOT_SETTINGS_SETUP_URL##*/}"
readonly NAO_ROBOT_SETTINGS_BINARIES_FILE="${NAO_ROBOT_SETTINGS_BINARIES_URL##*/}"
readonly NAO_CTC_FILE="${NAO_CTC_URL##*/}"

readonly NAOQI_DOCS="${NAOQI_DOCS_FILE%*.zip}"
readonly CHOREGRAPHE_BINARIES="${CHOREGRAPHE_BINARIES_FILE%*.tar.*}"
readonly NAOQI_CPP="${NAOQI_CPP_FILE%*.tar.*}"
readonly NAOQI_PYTHON="${NAOQI_PYTHON_FILE%*.tar.*}"
readonly NAO_FLASHER="${NAO_FLASHER_FILE%*.tar.*}"
readonly NAO_ROBOT_SETTINGS_BINARIES="${NAO_ROBOT_SETTINGS_BINARIES_FILE%*.tar.*}"
readonly NAO_CTC="${NAO_CTC_FILE%*.zip}"

readonly DOWNLOAD_URLS=(
	"${CHOREGRAPHE_BINARIES_URL}"
	"${NAOQI_CPP_URL}"
	"${NAOQI_PYTHON_URL}"
	"${NAOQI_DOCS_URL}"
	"${NAO_FLASHER_URL}"
	"${NAO_ROBOT_SETTINGS_BINARIES_URL}"
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
	"${NAO_ROBOT_SETTINGS_DIR}"
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
pip2 install qibuild pyreadline
echo '# NAOv6 installation' >> "${HOME}/.bashrc"
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
		"${NAO_DOWNLOADS_DIR}/${NAO_ROBOT_SETTINGS_BINARIES}")
			mv -v "$f" "${NAO_ROBOT_SETTINGS_DIR}/"
			;;
		"${NAO_DOWNLOADS_DIR}/${NAO_CTC}")
			mv -v "$f" "${NAO_CTC_DIR}/"
			;;
		*)
			echo "Unknown file '$f'"
			;;
		esac
	else
		echo "Not a directory: '$f'"
	fi
done

# echo 'Patching NAOv6 C++ SDK'
# mv -v "${NAOQI_CMAKE_CONFIG}" "${NAO_CPP_DIR}/${NAOQI_CPP}/config.cmake"

echo 'Installing Python library'
echo '# NAOv6 Python SDK' >> "${HOME}/.bashrc"
echo "readonly NAO6_PYTHON_SDK_PATH=\"${NAO_PYTHON2_DIR}/${NAOQI_PYTHON}\"" >> "${HOME}/.bashrc"
echo 'export PYTHONPATH="${PYTHONPATH}:${NAO6_PYTHON_SDK_PATH}/lib/python2.7/site-packages"' >> "${HOME}/.bashrc"

printf 'Installing Choreographe\n'
printf '# Choregraphe path\n' >> "${HOME}/.bashrc"
printf 'readonly CHOREGRAPHE_PATH="%s"\n' "${NAO_CHOREGRAPHE_DIR}/${CHOREGRAPHE_BINARIES}" >> "${HOME}/.bashrc"
printf 'export PATH="${PATH}:${CHOREGRAPHE_PATH}"\n' >> "${HOME}/.bashrc"
printf 'export CHOREGRAPHE_KEY="%s"\n' "${CHOREGRAPHE_KEY}" >> "${HOME}/.bashrc"
printf "CHOREGRAPHE_KEY='%s'\n" "${CHOREGRAPHE_KEY}"

echo 'Installing NAO Flasher'
echo '# NAO Flasher path' >> "${HOME}/.bashrc"
echo "readonly NAO_FLASHER_PATH=\"${NAO_FLASHER_DIR}/${NAO_FLASHER}\"" >> "${HOME}/.bashrc"
echo 'export PATH="${PATH}:${NAO_FLASHER_PATH}"' >> "${HOME}/.bashrc"

echo 'Installing Robot Settings'
echo '# Robot Settings path' >> "${HOME}/.bashrc"
echo "readonly NAO_ROBOT_SETTINGS_PATH=\"${NAO_ROBOT_SETTINGS_DIR}/${NAO_ROBOT_SETTINGS_BINARIES}/bin\"" >> "${HOME}/.bashrc"
echo 'export PATH="${PATH}:${NAO_ROBOT_SETTINGS_PATH}"' >> "${HOME}/.bashrc"

echo 'Installing CPP library'
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
