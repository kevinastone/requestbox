%{
  configs: [
    %{
      name: "default",
      files: %{
        #
        # you can give explicit globs or simply directories
        # in the latter case `**/*.{ex,exs}` will be used
        included: ["lib/", "src/", "web/", "test/"],
        excluded: []
      },
      checks: [
        {Credo.Check.Readability.MaxLineLength, false},
        {Credo.Check.Readability.ModuleDoc, false},
        {Credo.Check.Refactor.PipeChainStart, false},
        {Credo.Check.Design.AliasUsage, false}
      ]
    }
  ]
}
