{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
}:

buildGoModule rec {
  pname = "kubectl-ketall";
  version = "1.3.8";

  src = fetchFromGitHub {
    owner = "corneliusweig";
    repo = "ketall";
    rev = "v${version}";
    hash = "sha256-Mau57mXS78fHyeU0OOz3Tms0WNu7HixfAZZL3dmcj3w=";
  };

  vendorHash = "sha256-lxfWJ7t/IVhIfvDUIESakkL8idh+Q/wl8B1+vTpb5a4=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/corneliusweig/ketall/internal/version.version=v${version}"
    "-X github.com/corneliusweig/ketall/internal/version.buildDate=1970-01-01T00:00:00Z"
    "-X github.com/corneliusweig/ketall/internal/version.gitCommit=${src.rev}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  patchPhase = ''
    sed -i 's/CommandName = "ketall"/CommandName = "${pname}"/' cmd/internal/cmdname_ketall.go
    sed -i 's/$ ketall/${pname}/' cmd/root.go
  '';

  installPhase = ''
    runHook preInstall

    install -D $GOPATH/bin/ketall -T $out/bin/kubectl-ketall

    installShellCompletion --cmd kubectl-ketall \
      --bash <($out/bin/kubectl-ketall completion bash) \
      --fish <($out/bin/kubectl-ketall completion fish) \
      --zsh <($out/bin/kubectl-ketall completion zsh)

    runHook postInstall
  '';

  meta = with lib; {
    description = "Like `kubectl get all`, but get really all resources";
    mainProgram = "kubectl-ketall";
    homepage = "https://github.com/corneliusweig/ketall";
    changelog = "https://github.com/corneliusweig/ketall/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.angaz ];
  };
}
