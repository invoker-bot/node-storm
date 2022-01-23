#include <napi.h>

class NodeStormAddon : public Napi::Addon<NodeStormAddon> {
 public:
  NodeStormAddon(Napi::Env env, Napi::Object exports) {
    DefineAddon(exports, {});
  }
 private:

};

NODE_API_ADDON(NodeStormAddon)
