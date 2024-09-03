# Base image
FROM ubuntu:22.04

# Update package lists and install dependencies
RUN apt update && apt install -y nginx less curl sudo zip file figlet \
    && useradd -ms /bin/bash ctfuser \
    && usermod -aG sudo ctfuser \
    && mkdir -p /nowhere \
    && curl -sS https://starship.rs/install.sh | sh -s -- -y \
    && echo 'eval "$(starship init bash)"' >> /home/ctfuser/.bashrc \
    && rm -rf /home/ctfuser/.cache

# Set up environment variables
ENV YELLOW="\e[33m" \
    RED="\033[0;31m" \
    STARSHIP_CONFIG=/home/ctfuser/.config/.starship.toml

# Copy files to the container
ADD config/index.html /var/www/html/index.html
ADD config/starship.toml /home/ctfuser/.config/.starship.toml
ADD config/.secret /home/ctfuser/.secret
ADD config/Instruction /nowhere
ADD config/ctfchallenge /etc/sudoers.d
ADD config/bash.bashrc /etc/

# Change ownership and permissions
RUN chown -R ctfuser:ctfuser /home/ctfuser \
    && chmod 0600 /var/www/html/index.html \
    && chmod 0000 /home/ctfuser/.secret \
    && chown www-data /var/www/html/index.html

RUN chmod 000 /home/ctfuser/.secret \
    && apt remove -y curl

# Set working directory
WORKDIR /nowhere

USER ctfuser

# Expose port 80
EXPOSE 80

# # Set entry point
# ENTRYPOINT ["bash"]

# Default command
CMD ["bash"]
