FROM node:20-alpine

# Install system dependencies
RUN apk add --no-cache \
    bash \
    git \
    curl \
    github-cli

# Install Claude Code CLI
RUN npm install -g @anthropic-ai/claude-code

# Create workspace directory and set ownership to node user
RUN mkdir -p /workspace && chown -R node:node /workspace

# Copy entrypoint script (as root to ensure proper ownership)
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && chown node:node /entrypoint.sh

# Switch to node user for execution
# This allows Claude Code to use --dangerously-skip-permissions
# (which is blocked when running as root for security)
USER node

# Set working directory
WORKDIR /workspace

ENTRYPOINT ["/entrypoint.sh"]
