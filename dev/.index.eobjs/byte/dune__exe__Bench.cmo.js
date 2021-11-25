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
     cst_rom_path=caml_string_of_jsbytes("rom_path"),
     cst_frames=caml_string_of_jsbytes("frames"),
     Stdlib_Printf=global_data.Stdlib__Printf,
     Brr=global_data.Brr,
     Stdlib=global_data.Stdlib,
     Jv=global_data.Jv,
     Fut=global_data.Fut,
     Brr_io=global_data.Brr_io,
     Camlboy_lib_Detect_cartridge=global_data.Camlboy_lib__Detect_cartridge,
     Camlboy_lib_Camlboy=global_data.Camlboy_lib__Camlboy,
     Stdlib_Option=global_data.Stdlib__Option,
     _d_=
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
       caml_string_of_jsbytes("%8s: %s\n%8s: %d\n%8s: %f\n%8s: %f\n")],
     _a_=
      [0,
       [11,
        caml_string_of_jsbytes("Parameter "),
        [2,0,[11,caml_string_of_jsbytes(" missing in URL"),0]]],
       caml_string_of_jsbytes("Parameter %s missing in URL")];
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
     {function _L_(result)
       {if(0 === result[0])
         {var
           buf=result[1],
           _O_=0,
           _P_=0,
           _Q_=3,
           _R_=Brr[1][5],
           _S_=caml_call4(_R_,_Q_,_P_,_O_,buf),
           rom_bytes=runtime.caml_ba_from_typed_array(_S_),
           _T_=run_rom_bytes(rom_bytes,frames);
          return caml_call1(Fut[3],_T_)}
        var
         e=result[1],
         _U_=0,
         _V_=Jv[30][4],
         _W_=[0,caml_call1(_V_,e),_U_],
         _X_=Brr[12][9];
        caml_call1(_X_,_W_);
        return caml_call1(Fut[3],0.)}
      var _M_=Brr[2][8],_N_=caml_call1(_M_,rom_blob);
      return caml_call2(Fut[15][1],_N_,_L_)}
    function run_rom_path(rom_path,frames)
     {function _v_(result)
       {if(0 === result[0])
         {var
           response=result[1],
           _A_=
            function(result)
             {if(0 === result[0])
               {var blob=result[1];return run_rom_blob(blob,frames)}
              var
               e=result[1],
               _H_=0,
               _I_=Jv[30][4],
               _J_=[0,caml_call1(_I_,e),_H_],
               _K_=Brr[12][9];
              caml_call1(_K_,_J_);
              return caml_call1(Fut[3],0.)},
           _B_=Brr_io[3][1][9],
           _C_=caml_call1(_B_,response);
          return caml_call2(Fut[15][1],_C_,_A_)}
        var
         e=result[1],
         _D_=0,
         _E_=Jv[30][4],
         _F_=[0,caml_call1(_E_,e),_D_],
         _G_=Brr[12][9];
        caml_call1(_G_,_F_);
        return caml_call1(Fut[3],0.)}
      var
       _w_=caml_jsstring_of_string(rom_path),
       _x_=0,
       _y_=Brr_io[3][7],
       _z_=caml_call2(_y_,_x_,_w_);
      return caml_call2(Fut[15][1],_z_,_v_)}
    function read_param(param_key)
     {var
       _l_=Brr[16][5],
       _m_=Brr[13][12],
       uri=caml_call1(_m_,_l_),
       _n_=Brr[6][6],
       _o_=caml_call1(_n_,uri),
       _p_=Brr[6][9][7],
       _q_=caml_call1(_p_,_o_),
       _r_=caml_jsstring_of_string(param_key),
       _s_=Brr[6][9][3],
       _t_=caml_call1(_s_,_r_),
       param=caml_call1(_t_,_q_);
      if(param)
       {var jstr=param[1];return runtime.caml_string_of_jsstring(jstr)}
      var _u_=Stdlib_Printf[4],msg=caml_call2(_u_,_a_,param_key);
      alert(msg);
      return caml_call1(Stdlib[2],msg)}
    var
     rom_path=read_param(cst_rom_path),
     _b_=read_param(cst_frames),
     frames=runtime.caml_int_of_string(_b_),
     fut=run_rom_path(rom_path,frames);
    function _c_(duration_ms)
     {var
       duration=duration_ms / 1000.,
       fps=frames / duration,
       _f_=Stdlib_Printf[4],
       msg=
        caml_call9
         (_f_,
          _d_,
          cst_ROM_path,
          rom_path,
          cst_Frames,
          frames,
          cst_Duration,
          duration,
          cst_FPS,
          fps),
       result_el=find_el_by_id(cst_bench_result),
       _g_=0,
       _h_=caml_jsstring_of_string(msg),
       _i_=0,
       _j_=Brr[9][2],
       _k_=[0,caml_call2(_j_,_i_,_h_),_g_];
      return caml_call2(Brr[9][18],result_el,_k_)}
    var _e_=Fut[2];
    caml_call2(_e_,fut,_c_);
    var
     Dune_exe_Bench=
      [0,
       alert,
       find_el_by_id,
       run_rom_bytes,
       run_rom_blob,
       run_rom_path,
       read_param];
    runtime.caml_register_global(23,Dune_exe_Bench,"Dune__exe__Bench");
    return}
  (function(){return this}()));

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLjAsImZpbGUiOiIuaW5kZXguZW9ianMvYnl0ZS9kdW5lX19leGVfX0JlbmNoLmNtby5qcyIsInNvdXJjZVJvb3QiOiIiLCJuYW1lcyI6WyJhbGVydCIsInYiLCJmaW5kX2VsX2J5X2lkIiwiaWQiLCJydW5fcm9tX2J5dGVzIiwicm9tX2J5dGVzIiwiZnJhbWVzIiwiY2FydHJpZGdlIiwidCIsImZyYW1lX2NvdW50IiwicnVuX3JvbV9ibG9iIiwicm9tX2Jsb2IiLCJyZXN1bHQiLCJidWYiLCJlIiwicnVuX3JvbV9wYXRoIiwicm9tX3BhdGgiLCJyZXNwb25zZSIsImJsb2IiLCJyZWFkX3BhcmFtIiwicGFyYW1fa2V5IiwidXJpIiwicGFyYW0iLCJqc3RyIiwibXNnIiwiZnV0IiwiZHVyYXRpb25fbXMiLCJkdXJhdGlvbiIsImZwcyIsInJlc3VsdF9lbCJdLCJzb3VyY2VzIjpbIi9ob21lL3J1bm5lci93b3JrL0NBTUxCT1kvQ0FNTEJPWS9fYnVpbGQtZGV2L2RlZmF1bHQvYmluL3dlYi9iZW5jaC5tbCJdLCJtYXBwaW5ncyI6Ijs7STs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7OzthQUtJQSxNQUFNQztNQUNSLGdCQUFZLDZCQUNtQixxQkFGdkJBO01BRUU7Y0FBbUM7YUFFM0NDLGNBQWNDO01BQXVDO29DQUF2Q0E7T0FBdUM7O09BQWxDOzhDQUEyRDthQUU5RUMsY0FBY0MsVUFBVUM7TUFDMUI7O09BQWdCLHlCQURBRDtPQUNBLG9DQUFaRTtPQUFZOztPQUVQLHFCQUhPRjtPQUdQOzs7T0FFWTs7V0FEakJJLGlCQUpzQkg7VUFPeEIsY0FBTSxzQkFKSkU7VUFJSSxTQUVhOztRQUVyQjtRQUFrQyxtQkFBZTthQUUvQ0UsYUFBYUMsU0FBU0w7TUFDeEIsYUFBS007UUFDTCxTQURLQTtVQUdIO2VBSEdBO1dBR0g7Ozs7V0FDRSwrQkFGQ0M7V0FFeUI7V0FLZCxrQkFOVlIsVUFKa0JDO1VBVVI7UUFFZDtXQVhHTTtTQVdIOztTQUFjLHNCQURSRTtTQUNRO1FBQUw7b0NBQ0k7TUFaZixrQkFBYyxtQkFEQ0g7TUFDRCxxQ0FZQzthQUViSSxhQUFhQyxTQUFTVjtNQUN4QixhQUFLTTtRQUNMLFNBREtBO1VBR0g7b0JBSEdBO1dBR0g7cUJBQ0tBO2NBQ0wsU0FES0E7Z0JBRVUsSUFBUk0sS0FGRk4sVUFFVSxvQkFBUk0sS0FQZVo7Y0FRTjtpQkFIWE07ZUFHVzs7ZUFBYyxzQkFBcEJFO2VBQW9CO2NBQUw7MENBQ3RCO1dBTEg7V0FDYyxtQkFGWEc7VUFFVztRQUtGO1dBVFRMO1NBU1M7O1NBQWMsc0JBQXBCRTtTQUFvQjtRQUFMO29DQUF3QztNQVR2QzttQ0FEVEU7T0FDUzs7T0FBVjsyQ0FTaUQ7YUFFN0RHLFdBQVdDO01BQ2I7OztPQUFVOztPQUVSLG1CQUZFQztPQUVGOztPQUd5Qiw0QkFOZEQ7T0FNYztPQUF0QjtPQUFrQztTQUpuQ0U7UUFPVyxJQUFSQyxLQVBIRCxTQU9XLHVDQUFSQztNQVJQLElBVUUscUJBQVUsdUJBWENIO01BWVgsTUFESUk7TUFDSiw0QkFESUEsSUFFUTtJQUtDOztLQUNGO0tBQW1CO0tBRXRCLGlCQUhOUixTQUNBVjtJQUVNLGFBQ1NvQjtNQUNBO2dCQURBQTtPQUVlLElBTDlCcEIsU0FJSXFCO09BQzBCO09BQ3BCOzs7OztVQVBWWDs7VUFDQVY7O1VBSUlxQjs7VUFDQUM7T0FPWTs7T0FDa0IsNEJBUDlCSjtPQU84Qjs7T0FBUDttQ0FEdkJLLGNBQzJDO0lBWHpDO0lBQ1YsZUFESUo7SUFBTTs7O09BbkVSekI7T0FJQUU7T0FFQUU7T0FhQU07T0FlQUs7T0FZQUk7SUFzQkY7VSIsInNvdXJjZXNDb250ZW50IjpbIm9wZW4gQ2FtbGJveV9saWJcbm9wZW4gQnJyXG5vcGVuIEJycl9pb1xub3BlbiBGdXQuU3ludGF4XG5cbmxldCBhbGVydCB2ID1cbiAgbGV0IGFsZXJ0ID0gSnYuZ2V0IEp2Lmdsb2JhbCBcImFsZXJ0XCIgaW5cbiAgaWdub3JlIEBAIEp2LmFwcGx5IGFsZXJ0IEp2Llt8IG9mX3N0cmluZyB2IHxdXG5cbmxldCBmaW5kX2VsX2J5X2lkIGlkID0gRG9jdW1lbnQuZmluZF9lbF9ieV9pZCBHLmRvY3VtZW50IChKc3RyLnYgaWQpIHw+IE9wdGlvbi5nZXRcblxubGV0IHJ1bl9yb21fYnl0ZXMgcm9tX2J5dGVzIGZyYW1lcyA9XG4gIGxldCBjYXJ0cmlkZ2UgPSBEZXRlY3RfY2FydHJpZGdlLmYgfnJvbV9ieXRlcyBpblxuICBsZXQgbW9kdWxlIEMgPSBDYW1sYm95Lk1ha2UodmFsIGNhcnRyaWRnZSkgaW5cbiAgbGV0IHQgPSAgQy5jcmVhdGVfd2l0aF9yb20gfnByaW50X3NlcmlhbF9wb3J0OmZhbHNlIH5yb21fYnl0ZXMgaW5cbiAgbGV0IGZyYW1lX2NvdW50ID0gcmVmIDAgaW5cbiAgbGV0IHN0YXJ0X3RpbWUgPSByZWYgKFBlcmZvcm1hbmNlLm5vd19tcyBHLnBlcmZvcm1hbmNlKSBpblxuICB3aGlsZSAhZnJhbWVfY291bnQgPCBmcmFtZXMgZG9cbiAgICBtYXRjaCBDLnJ1bl9pbnN0cnVjdGlvbiB0IHdpdGhcbiAgICB8IEluX2ZyYW1lIC0+ICgpXG4gICAgfCBGcmFtZV9lbmRlZCBfIC0+IGluY3IgZnJhbWVfY291bnRcbiAgZG9uZTtcbiAgKFBlcmZvcm1hbmNlLm5vd19tcyBHLnBlcmZvcm1hbmNlKSAtLiAhc3RhcnRfdGltZVxuXG5sZXQgcnVuX3JvbV9ibG9iIHJvbV9ibG9iIGZyYW1lcyA9XG4gIGxldCogcmVzdWx0ID0gQmxvYi5hcnJheV9idWZmZXIgcm9tX2Jsb2IgaW5cbiAgbWF0Y2ggcmVzdWx0IHdpdGhcbiAgfCBPayBidWYgLT5cbiAgICBsZXQgcm9tX2J5dGVzID1cbiAgICAgIFRhcnJheS5vZl9idWZmZXIgVWludDggYnVmXG4gICAgICB8PiBUYXJyYXkudG9fYmlnYXJyYXkxXG4gICAgICAoKiBDb252ZXJ0IHVpbnQ4IGJpZ2FycmF5IHRvIGNoYXIgYmlnYXJyYXkgKilcbiAgICAgIHw+IE9iai5tYWdpY1xuICAgIGluXG4gICAgRnV0LnJldHVybiBAQCBydW5fcm9tX2J5dGVzIHJvbV9ieXRlcyBmcmFtZXNcbiAgfCBFcnJvciBlIC0+XG4gICAgQ29uc29sZS4obG9nIFtKdi5FcnJvci5tZXNzYWdlIGVdKTtcbiAgICBGdXQucmV0dXJuIDAuXG5cbmxldCBydW5fcm9tX3BhdGggcm9tX3BhdGggZnJhbWVzID1cbiAgbGV0KiByZXN1bHQgPSBGZXRjaC51cmwgKEpzdHIudiByb21fcGF0aCkgaW5cbiAgbWF0Y2ggcmVzdWx0IHdpdGhcbiAgfCBPayByZXNwb25zZSAtPlxuICAgIGxldCBib2R5ID0gRmV0Y2guUmVzcG9uc2UuYXNfYm9keSByZXNwb25zZSBpblxuICAgIGxldCogcmVzdWx0ID0gRmV0Y2guQm9keS5ibG9iIGJvZHkgaW5cbiAgICBiZWdpbiBtYXRjaCByZXN1bHQgd2l0aFxuICAgICAgfCBPayBibG9iIC0+IHJ1bl9yb21fYmxvYiBibG9iIGZyYW1lc1xuICAgICAgfCBFcnJvciBlICAtPiBDb25zb2xlLihsb2cgW0p2LkVycm9yLm1lc3NhZ2UgZV0pOyBGdXQucmV0dXJuIDAuXG4gICAgZW5kXG4gIHwgRXJyb3IgZSAgLT4gQ29uc29sZS4obG9nIFtKdi5FcnJvci5tZXNzYWdlIGVdKTsgRnV0LnJldHVybiAwLlxuXG5sZXQgcmVhZF9wYXJhbSBwYXJhbV9rZXkgPVxuICBsZXQgdXJpID0gV2luZG93LmxvY2F0aW9uIEcud2luZG93IGluXG4gIGxldCBwYXJhbSA9XG4gICAgdXJpXG4gICAgfD4gVXJpLnF1ZXJ5XG4gICAgfD4gVXJpLlBhcmFtcy5vZl9qc3RyXG4gICAgfD4gVXJpLlBhcmFtcy5maW5kIEpzdHIuKHYgcGFyYW1fa2V5KVxuICBpblxuICBtYXRjaCBwYXJhbSB3aXRoXG4gIHwgU29tZSBqc3RyIC0+IEpzdHIudG9fc3RyaW5nIGpzdHJcbiAgfCBOb25lIC0+XG4gICAgbGV0IG1zZyA9IFByaW50Zi5zcHJpbnRmIFwiUGFyYW1ldGVyICVzIG1pc3NpbmcgaW4gVVJMXCIgcGFyYW1fa2V5IGluXG4gICAgYWxlcnQgbXNnO1xuICAgIGZhaWx3aXRoIG1zZ1xuXG5cbmxldCAoKSA9XG4gICgqIFJlYWQgVVJMIHBhcmFtZXRlcnMgKilcbiAgbGV0IHJvbV9wYXRoID0gcmVhZF9wYXJhbSBcInJvbV9wYXRoXCIgaW5cbiAgbGV0IGZyYW1lcyA9IHJlYWRfcGFyYW0gXCJmcmFtZXNcIiB8PiBpbnRfb2Zfc3RyaW5nIGluXG4gICgqIExvYWQgaW5pdGlhbCByb20gKilcbiAgbGV0IGZ1dCA9IHJ1bl9yb21fcGF0aCByb21fcGF0aCBmcmFtZXMgaW5cbiAgRnV0LmF3YWl0IGZ1dCAoZnVuIGR1cmF0aW9uX21zIC0+XG4gICAgICBsZXQgZHVyYXRpb24gPSBkdXJhdGlvbl9tcyAvLiAxMDAwLiBpblxuICAgICAgbGV0IGZwcyA9IEZsb2F0LihvZl9pbnQgZnJhbWVzIC8uIGR1cmF0aW9uKSBpblxuICAgICAgbGV0IG1zZyA9IFByaW50Zi5zcHJpbnRmIFwiJThzOiAlc1xcbiU4czogJWRcXG4lOHM6ICVmXFxuJThzOiAlZlxcblwiXG4gICAgICAgICAgXCJST00gcGF0aFwiIHJvbV9wYXRoXG4gICAgICAgICAgXCJGcmFtZXNcIiBmcmFtZXNcbiAgICAgICAgICBcIkR1cmF0aW9uXCIgZHVyYXRpb25cbiAgICAgICAgICBcIkZQU1wiIGZwc1xuICAgICAgaW5cbiAgICAgIGxldCByZXN1bHRfZWwgPSBmaW5kX2VsX2J5X2lkIFwiYmVuY2hfcmVzdWx0XCIgaW5cbiAgICAgIEVsLnNldF9jaGlsZHJlbiByZXN1bHRfZWwgW0VsLnR4dCAoSnN0ci52IG1zZyldKVxuIl19
