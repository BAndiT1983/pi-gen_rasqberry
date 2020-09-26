# Changes for RasQberry image

## 1. Skip unnecessary steps

- Skip stages 3-5, we only want Raspbian lite

        touch ./stage3/SKIP ./stage4/SKIP ./stage5/SKIP
        touch ./stage4/SKIP_IMAGES ./stage5/SKIP_IMAGES

- EXPORT_IMAGE and EXPORT_NOOBS removed from stage2

## 2. Added general configuration of the image

- Created `config` file

        IMG_NAME=rasqberry
        RELEASE=buster
        STAGES="stage0 stage1 stage2 stage6_rasqberry"
        DEPLOY_ZIP=1
        LOCALE_DEFAULT=de_DE.UTF-8
        TARGET_HOSTNAME=rasqberry
        KEYBOARD_KEYMAP=de
        KEYBOARD_LAYOUT="German (DE)"
        TIMEZONE_DEFAULT=Germnay/Berlin
        FIRST_USER_NAME=user
        FIRST_USER_PASS="${pi_pwd}"
        ENABLE_SSH=1

## 3. Added custom stage

- Created `stage2a_rasqberry` folder, as you can't skip stages properly

- Added folder `00-prepare` and added `00-packages` to it, which lists necessary packages for installation

- Added folder `01-qiskit` and added `01-run.sh` to it, which will execute the installation and setup of RasQberry modules

## 4. Added helpers

- `disable_base_stages.sh` will add SKIP to stages 0-2, to prevent building them when successfully done before, which should accelerate testing if new stages

- `enable_base_stages.sh` will remove SKIP from stages 0-2

# Usage

- Start the build with `reset && PRESERVE_CONTAINER=1 ./build-docker.sh |& tee build.log`, this command will clear the terminal, keep the container after successful build and reroute the logs to _build.log_

- If the build fails, but stages 0-2 were successful, then `disable_base_stages.sh` can be used to disable this stages, which should accelerate the build when testing custom stages, e.g. `stage2a_rasqberry` after fixing the reported problems

# References

- https://geoffhudik.com/tech/2020/05/15/using-pi-gen-to-build-a-custom-raspbian-lite-image/
- http://kmdouglass.github.io/posts/create-a-custom-raspbian-image-with-pi-gen-part-1/
