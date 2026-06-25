{ ... }:

{
  # Ollama local LLM runtime, CUDA-accelerated on the NVIDIA GPU
  services.ollama = {
    enable = true;
    acceleration = "cuda";
  };
}
