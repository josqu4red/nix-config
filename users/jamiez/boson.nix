{ inputs, ... }: {
  imports = with inputs.self.homeConfigs; [ i3 ];
}
