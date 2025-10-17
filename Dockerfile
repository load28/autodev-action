FROM node:20-alpine

# Install system dependencies
RUN apk add --no-cache \
    bash \
    git \
    curl \
    github-cli

# Install Claude Code CLI
RUN npm install -g @anthropic-ai/claude-code

# Configure Claude Code to bypass permissions in CI environment
# This is safe because:
# 1. Running in isolated Docker container
# 2. Workspace is GitHub Actions checkout (temporary)
# 3. No sensitive credentials in workspace
RUN mkdir -p /root/.claude && \
    echo '{"permissions":{"defaultMode":"bypassPermissions"}}' > /root/.claude/settings.json

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set working directory
WORKDIR /workspace

ENTRYPOINT ["/entrypoint.sh"]
