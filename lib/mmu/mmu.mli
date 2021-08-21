module Make (Gpu : Addressable_intf.S) : sig

  type t

  val create :
    rom:Rom.t ->
    wram:Ram.t ->
    gpu:Gpu.t ->
    zero_page:Ram.t ->
    shadow_ram:Shadow_ram.t ->
    t

  include Word_addressable_intf.S with type t := t

end
