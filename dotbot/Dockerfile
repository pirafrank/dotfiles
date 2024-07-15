FROM pirafrank/dotbot:latest

ARG DOTFILES=https://github.com/pirafrank/dotfiles.git
ARG CONFIGURATION_FILE=install.conf.yaml

# switch to user
USER work
WORKDIR /home/work

RUN git clone ${DOTFILES} /home/work/dotfiles

RUN pip install --break-system-packages dotbot
RUN echo 'export PATH="/home/work/.local/bin:$PATH"' >> .bashrc

RUN /home/work/.local/bin/dotbot -d /home/work/dotfiles -c /home/work/dotfiles/${CONFIGURATION_FILE}

CMD [ "zsh" ]
