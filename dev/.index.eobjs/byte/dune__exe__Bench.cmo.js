(function(joo_global_object)
   {"use strict";
    var
     runtime=joo_global_object.jsoo_runtime,
     caml_jsstring_of_string=runtime.caml_jsstring_of_string,
     caml_string_of_jsbytes=runtime.caml_string_of_jsbytes;
    function caml_call1(f,a0)
     {return f.length == 1?f(a0):runtime.caml_call_gen(f,[a0])}
    function caml_call2(f,a0,a1)
     {return f.length == 2?f(a0,a1):runtime.caml_call_gen(f,[a0,a1])}
    function caml_call4(f,a0,a1,a2,a3)
     {return f.length == 4
              ?f(a0,a1,a2,a3)
              :runtime.caml_call_gen(f,[a0,a1,a2,a3])}
    function caml_call9(f,a0,a1,a2,a3,a4,a5,a6,a7,a8)
     {return f.length == 9
              ?f(a0,a1,a2,a3,a4,a5,a6,a7,a8)
              :runtime.caml_call_gen(f,[a0,a1,a2,a3,a4,a5,a6,a7,a8])}
    var
     global_data=runtime.caml_get_global_data(),
     cst_FPS=caml_string_of_jsbytes("FPS"),
     cst_Duration=caml_string_of_jsbytes("Duration"),
     cst_Frames=caml_string_of_jsbytes("Frames"),
     cst_ROM_path=caml_string_of_jsbytes("ROM path"),
     partial=
      [8,
       [0,0,0],
       0,
       0,
       [12,
        10,
        [2,
         [0,1,8],
         [11,caml_string_of_jsbytes(": "),[8,[0,0,0],0,0,[12,10,0]]]]]],
     cst_bench_result=caml_string_of_jsbytes("bench_result"),
     cst_tobu_gb=caml_string_of_jsbytes("tobu.gb"),
     cst_rom_path=caml_string_of_jsbytes("rom_path"),
     cst_1500=caml_string_of_jsbytes("1500"),
     cst_frames=caml_string_of_jsbytes("frames"),
     Stdlib_Printf=global_data.Stdlib__Printf,
     Brr=global_data.Brr,
     Fut=global_data.Fut,
     Jv=global_data.Jv,
     Brr_io=global_data.Brr_io,
     Camlboy_lib_Detect_cartridge=global_data.Camlboy_lib__Detect_cartridge,
     Camlboy_lib_Camlboy=global_data.Camlboy_lib__Camlboy,
     Stdlib_Option=global_data.Stdlib__Option,
     _a_=
      [0,
       [2,
        [0,1,8],
        [11,
         caml_string_of_jsbytes(": "),
         [2,
          0,
          [12,
           10,
           [2,
            [0,1,8],
            [11,
             caml_string_of_jsbytes(": "),
             [4,
              0,
              0,
              0,
              [12,10,[2,[0,1,8],[11,caml_string_of_jsbytes(": "),partial]]]]]]]]]],
       caml_string_of_jsbytes("%8s: %s\n%8s: %d\n%8s: %f\n%8s: %f\n")];
    function alert(v)
     {var _ak_=Jv[12],alert=_ak_.alert,_al_=Jv[23],_am_=caml_call1(_al_,v);
      alert(_am_);
      return 0}
    function find_el_by_id(id)
     {var
       _ag_=caml_jsstring_of_string(id),
       _ah_=Brr[16][2],
       _ai_=Brr[10][2],
       _aj_=caml_call2(_ai_,_ah_,_ag_);
      return caml_call1(Stdlib_Option[4],_aj_)}
    function run_rom_bytes(rom_bytes,frames)
     {var
       _Y_=Camlboy_lib_Detect_cartridge[1],
       cartridge=caml_call1(_Y_,rom_bytes),
       C=caml_call1(Camlboy_lib_Camlboy[1],cartridge),
       _Z_=0,
       ___=C[2],
       t=caml_call2(___,_Z_,rom_bytes),
       frame_count=[0,0],
       _$_=Brr[16][4],
       _aa_=Brr[15][9],
       _ab_=caml_call1(_aa_,_$_);
      for(;;)
       {if(frame_count[1] < frames)
         {var _ac_=C[3],match=caml_call1(_ac_,t);
          if(match)frame_count[1]++;
          continue}
        var _ad_=Brr[16][4],_ae_=Brr[15][9],_af_=caml_call1(_ae_,_ad_);
        return _af_ - _ab_}}
    function run_rom_blob(rom_blob,frames)
     {function _M_(result)
       {if(0 === result[0])
         {var
           buf=result[1],
           _P_=0,
           _Q_=0,
           _R_=3,
           _S_=Brr[1][5],
           _T_=caml_call4(_S_,_R_,_Q_,_P_,buf),
           rom_bytes=runtime.caml_ba_from_typed_array(_T_);
          return run_rom_bytes(rom_bytes,frames)}
        var
         e=result[1],
         _U_=0,
         _V_=Jv[30][4],
         _W_=[0,caml_call1(_V_,e),_U_],
         _X_=Brr[12][9];
        caml_call1(_X_,_W_);
        return 0.}
      var _N_=Brr[2][8],_O_=caml_call1(_N_,rom_blob);
      return caml_call2(Fut[15][3],_O_,_M_)}
    function run_rom_path(rom_path,frames)
     {function _w_(result)
       {if(0 === result[0])
         {var
           response=result[1],
           _B_=
            function(result)
             {if(0 === result[0])
               {var blob=result[1];return run_rom_blob(blob,frames)}
              var
               e=result[1],
               _I_=0,
               _J_=Jv[30][4],
               _K_=[0,caml_call1(_J_,e),_I_],
               _L_=Brr[12][9];
              caml_call1(_L_,_K_);
              return caml_call1(Fut[3],0.)},
           _C_=Brr_io[3][1][9],
           _D_=caml_call1(_C_,response);
          return caml_call2(Fut[15][1],_D_,_B_)}
        var
         e=result[1],
         _E_=0,
         _F_=Jv[30][4],
         _G_=[0,caml_call1(_F_,e),_E_],
         _H_=Brr[12][9];
        caml_call1(_H_,_G_);
        return caml_call1(Fut[3],0.)}
      var
       _x_=caml_jsstring_of_string(rom_path),
       _y_=0,
       _z_=Brr_io[3][7],
       _A_=caml_call2(_z_,_y_,_x_);
      return caml_call2(Fut[15][1],_A_,_w_)}
    function read_param(param_key,default$0)
     {var
       _p_=Brr[16][5],
       _q_=Brr[13][12],
       uri=caml_call1(_q_,_p_),
       _r_=Brr[6][6],
       _s_=caml_call1(_r_,uri),
       _t_=Brr[6][9][7],
       param=caml_call1(_t_,_s_),
       _u_=caml_jsstring_of_string(param_key),
       _v_=Brr[6][9][3],
       match=caml_call2(_v_,_u_,param);
      if(match)
       {var jstr=match[1];return runtime.caml_string_of_jsstring(jstr)}
      return default$0}
    function main(param)
     {var
       rom_path=read_param(cst_rom_path,cst_tobu_gb),
       _g_=read_param(cst_frames,cst_1500),
       frames=runtime.caml_int_of_string(_g_);
      function _h_(duration_ms)
       {var
         duration=duration_ms / 1000.,
         fps=frames / duration,
         _j_=Stdlib_Printf[4],
         msg=
          caml_call9
           (_j_,
            _a_,
            cst_ROM_path,
            rom_path,
            cst_Frames,
            frames,
            cst_Duration,
            duration,
            cst_FPS,
            fps),
         result_el=find_el_by_id(cst_bench_result),
         _k_=0,
         _l_=caml_jsstring_of_string(msg),
         _m_=0,
         _n_=Brr[9][2],
         _o_=[0,caml_call2(_n_,_m_,_l_),_k_];
        return caml_call2(Brr[9][18],result_el,_o_)}
      var _i_=run_rom_path(rom_path,frames);
      return caml_call2(Fut[15][3],_i_,_h_)}
    function _b_(_f_){return _f_}
    var _c_=0,_d_=main(_c_),_e_=Fut[2];
    caml_call2(_e_,_d_,_b_);
    var
     Dune_exe_Bench=
      [0,
       alert,
       find_el_by_id,
       run_rom_bytes,
       run_rom_blob,
       run_rom_path,
       read_param,
       main];
    runtime.caml_register_global(23,Dune_exe_Bench,"Dune__exe__Bench");
    return}
  (function(){return this}()));

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLjAsImZpbGUiOiIuaW5kZXguZW9ianMvYnl0ZS9kdW5lX19leGVfX0JlbmNoLmNtby5qcyIsInNvdXJjZVJvb3QiOiIiLCJuYW1lcyI6WyJhbGVydCIsInYiLCJmaW5kX2VsX2J5X2lkIiwiaWQiLCJydW5fcm9tX2J5dGVzIiwicm9tX2J5dGVzIiwiZnJhbWVzIiwiY2FydHJpZGdlIiwidCIsImZyYW1lX2NvdW50IiwicnVuX3JvbV9ibG9iIiwicm9tX2Jsb2IiLCJyZXN1bHQiLCJidWYiLCJlIiwicnVuX3JvbV9wYXRoIiwicm9tX3BhdGgiLCJyZXNwb25zZSIsImJsb2IiLCJyZWFkX3BhcmFtIiwicGFyYW1fa2V5IiwiZGVmYXVsdCQwIiwidXJpIiwicGFyYW0iLCJqc3RyIiwibWFpbiIsImR1cmF0aW9uX21zIiwiZHVyYXRpb24iLCJmcHMiLCJtc2ciLCJyZXN1bHRfZWwiXSwic291cmNlcyI6WyIvaG9tZS9ydW5uZXIvd29yay9DQU1MQk9ZL0NBTUxCT1kvX2J1aWxkLWRldi9kZWZhdWx0L2Jpbi93ZWIvYmVuY2gubWwiXSwibWFwcGluZ3MiOiI7O0k7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7O2FBS0lBLE1BQU1DO01BQ1IsZ0JBQVksNkJBQ21CLHFCQUZ2QkE7TUFFRTtjQUFtQzthQUUzQ0MsY0FBY0M7TUFBdUM7b0NBQXZDQTtPQUF1Qzs7T0FBbEM7OENBQTJEO2FBRTlFQyxjQUFjQyxVQUFVQztNQUMxQjs7T0FBZ0IseUJBREFEO09BQ0Esb0NBQVpFO09BQVk7O09BRVAscUJBSE9GO09BR1A7OztPQUVZOztXQURqQkksaUJBSnNCSDtVQU94QixjQUFNLHNCQUpKRTtVQUlJLFNBRWE7O1FBRXJCO1FBQWtDLG1CQUFlO2FBRS9DRSxhQUFhQyxTQUFTTDtNQUN4QixhQUFLTTtRQUNMLFNBREtBO1VBR0g7ZUFIR0E7V0FHSDs7OztXQUNFLCtCQUZDQztXQUV5QjsrQkFEeEJSLFVBSmtCQztRQVl0QjtXQVhHTTtTQVdIOztTQUFjLHNCQURSRTtTQUNRO1FBQUw7aUJBQ1A7TUFaSixrQkFBYyxtQkFEQ0g7TUFDRCxxQ0FZVjthQUVGSSxhQUFhQyxTQUFTVjtNQUN4QixhQUFLTTtRQUNMLFNBREtBO1VBR0g7b0JBSEdBO1dBR0g7cUJBQ0tBO2NBQ0wsU0FES0E7Z0JBR0QsSUFER00sS0FGRk4sVUFHRCxvQkFER00sS0FQZVo7Y0FVbEI7aUJBTENNO2VBS0Q7O2VBQWMsc0JBRFJFO2VBQ1E7Y0FBTDswQ0FFVjtXQVJIO1dBQ2MsbUJBRlhHO1VBRVc7UUFTZDtXQWJHTDtTQWFIOztTQUFjLHNCQURSRTtTQUNRO1FBQUw7b0NBQ0k7TUFkUzttQ0FEVEU7T0FDUzs7T0FBVjsyQ0FjQzthQUViRyxXQUFXQyxVQUFXQztNQUN4Qjs7O09BQVU7O09BRVIsbUJBRkVDO09BRUY7O09BSTBCLDRCQVBmRjtPQU9lO09BQXRCLHlCQUxGRztNQUtFO1FBQ1MsSUFBUkMsY0FBUSx1Q0FBUkE7TUFDRyxPQVRjSCxTQVNQO2FBRWZJO01BRWE7O09BQ0Y7T0FBbUM7bUJBRTNDQztRQUNVO2tCQURWQTtTQUV5QixJQUoxQnBCLFNBR0FxQjtTQUMwQjtTQUNwQjs7Ozs7WUFOTlg7O1lBQ0FWOztZQUdBcUI7O1lBQ0FDO1NBT1k7O1NBQ2tCLDRCQVA5QkM7U0FPOEI7O1NBQVA7cUNBRHZCQyxjQUMyQztNQVY1QixxQkFIZmQsU0FDQVY7TUFFZSxxQ0FVNEI7c0JBVC9DLFVBUytDO0lBRTlCO0lBQVY7SUFBVTs7O09BL0VmTjtPQUlBRTtPQUVBRTtPQWFBTTtPQWVBSztPQWlCQUk7T0FXQU07SUFpQks7VSIsInNvdXJjZXNDb250ZW50IjpbIm9wZW4gQ2FtbGJveV9saWJcbm9wZW4gQnJyXG5vcGVuIEJycl9pb1xub3BlbiBGdXQuU3ludGF4XG5cbmxldCBhbGVydCB2ID1cbiAgbGV0IGFsZXJ0ID0gSnYuZ2V0IEp2Lmdsb2JhbCBcImFsZXJ0XCIgaW5cbiAgaWdub3JlIEBAIEp2LmFwcGx5IGFsZXJ0IEp2Llt8IG9mX3N0cmluZyB2IHxdXG5cbmxldCBmaW5kX2VsX2J5X2lkIGlkID0gRG9jdW1lbnQuZmluZF9lbF9ieV9pZCBHLmRvY3VtZW50IChKc3RyLnYgaWQpIHw+IE9wdGlvbi5nZXRcblxubGV0IHJ1bl9yb21fYnl0ZXMgcm9tX2J5dGVzIGZyYW1lcyA9XG4gIGxldCBjYXJ0cmlkZ2UgPSBEZXRlY3RfY2FydHJpZGdlLmYgfnJvbV9ieXRlcyBpblxuICBsZXQgbW9kdWxlIEMgPSBDYW1sYm95Lk1ha2UodmFsIGNhcnRyaWRnZSkgaW5cbiAgbGV0IHQgPSAgQy5jcmVhdGVfd2l0aF9yb20gfnByaW50X3NlcmlhbF9wb3J0OmZhbHNlIH5yb21fYnl0ZXMgaW5cbiAgbGV0IGZyYW1lX2NvdW50ID0gcmVmIDAgaW5cbiAgbGV0IHN0YXJ0X3RpbWUgPSByZWYgKFBlcmZvcm1hbmNlLm5vd19tcyBHLnBlcmZvcm1hbmNlKSBpblxuICB3aGlsZSAhZnJhbWVfY291bnQgPCBmcmFtZXMgZG9cbiAgICBtYXRjaCBDLnJ1bl9pbnN0cnVjdGlvbiB0IHdpdGhcbiAgICB8IEluX2ZyYW1lIC0+ICgpXG4gICAgfCBGcmFtZV9lbmRlZCBfIC0+IGluY3IgZnJhbWVfY291bnRcbiAgZG9uZTtcbiAgKFBlcmZvcm1hbmNlLm5vd19tcyBHLnBlcmZvcm1hbmNlKSAtLiAhc3RhcnRfdGltZVxuXG5sZXQgcnVuX3JvbV9ibG9iIHJvbV9ibG9iIGZyYW1lcyA9XG4gIGxldCsgcmVzdWx0ID0gQmxvYi5hcnJheV9idWZmZXIgcm9tX2Jsb2IgaW5cbiAgbWF0Y2ggcmVzdWx0IHdpdGhcbiAgfCBPayBidWYgLT5cbiAgICBsZXQgcm9tX2J5dGVzID1cbiAgICAgIFRhcnJheS5vZl9idWZmZXIgVWludDggYnVmXG4gICAgICB8PiBUYXJyYXkudG9fYmlnYXJyYXkxXG4gICAgICAoKiBDb252ZXJ0IHVpbnQ4IGJpZ2FycmF5IHRvIGNoYXIgYmlnYXJyYXkgKilcbiAgICAgIHw+IE9iai5tYWdpY1xuICAgIGluXG4gICAgcnVuX3JvbV9ieXRlcyByb21fYnl0ZXMgZnJhbWVzXG4gIHwgRXJyb3IgZSAtPlxuICAgIENvbnNvbGUuKGxvZyBbSnYuRXJyb3IubWVzc2FnZSBlXSk7XG4gICAgMC5cblxubGV0IHJ1bl9yb21fcGF0aCByb21fcGF0aCBmcmFtZXMgPVxuICBsZXQqIHJlc3VsdCA9IEZldGNoLnVybCAoSnN0ci52IHJvbV9wYXRoKSBpblxuICBtYXRjaCByZXN1bHQgd2l0aFxuICB8IE9rIHJlc3BvbnNlIC0+XG4gICAgbGV0IGJvZHkgPSBGZXRjaC5SZXNwb25zZS5hc19ib2R5IHJlc3BvbnNlIGluXG4gICAgbGV0KiByZXN1bHQgPSBGZXRjaC5Cb2R5LmJsb2IgYm9keSBpblxuICAgIGJlZ2luIG1hdGNoIHJlc3VsdCB3aXRoXG4gICAgICB8IE9rIGJsb2IgLT5cbiAgICAgICAgcnVuX3JvbV9ibG9iIGJsb2IgZnJhbWVzXG4gICAgICB8IEVycm9yIGUgIC0+XG4gICAgICAgIENvbnNvbGUuKGxvZyBbSnYuRXJyb3IubWVzc2FnZSBlXSk7XG4gICAgICAgIEZ1dC5yZXR1cm4gMC5cbiAgICBlbmRcbiAgfCBFcnJvciBlICAtPlxuICAgIENvbnNvbGUuKGxvZyBbSnYuRXJyb3IubWVzc2FnZSBlXSk7XG4gICAgRnV0LnJldHVybiAwLlxuXG5sZXQgcmVhZF9wYXJhbSBwYXJhbV9rZXkgfmRlZmF1bHQgPVxuICBsZXQgdXJpID0gV2luZG93LmxvY2F0aW9uIEcud2luZG93IGluXG4gIGxldCBwYXJhbSA9XG4gICAgdXJpXG4gICAgfD4gVXJpLnF1ZXJ5XG4gICAgfD4gVXJpLlBhcmFtcy5vZl9qc3RyXG4gIGluXG4gIG1hdGNoIFVyaS5QYXJhbXMuZmluZCBKc3RyLih2IHBhcmFtX2tleSkgcGFyYW0gd2l0aFxuICB8IFNvbWUganN0ciAtPiBKc3RyLnRvX3N0cmluZyBqc3RyXG4gIHwgTm9uZSAtPiBkZWZhdWx0XG5cbmxldCBtYWluICgpID1cbiAgKCogUmVhZCBVUkwgcGFyYW1ldGVycyAqKVxuICBsZXQgcm9tX3BhdGggPSByZWFkX3BhcmFtIFwicm9tX3BhdGhcIiB+ZGVmYXVsdDpcInRvYnUuZ2JcIiBpblxuICBsZXQgZnJhbWVzID0gcmVhZF9wYXJhbSBcImZyYW1lc1wiIH5kZWZhdWx0OlwiMTUwMFwiIHw+IGludF9vZl9zdHJpbmcgaW5cbiAgKCogTG9hZCBpbml0aWFsIHJvbSAqKVxuICBsZXQrIGR1cmF0aW9uX21zID0gcnVuX3JvbV9wYXRoIHJvbV9wYXRoIGZyYW1lcyBpblxuICBsZXQgZHVyYXRpb24gPSBkdXJhdGlvbl9tcyAvLiAxMDAwLiBpblxuICBsZXQgZnBzID0gRmxvYXQuKG9mX2ludCBmcmFtZXMgLy4gZHVyYXRpb24pIGluXG4gIGxldCBtc2cgPSBQcmludGYuc3ByaW50ZiBcIiU4czogJXNcXG4lOHM6ICVkXFxuJThzOiAlZlxcbiU4czogJWZcXG5cIlxuICAgICAgXCJST00gcGF0aFwiIHJvbV9wYXRoXG4gICAgICBcIkZyYW1lc1wiIGZyYW1lc1xuICAgICAgXCJEdXJhdGlvblwiIGR1cmF0aW9uXG4gICAgICBcIkZQU1wiIGZwc1xuICBpblxuICBsZXQgcmVzdWx0X2VsID0gZmluZF9lbF9ieV9pZCBcImJlbmNoX3Jlc3VsdFwiIGluXG4gIEVsLnNldF9jaGlsZHJlbiByZXN1bHRfZWwgW0VsLnR4dCAoSnN0ci52IG1zZyldXG5cbmxldCAoKSA9IEZ1dC5hd2FpdCAobWFpbiAoKSkgRnVuLmlkXG4iXX0=
