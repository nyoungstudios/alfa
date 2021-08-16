# pass in image name as a build argument lile this:
# docker build --build-arg imagename=gitpod/workspace-full:latest .
ARG imagename
FROM $imagename

# installs oh my zsh
ARG RUNZSH="no"
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
    rm -rf ~/.zshrc.pre-oh-my-zsh

# installs powerlevel10k
COPY --chown=gitpod templates /tmp/templates

RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k && \
    sed -i '1 e cat /tmp/templates/p10k_init.zsh && cat /tmp/templates/zshrc_disable_flag.zsh' ~/.zshrc && \
    sed -i 's+ZSH_THEME="robbyrussell"+ZSH_THEME="powerlevel10k/powerlevel10k"+g' ~/.zshrc && \
    echo "" >> ~/.zshrc && \
    cat /tmp/templates/p10k_config.zsh >> ~/.zshrc && \
    mv /tmp/templates/.p10k.zsh ~/.p10k.zsh && \
    rm -rf /tmp/templates

ENV SHELL='/bin/zsh'
