return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- LSPs
        "ansible-language-server",
        "bash-language-server",
        "clangd",
        "cmake-language-server",
        "docker-compose-language-service",
        "dockerfile-language-server",
        "lua-language-server",
        "marksman",
        "neocmakelsp",
        "pyright",
        "rust-analyzer",
        "taplo",
        "yaml-language-server",

        -- Formatters
        "clang-format",
        "cmakelang",
        "prettier",
        "shfmt",
        "stylua",

        -- Linters
        "ansible-lint",
        "cmakelint",
        "cpplint",
        "hadolint",
        "markdownlint-cli2",
        "pylint",
        "ruff",
        "shellcheck",
        "sqlfluff",

        -- Debuggers
        "codelldb",
        "debugpy",

        -- Other tools
        "markdown-toc",
      },
    },
  },
}
