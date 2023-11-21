FROM archlinux:latest

# Install base image packages
RUN pacman -Syu --noconfirm \
    && pacman -S --noconfirm base-devel git curl unzip zsh

# Create a fully priviledged user
RUN useradd -ms /bin/zsh dev \
    && passwd -d dev \
    && echo "dev ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/dev

# Switch to the new user
USER dev
WORKDIR /home/dev

# Install AUR helper and flutter (mandatory)
RUN git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin \
    && cd /tmp/yay-bin \
    && makepkg -si --noconfirm
RUN yay -S --noconfirm flutter

# Setup zsh config
RUN git clone https://github.com/chinarjoshi/dotfiles /tmp/dotfiles \
    && mv /tmp/dotfiles/zsh ~/.config/zsh \
    && echo 'export ZDOTDIR=~/.config/zsh' > ~/.zshenv
COPY p10k-instant-prompt.zsh /home/dev/.cache/p10k-instant-prompt-c.zsh
COPY gitstatusd /home/dev/.cache/gitstatus/gitstatusd-linux-x86_64
RUN sudo chown dev /home/dev/.cache/*

# Setup neovim config
RUN sudo pacman -S --noconfirm neovim
RUN git clone https://github.com/chinarjoshi/nvdev ~/.config/nvim
RUN nvim -c 'q'

# Install rest of packages
COPY pkgs.txt /tmp/pkgs.txt
RUN cat /tmp/pkgs.txt | xargs yay -S --noconfirm

# Clean up files
RUN sudo rm -rf /tmp/*

# Enter shell
CMD ["zsh"]
