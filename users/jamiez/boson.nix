{ inputs, ... }: {
  imports = with inputs.self.homeModules; [ i3 kube ];
}
