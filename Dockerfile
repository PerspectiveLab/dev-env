FROM archlinux:latest
COPY base-pkgs.txt /tmp/base-pkgs.txt
COPY aur-pkgs.txt /tmp/aur-pkgs.txt

# Install base image packages
RUN pacman -Syu --noconfirm \
    && pacman -S --noconfirm base-devel git curl unzip

# Create a fully priviledged user
RUN useradd -ms /bin/zsh dev \
    && passwd -d dev \
    && echo "dev ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/dev

# Switch to the new user
USER dev
WORKDIR /home/dev

# Install AUR helper and flutter (mandatory)
RUN git clone https://aur.archlinux.org/yay-bin.git \
    && cd yay-bin \
    && makepkg -si --noconfirm \
    && yay -S --noconfirm flutter

# Setup zsh config
RUN git clone https://github.com/chinarjoshi/dotfiles /tmp/dotfiles \
    && mv /tmp/dotfiles/zsh ~/.config/zsh \
    && echo 'export ZDOTDIR=~/.config/zsh' > ~/.zshenv

# Setup neovim config
RUN git clone https://github.com/chinarjoshi/nvdev ~/.config/nvim

# Install rest of packages
RUN cat /tmp/aur-pkgs.txt | xargs yay -S --noconfirm
RUN cat /tmp/base-pkgs.txt | xargs sudo pacman -S --noconfirm

# Clean up files
RUN sudo rm -rf /tmp/*

# Enter shell
CMD ["zsh"]
