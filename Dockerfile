# pass in image name as a build argument lile this:
# docker build --build-arg IMAGE_NAME=gitpod/workspace-full:latest .
ARG IMAGE_NAME
FROM $IMAGE_NAME

# installs oh my zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
    rm -rf ~/.zshrc.pre-oh-my-zsh

# installs powerlevel10k
COPY --chown=gitpod templates /tmp/templates

# if MIN is yes, then it will not install the powerlevel10k theme
ARG MIN="no"

RUN if [ "$MIN" = "no" ]; then \
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k && \
        sed -i '1 e cat /tmp/templates/p10k_init.zsh && cat /tmp/templates/zshrc_disable_flag.zsh' ~/.zshrc && \
        sed -i 's+ZSH_THEME="robbyrussell"+ZSH_THEME="powerlevel10k/powerlevel10k"+g' ~/.zshrc; \
    else \
        sed -i '1 e cat /tmp/templates/zshrc_disable_flag.zsh' ~/.zshrc; \
    fi && \
    echo "" >> ~/.zshrc && \
    cat /tmp/templates/gitpod_exports.zsh >> ~/.zshrc && \
    echo 'for i in $(ls $HOME/.bashrc.d/* | grep -v node); do source $i; done' >> ~/.zshrc && \
    echo "" >> ~/.zshrc && \
    if [ "$MIN" = "no" ]; then \
        cat /tmp/templates/p10k_config.zsh >> ~/.zshrc && \
        mv /tmp/templates/.p10k.zsh ~/.p10k.zsh; \
    fi && \
    rm -rf /tmp/templates

ENV SHELL='/bin/zsh'
