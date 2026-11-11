let
  nix-lab-github = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC1zzisuTr+RYuzWFnsHdaBsGuSULTGq5Dvkua8Y7dlR";
  nix-lab-sys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHZLhpfX9/QXTRGlAhag4JEy/+qWbcCnTFVwU7kzqWOB";
  users = [
    nix-lab-github
  ];
  systems = [
    nix-lab-sys
  ];
in
{
  "secrets/proton.key.age".publicKeys = users ++ systems;
  "secrets/grafana.key.age".publicKeys = users ++ systems;
}
