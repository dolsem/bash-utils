# Bash Utils
[![License: MIT][license-image]][license-url]

Collection of useful functions that can be used in scripts.
## Usage
You can use it directly in your script without storing local copies, for example:
```bash
source_remote() { source <(curl -fsSL github.com/dolsem/bash-utils/raw/master/$1.bash || echo "echo 'Cannot download $1'") }
source_remote term
```
Or, if you would like to cache modules to run the script again:
```bash
source_util() { source ".bash-utils/$1.bash" 2>/dev/null || util=$1 source <(curl -fsSL https://github.com/dolsem/shell-collection/raw/master/source_utils.bash') 1>&2; }
source_util term
```

## Overview
#### Below is an overview of the available modules.
- **assert**
- **filesystem**
  - **abspath**
- **network**
  - **get_ip**
- **os**
  - **is_macos**
- **prompt**
  - **prompt_with_default**
  - **prompt_for_bool**
  - **prompt_for_file**
  - **prompt_for_option**
  - **prompt_for_multiselect**
- **string**
  - **strip_whitespace**
  - **escape_fslash**
- **term**
  - *output colors*
  - **reset_color**
- **validation**
  - **is_valid_ip**

## Shell compatibility
| Module                | Bash               | Zsh                |
|-----------------------|--------------------|--------------------|
| assert.bash           | :heavy_check_mark: | :heavy_check_mark: |
| filesystem.bash       | :heavy_check_mark: | :heavy_check_mark: |
| network.bash          | :heavy_check_mark: | :heavy_check_mark: |
| os.bash               | :heavy_check_mark: | :heavy_check_mark: |
| prompt.bash           | :heavy_check_mark: | :heavy_check_mark: |
| string.bash           | :heavy_check_mark: | :heavy_check_mark: |
| term.bash             | :heavy_check_mark: | :heavy_check_mark: |
| validation.bash       | :heavy_check_mark: | :heavy_check_mark: |

## OS compatibility
| Module                | Linux              | Mac OS             |
|-----------------------|--------------------|--------------------|
| assert.bash           | :heavy_check_mark: | :heavy_check_mark: |
| filesystem.bash       | :heavy_check_mark: | :heavy_check_mark: |
| network.bash          | :heavy_check_mark: | :heavy_check_mark: |
| os.bash               | :heavy_check_mark: | :heavy_check_mark: |
| prompt.bash           | :heavy_check_mark: | :grey_question:    |
| string.bash           | :heavy_check_mark: | :grey_question:    |
| term.bash             | :heavy_check_mark: | :grey_question:    |
| validation.bash       | :heavy_check_mark: | :grey_question:    |

[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: https://opensource.org/licenses/MIT