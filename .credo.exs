%{
  configs: [
    %{
      name: "default",
      checks: [
        {Credo.Check.Readability.SinglePipe, allow_0_arity_functions: true}
      ]
    }
  ]
}
