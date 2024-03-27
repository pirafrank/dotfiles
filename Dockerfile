FROM dotbot:base

ARG DOTFILES
ARG CONFIGURATION_FILE=install.conf.yaml

# switch to user
USER test
WORKDIR /home/test

RUN git clone ${DOTFILES} /home/test/dotfiles

RUN pip install --break-system-packages dotbot
RUN echo 'export PATH="/home/test/.local/bin:$PATH"' >> .bashrc

RUN /home/test/.local/bin/dotbot -d /home/test/dotfiles -c /home/test/dotfiles/${CONFIGURATION_FILE}

CMD [ "zsh" ]
