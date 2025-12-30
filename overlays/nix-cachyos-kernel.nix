final: prev:
let
	sources = import ../npins;
	cachyosKernels = import sources.cachyos-kernel;
	upstreamOverlay = cachyosKernels.overlays.default;
in upstreamOverlay final prev
