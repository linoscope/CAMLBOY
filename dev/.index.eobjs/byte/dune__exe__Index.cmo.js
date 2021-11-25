(function(joo_global_object)
   {"use strict";
    var
     runtime=joo_global_object.jsoo_runtime,
     caml_check_bound=runtime.caml_check_bound,
     caml_jsstring_of_string=runtime.caml_jsstring_of_string,
     caml_string_notequal=runtime.caml_string_notequal,
     caml_string_of_jsbytes=runtime.caml_string_of_jsbytes,
     caml_string_of_jsstring=runtime.caml_string_of_jsstring;
    function caml_call1(f,a0)
     {return f.length == 1?f(a0):runtime.caml_call_gen(f,[a0])}
    function caml_call2(f,a0,a1)
     {return f.length == 2?f(a0,a1):runtime.caml_call_gen(f,[a0,a1])}
    function caml_call3(f,a0,a1,a2)
     {return f.length == 3?f(a0,a1,a2):runtime.caml_call_gen(f,[a0,a1,a2])}
    function caml_call4(f,a0,a1,a2,a3)
     {return f.length == 4
              ?f(a0,a1,a2,a3)
              :runtime.caml_call_gen(f,[a0,a1,a2,a3])}
    var
     global_data=runtime.caml_get_global_data(),
     cst_false=caml_string_of_jsbytes("false"),
     cst_fps=caml_string_of_jsbytes("fps"),
     cst_right=caml_string_of_jsbytes("right"),
     cst_left=caml_string_of_jsbytes("left"),
     cst_down=caml_string_of_jsbytes("down"),
     cst_up=caml_string_of_jsbytes("up"),
     cst_b=caml_string_of_jsbytes("b"),
     cst_a$1=caml_string_of_jsbytes("a"),
     cst_select=caml_string_of_jsbytes("select"),
     cst_start=caml_string_of_jsbytes("start"),
     cst_Enter$0=caml_string_of_jsbytes("Enter"),
     cst_Shift$0=caml_string_of_jsbytes("Shift"),
     cst_a$0=caml_string_of_jsbytes("a"),
     cst_d$0=caml_string_of_jsbytes("d"),
     cst_j$0=caml_string_of_jsbytes("j"),
     cst_k$0=caml_string_of_jsbytes("k"),
     cst_s$0=caml_string_of_jsbytes("s"),
     cst_w$0=caml_string_of_jsbytes("w"),
     cst_Enter=caml_string_of_jsbytes("Enter"),
     cst_Shift=caml_string_of_jsbytes("Shift"),
     cst_a=caml_string_of_jsbytes("a"),
     cst_d=caml_string_of_jsbytes("d"),
     cst_j=caml_string_of_jsbytes("j"),
     cst_k=caml_string_of_jsbytes("k"),
     cst_s=caml_string_of_jsbytes("s"),
     cst_w=caml_string_of_jsbytes("w"),
     rom_options=
      [0,
       [0,
        caml_string_of_jsbytes("The Bouncing Ball"),
        caml_string_of_jsbytes("./the-bouncing-ball.gb")],
       [0,
        [0,
         caml_string_of_jsbytes("Tobu Tobu Girl"),
         caml_string_of_jsbytes("./tobu.gb")],
        [0,
         [0,
          caml_string_of_jsbytes("Cavern"),
          caml_string_of_jsbytes("./cavern.gb")],
         [0,
          [0,
           caml_string_of_jsbytes("Into The Blue"),
           caml_string_of_jsbytes("./into-the-blue.gb")],
          [0,
           [0,
            caml_string_of_jsbytes("Rocket Man Demo"),
            caml_string_of_jsbytes("./rocket-man-demo.gb")],
           [0,
            [0,
             caml_string_of_jsbytes("Retroid"),
             caml_string_of_jsbytes("./retroid.gb")],
            [0,
             [0,
              caml_string_of_jsbytes("Wishing Sarah"),
              caml_string_of_jsbytes("./dreaming-sarah.gb")],
             [0,
              [0,
               caml_string_of_jsbytes("SHEEP IT UP"),
               caml_string_of_jsbytes("./sheep-it-up.gb")],
              0]]]]]]]],
     cst_canvas=caml_string_of_jsbytes("canvas"),
     cst_throttle=caml_string_of_jsbytes("throttle"),
     cst_load_rom=caml_string_of_jsbytes("load-rom"),
     cst_rom_selector=caml_string_of_jsbytes("rom-selector"),
     Brr=global_data.Brr,
     Fut=global_data.Fut,
     Stdlib_List=global_data.Stdlib__List,
     Jv=global_data.Jv,
     Brr_io=global_data.Brr_io,
     Stdlib_Printf=global_data.Stdlib__Printf,
     Camlboy_lib_Detect_cartridge=global_data.Camlboy_lib__Detect_cartridge,
     Camlboy_lib_Camlboy=global_data.Camlboy_lib__Camlboy,
     Dune_exe_My_ev=global_data.Dune__exe__My_ev,
     Brr_canvas=global_data.Brr_canvas,
     Stdlib_Option=global_data.Stdlib__Option,
     Stdlib_Array=global_data.Stdlib__Array,
     _b_=[0,[8,[0,0,0],0,[0,1],0],caml_string_of_jsbytes("%.1f")],
     _a_=[0,1],
     gb_w=160,
     gb_h=144;
    function alert(v)
     {var _cV_=Jv[12],alert=_cV_.alert,_cW_=Jv[23],_cX_=caml_call1(_cW_,v);
      alert(_cX_);
      return 0}
    function console_log(s)
     {var _cU_=0;
      return caml_call1(Brr[12][9],[0,caml_jsstring_of_string(s),_cU_])}
    function find_el_by_id(id)
     {var
       _cQ_=caml_jsstring_of_string(id),
       _cR_=Brr[16][2],
       _cS_=Brr[10][2],
       _cT_=caml_call2(_cS_,_cR_,_cQ_);
      return caml_call1(Stdlib_Option[4],_cT_)}
    function draw_framebuffer(ctx,image_data,fb)
     {var _cA_=Brr_canvas[4][90][4],d=caml_call1(_cA_,image_data),y=0;
      a:
      for(;;)
       {var x=0;
        for(;;)
         {var
           off=4 * ((y * 160 | 0) + x | 0) | 0,
           _cC_=caml_check_bound(fb,y)[1 + y],
           match=caml_check_bound(_cC_,x)[1 + x];
          if(-588596599 <= match)
           if(-126317716 <= match)
            {d[off] = 97;
             var _cD_=off + 1 | 0;
             d[_cD_] = 104;
             var _cE_=off + 2 | 0;
             d[_cE_] = 125;
             var _cF_=off + 3 | 0;
             d[_cF_] = 255}
           else
            {d[off] = 229;
             var _cH_=off + 1 | 0;
             d[_cH_] = 251;
             var _cI_=off + 2 | 0;
             d[_cI_] = 244;
             var _cJ_=off + 3 | 0;
             d[_cJ_] = 255}
          else
           if(-603547828 <= match)
            {d[off] = 151;
             var _cK_=off + 1 | 0;
             d[_cK_] = 174;
             var _cL_=off + 2 | 0;
             d[_cL_] = 184;
             var _cM_=off + 3 | 0;
             d[_cM_] = 255}
           else
            {d[off] = 34;
             var _cN_=off + 1 | 0;
             d[_cN_] = 30;
             var _cO_=off + 2 | 0;
             d[_cO_] = 49;
             var _cP_=off + 3 | 0;
             d[_cP_] = 255}
          var _cG_=x + 1 | 0;
          if(159 !== x){var x=_cG_;continue}
          var _cB_=y + 1 | 0;
          if(143 !== y){var y=_cB_;continue a}
          return caml_call4(Brr_canvas[4][93],ctx,image_data,0,0)}}}
    var run_id=[0,0],key_down_listener=[0,0],key_up_listener=[0,0];
    function set_listener(down,up)
     {key_down_listener[1] = [0,down];key_up_listener[1] = [0,up];return 0}
    function clear(param)
     {var _cr_=run_id[1];
      if(_cr_)
       {var timer_id=_cr_[1],_cs_=Brr[16][10];
        caml_call1(_cs_,timer_id);
        var _ct_=Brr[16][12];
        caml_call1(_ct_,timer_id)}
      var _cu_=key_down_listener[1];
      if(_cu_)
       {var
         lister=_cu_[1],
         _cv_=Brr[16][6],
         _cw_=Brr[7][76],
         _cx_=0,
         _cy_=Brr[7][21];
        caml_call4(_cy_,_cx_,_cw_,lister,_cv_)}
      var _cz_=key_up_listener[1];
      if(_cz_)
       {var lister$0=_cz_[1];
        return caml_call4(Brr[7][21],0,Brr[7][77],lister$0,Brr[16][6])}
      return 0}
    var State=[0,run_id,key_down_listener,key_up_listener,set_listener,clear];
    function set_up_keyboard(C)
     {return function(t)
       {function key_down_listener(ev)
         {var
           _cp_=Brr[7][31][2],
           _cq_=caml_call1(_cp_,ev),
           key_name=caml_string_of_jsstring(_cq_);
          return caml_string_notequal(key_name,cst_Enter)
                  ?caml_string_notequal(key_name,cst_Shift)
                    ?caml_string_notequal(key_name,cst_a)
                      ?caml_string_notequal(key_name,cst_d)
                        ?caml_string_notequal(key_name,cst_j)
                          ?caml_string_notequal(key_name,cst_k)
                            ?caml_string_notequal(key_name,cst_s)
                              ?caml_string_notequal(key_name,cst_w)?0:caml_call2(C[4],t,1)
                              :caml_call2(C[4],t,0)
                            :caml_call2(C[4],t,7)
                          :caml_call2(C[4],t,6)
                        :caml_call2(C[4],t,3)
                      :caml_call2(C[4],t,2)
                    :caml_call2(C[4],t,5)
                  :caml_call2(C[4],t,4)}
        function key_up_listener(ev)
         {var
           _cn_=Brr[7][31][2],
           _co_=caml_call1(_cn_,ev),
           key_name=caml_string_of_jsstring(_co_);
          return caml_string_notequal(key_name,cst_Enter$0)
                  ?caml_string_notequal(key_name,cst_Shift$0)
                    ?caml_string_notequal(key_name,cst_a$0)
                      ?caml_string_notequal(key_name,cst_d$0)
                        ?caml_string_notequal(key_name,cst_j$0)
                          ?caml_string_notequal(key_name,cst_k$0)
                            ?caml_string_notequal(key_name,cst_s$0)
                              ?caml_string_notequal(key_name,cst_w$0)
                                ?0
                                :caml_call2(C[5],t,1)
                              :caml_call2(C[5],t,0)
                            :caml_call2(C[5],t,7)
                          :caml_call2(C[5],t,6)
                        :caml_call2(C[5],t,3)
                      :caml_call2(C[5],t,2)
                    :caml_call2(C[5],t,5)
                  :caml_call2(C[5],t,4)}
        var _cf_=Brr[16][6],_cg_=Brr[7][76],_ch_=0,_ci_=Brr[7][20];
        caml_call4(_ci_,_ch_,_cg_,key_down_listener,_cf_);
        var _cj_=Brr[16][6],_ck_=Brr[7][77],_cl_=0,_cm_=Brr[7][20];
        caml_call4(_cm_,_cl_,_ck_,key_up_listener,_cj_);
        return caml_call2(State[4],key_down_listener,key_up_listener)}}
    function set_up_joypad(C)
     {return function(t)
       {var
         right_el=find_el_by_id(cst_right),
         left_el=find_el_by_id(cst_left),
         down_el=find_el_by_id(cst_down),
         up_el=find_el_by_id(cst_up),
         b_el=find_el_by_id(cst_b),
         a_el=find_el_by_id(cst_a$1),
         select_el=find_el_by_id(cst_select),
         start_el=find_el_by_id(cst_start);
        function viberate(ms)
         {var navigator=Brr[16][3];navigator.vibrate(ms);return 0}
        function press(ev,t,key)
         {var _cd_=Brr[7][13];
          caml_call1(_cd_,ev);
          var _ce_=10;
          viberate(_ce_);
          return caml_call2(C[4],t,key)}
        function release(ev,t,key)
         {var _cc_=Brr[7][13];
          caml_call1(_cc_,ev);
          return caml_call2(C[5],t,key)}
        var
         _bb_=0,
         _bc_=0,
         _bd_=0,
         _be_=Brr[7][19],
         listen_ops=caml_call4(_be_,_a_,_bd_,_bc_,_bb_);
        function _bf_(ev){return press(ev,t,1)}
        var _bg_=Dune_exe_My_ev[2],_bh_=[0,listen_ops],_bi_=Brr[7][20];
        caml_call4(_bi_,_bh_,_bg_,_bf_,up_el);
        function _bj_(ev){return press(ev,t,0)}
        var _bk_=Dune_exe_My_ev[2],_bl_=[0,listen_ops],_bm_=Brr[7][20];
        caml_call4(_bm_,_bl_,_bk_,_bj_,down_el);
        function _bn_(ev){return press(ev,t,2)}
        var _bo_=Dune_exe_My_ev[2],_bp_=[0,listen_ops],_bq_=Brr[7][20];
        caml_call4(_bq_,_bp_,_bo_,_bn_,left_el);
        function _br_(ev){return press(ev,t,3)}
        var _bs_=Dune_exe_My_ev[2],_bt_=[0,listen_ops],_bu_=Brr[7][20];
        caml_call4(_bu_,_bt_,_bs_,_br_,right_el);
        function _bv_(ev){return press(ev,t,7)}
        var _bw_=Dune_exe_My_ev[2],_bx_=[0,listen_ops],_by_=Brr[7][20];
        caml_call4(_by_,_bx_,_bw_,_bv_,a_el);
        function _bz_(ev){return press(ev,t,6)}
        var _bA_=Dune_exe_My_ev[2],_bB_=[0,listen_ops],_bC_=Brr[7][20];
        caml_call4(_bC_,_bB_,_bA_,_bz_,b_el);
        function _bD_(ev){return press(ev,t,4)}
        var _bE_=Dune_exe_My_ev[2],_bF_=[0,listen_ops],_bG_=Brr[7][20];
        caml_call4(_bG_,_bF_,_bE_,_bD_,start_el);
        function _bH_(ev){return press(ev,t,5)}
        var _bI_=Dune_exe_My_ev[2],_bJ_=[0,listen_ops],_bK_=Brr[7][20];
        caml_call4(_bK_,_bJ_,_bI_,_bH_,select_el);
        function _bL_(ev){return release(ev,t,1)}
        var _bM_=Dune_exe_My_ev[3],_bN_=[0,listen_ops],_bO_=Brr[7][20];
        caml_call4(_bO_,_bN_,_bM_,_bL_,up_el);
        function _bP_(ev){return release(ev,t,0)}
        var _bQ_=Dune_exe_My_ev[3],_bR_=[0,listen_ops],_bS_=Brr[7][20];
        caml_call4(_bS_,_bR_,_bQ_,_bP_,down_el);
        function _bT_(ev){return release(ev,t,2)}
        var _bU_=Dune_exe_My_ev[3],_bV_=[0,listen_ops],_bW_=Brr[7][20];
        caml_call4(_bW_,_bV_,_bU_,_bT_,left_el);
        function _bX_(ev){return release(ev,t,3)}
        var _bY_=Dune_exe_My_ev[3],_bZ_=[0,listen_ops],_b0_=Brr[7][20];
        caml_call4(_b0_,_bZ_,_bY_,_bX_,right_el);
        function _b1_(ev){return release(ev,t,7)}
        var _b2_=Dune_exe_My_ev[3],_b3_=[0,listen_ops],_b4_=Brr[7][20];
        caml_call4(_b4_,_b3_,_b2_,_b1_,a_el);
        function _b5_(ev){return release(ev,t,6)}
        var _b6_=Dune_exe_My_ev[3],_b7_=[0,listen_ops],_b8_=Brr[7][20];
        caml_call4(_b8_,_b7_,_b6_,_b5_,b_el);
        function _b9_(ev){return release(ev,t,4)}
        var _b__=Dune_exe_My_ev[3],_b$_=[0,listen_ops],_ca_=Brr[7][20];
        caml_call4(_ca_,_b$_,_b__,_b9_,start_el);
        function _cb_(ev){return release(ev,t,5)}
        return caml_call4
                (Brr[7][20],[0,listen_ops],Dune_exe_My_ev[3],_cb_,select_el)}}
    var throttled=[0,1];
    function run_rom_bytes(ctx,image_data,rom_bytes)
     {var _aP_=0,_aQ_=State[5];
      caml_call1(_aQ_,_aP_);
      var
       _aR_=Camlboy_lib_Detect_cartridge[1],
       cartridge=caml_call1(_aR_,rom_bytes),
       C=caml_call1(Camlboy_lib_Camlboy[1],cartridge),
       _aS_=1,
       _aT_=C[2],
       t=caml_call2(_aT_,_aS_,rom_bytes);
      caml_call1(set_up_keyboard(C),t);
      caml_call1(set_up_joypad(C),t);
      var
       cnt=[0,0],
       _aU_=Brr[16][4],
       _aV_=Brr[15][9],
       start_time=[0,caml_call1(_aV_,_aU_)];
      function set_fps(fps)
       {var
         _a7_=Stdlib_Printf[4],
         fps_str=caml_call2(_a7_,_b_,fps),
         fps_el=find_el_by_id(cst_fps),
         _a8_=0,
         _a9_=caml_jsstring_of_string(fps_str),
         _a__=0,
         _a$_=Brr[9][2],
         _ba_=[0,caml_call2(_a$_,_a__,_a9_),_a8_];
        return caml_call2(Brr[9][18],fps_el,_ba_)}
      function main_loop(param)
       {for(;;)
         {var _aW_=C[3],match=caml_call1(_aW_,t);
          if(match)
           {var fb=match[1];
            cnt[1]++;
            if(60 === cnt[1])
             {var
               _aX_=Brr[16][4],
               _aY_=Brr[15][9],
               end_time=caml_call1(_aY_,_aX_),
               _aZ_=start_time[1],
               _a0_=end_time - _aZ_,
               sec_per_60_frame=_a0_ / 1000.,
               fps=60. / sec_per_60_frame;
              start_time[1] = end_time;
              set_fps(fps);
              cnt[1] = 0}
            draw_framebuffer(ctx,image_data,fb);
            if(throttled[1])
             {var
               _a1_=function(param){return main_loop(0)},
               _a2_=Brr[16][11],
               _a3_=[0,caml_call1(_a2_,_a1_)];
              State[1][1] = _a3_;
              return 0}
            var
             _a4_=0,
             _a5_=Brr[16][8],
             _a6_=[0,caml_call2(_a5_,_a4_,main_loop)];
            State[1][1] = _a6_;
            return 0}
          continue}}
      return main_loop(0)}
    function run_rom_blob(ctx,image_data,rom_blob)
     {function _aB_(result)
       {if(0 === result[0])
         {var
           buf=result[1],
           _aE_=0,
           _aF_=0,
           _aG_=3,
           _aH_=Brr[1][5],
           _aI_=caml_call4(_aH_,_aG_,_aF_,_aE_,buf),
           rom_bytes=runtime.caml_ba_from_typed_array(_aI_),
           _aJ_=run_rom_bytes(ctx,image_data,rom_bytes);
          return caml_call1(Fut[3],_aJ_)}
        var
         e=result[1],
         _aK_=0,
         _aL_=Jv[30][4],
         _aM_=[0,caml_call1(_aL_,e),_aK_],
         _aN_=Brr[12][9],
         _aO_=caml_call1(_aN_,_aM_);
        return caml_call1(Fut[3],_aO_)}
      var _aC_=Brr[2][8],_aD_=caml_call1(_aC_,rom_blob);
      return caml_call2(Fut[15][1],_aD_,_aB_)}
    function on_load_rom(ctx,image_data,input_el)
     {var
       _aw_=Brr[9][56][1],
       _ax_=caml_call1(_aw_,input_el),
       _ay_=Stdlib_List[5],
       file=caml_call1(_ay_,_ax_);
      function _az_(param){return 0}
      var _aA_=run_rom_blob(ctx,image_data,file);
      return caml_call2(Fut[2],_aA_,_az_)}
    function run_selected_rom(ctx,image_data,rom_path)
     {function _ae_(result)
       {if(0 === result[0])
         {var
           response=result[1],
           _aj_=
            function(result)
             {if(0 === result[0])
               {var blob=result[1];return run_rom_blob(ctx,image_data,blob)}
              var
               e=result[1],
               _ar_=0,
               _as_=Jv[30][4],
               _at_=[0,caml_call1(_as_,e),_ar_],
               _au_=Brr[12][9],
               _av_=caml_call1(_au_,_at_);
              return caml_call1(Fut[3],_av_)},
           _ak_=Brr_io[3][1][9],
           _al_=caml_call1(_ak_,response);
          return caml_call2(Fut[15][1],_al_,_aj_)}
        var
         e=result[1],
         _am_=0,
         _an_=Jv[30][4],
         _ao_=[0,caml_call1(_an_,e),_am_],
         _ap_=Brr[12][9],
         _aq_=caml_call1(_ap_,_ao_);
        return caml_call1(Fut[3],_aq_)}
      var
       _af_=caml_jsstring_of_string(rom_path),
       _ag_=0,
       _ah_=Brr_io[3][7],
       _ai_=caml_call2(_ah_,_ag_,_af_);
      return caml_call2(Fut[15][1],_ai_,_ae_)}
    function set_up_rom_selector(ctx,image_data,selector_el)
     {function _L_(rom_option)
       {var
         _W_=0,
         _X_=rom_option[1],
         _Y_=0,
         _Z_=Brr[9][3],
         ___=[0,caml_call2(_Z_,_Y_,_X_),_W_],
         _$_=0,
         _aa_=rom_option[2],
         _ab_=caml_jsstring_of_string(_aa_),
         _ac_=Brr[8][37],
         _ad_=[0,[0,caml_call1(_ac_,_ab_),_$_]];
        return caml_call3(Brr[9][127],0,_ad_,___)}
      var
       _M_=Stdlib_List[19],
       _N_=caml_call1(_M_,_L_),
       _O_=caml_call1(_N_,rom_options),
       _P_=Brr[9][20],
       _Q_=caml_call1(_P_,selector_el);
      caml_call1(_Q_,_O_);
      function on_change(param)
       {var
         _R_=Brr[9][25][10],
         _S_=Brr[9][26],
         _T_=caml_call2(_S_,_R_,selector_el),
         rom_path=caml_string_of_jsstring(_T_);
        function _U_(param){return 0}
        var _V_=run_selected_rom(ctx,image_data,rom_path);
        return caml_call2(Fut[2],_V_,_U_)}
      return caml_call4(Brr[7][20],0,Brr[7][43],on_change,selector_el)}
    function set_default_throttle_val(checkbox_el)
     {var
       _A_=Brr[16][5],
       _B_=Brr[13][12],
       uri=caml_call1(_B_,_A_),
       _C_=Brr[6][6],
       _D_=caml_call1(_C_,uri),
       _E_=Brr[6][9][7],
       _F_=caml_call1(_E_,_D_),
       _G_="throttled",
       _H_=Brr[6][9][3],
       _I_=caml_call1(_H_,_G_),
       param=caml_call1(_I_,_F_);
      function set_throttled_val(b)
       {var _J_=Brr[9][25][5],_K_=Brr[9][27];
        caml_call3(_K_,_J_,b,checkbox_el);
        throttled[1] = b;
        return 0}
      if(param)
       {var jstr=param[1],match=caml_string_of_jsstring(jstr);
        return caml_string_notequal(match,cst_false)
                ?set_throttled_val(1)
                :set_throttled_val(0)}
      return set_throttled_val(1)}
    function on_checkbox_change(checkbox_el)
     {var
       _y_=Brr[9][25][5],
       _z_=Brr[9][26],
       checked=caml_call2(_z_,_y_,checkbox_el);
      throttled[1] = checked;
      return 0}
    var
     _c_=find_el_by_id(cst_canvas),
     _d_=Brr_canvas[3][2],
     canvas=caml_call1(_d_,_c_),
     _e_=0,
     _f_=Brr_canvas[4][15],
     ctx=caml_call2(_f_,_e_,canvas),
     _g_=1.5,
     _h_=1.5,
     _i_=Brr_canvas[4][36];
    caml_call3(_i_,ctx,_h_,_g_);
    var
     _j_=Brr_canvas[4][91],
     image_data=caml_call3(_j_,ctx,gb_w,gb_h),
     _k_=-603547828,
     _l_=Stdlib_Array[3],
     fb=caml_call3(_l_,gb_h,gb_w,_k_);
    draw_framebuffer(ctx,image_data,fb);
    var checkbox_el=find_el_by_id(cst_throttle);
    set_default_throttle_val(checkbox_el);
    function _m_(param){return on_checkbox_change(checkbox_el)}
    var _n_=Brr[7][43],_o_=0,_p_=Brr[7][20];
    caml_call4(_p_,_o_,_n_,_m_,checkbox_el);
    var input_el=find_el_by_id(cst_load_rom);
    function _q_(param){return on_load_rom(ctx,image_data,input_el)}
    var _r_=Brr[7][43],_s_=0,_t_=Brr[7][20];
    caml_call4(_t_,_s_,_r_,_q_,input_el);
    var selector_el=find_el_by_id(cst_rom_selector);
    set_up_rom_selector(ctx,image_data,selector_el);
    var
     _u_=Stdlib_List[5],
     rom=caml_call1(_u_,rom_options),
     _v_=rom[2],
     fut=run_selected_rom(ctx,image_data,_v_);
    function _w_(param){return 0}
    var _x_=Fut[2];
    caml_call2(_x_,fut,_w_);
    var
     Dune_exe_Index=
      [0,
       gb_w,
       gb_h,
       rom_options,
       alert,
       console_log,
       find_el_by_id,
       draw_framebuffer,
       State,
       set_up_keyboard,
       set_up_joypad,
       throttled,
       run_rom_bytes,
       run_rom_blob,
       on_load_rom,
       run_selected_rom,
       set_up_rom_selector,
       set_default_throttle_val,
       on_checkbox_change];
    runtime.caml_register_global(52,Dune_exe_Index,"Dune__exe__Index");
    return}
  (function(){return this}()));

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLjAsImZpbGUiOiIuaW5kZXguZW9ianMvYnl0ZS9kdW5lX19leGVfX0luZGV4LmNtby5qcyIsInNvdXJjZVJvb3QiOiIiLCJuYW1lcyI6WyJyb21fb3B0aW9ucyIsImdiX3ciLCJnYl9oIiwiYWxlcnQiLCJ2IiwiY29uc29sZV9sb2ciLCJzIiwiZmluZF9lbF9ieV9pZCIsImlkIiwiZHJhd19mcmFtZWJ1ZmZlciIsImN0eCIsImltYWdlX2RhdGEiLCJmYiIsImQiLCJ5IiwieCIsIm9mZiIsInJ1bl9pZCIsImtleV9kb3duX2xpc3RlbmVyIiwia2V5X3VwX2xpc3RlbmVyIiwic2V0X2xpc3RlbmVyIiwiZG93biIsInVwIiwiY2xlYXIiLCJ0aW1lcl9pZCIsImxpc3RlciIsImxpc3RlciQwIiwic2V0X3VwX2tleWJvYXJkIiwiQyIsInQiLCJldiIsImtleV9uYW1lIiwic2V0X3VwX2pveXBhZCIsInJpZ2h0X2VsIiwibGVmdF9lbCIsImRvd25fZWwiLCJ1cF9lbCIsImJfZWwiLCJhX2VsIiwic2VsZWN0X2VsIiwic3RhcnRfZWwiLCJ2aWJlcmF0ZSIsIm1zIiwibmF2aWdhdG9yIiwicHJlc3MiLCJrZXkiLCJyZWxlYXNlIiwibGlzdGVuX29wcyIsInRocm90dGxlZCIsInJ1bl9yb21fYnl0ZXMiLCJyb21fYnl0ZXMiLCJjYXJ0cmlkZ2UiLCJjbnQiLCJzdGFydF90aW1lIiwic2V0X2ZwcyIsImZwcyIsImZwc19zdHIiLCJmcHNfZWwiLCJtYWluX2xvb3AiLCJlbmRfdGltZSIsInNlY19wZXJfNjBfZnJhbWUiLCJydW5fcm9tX2Jsb2IiLCJyb21fYmxvYiIsInJlc3VsdCIsImJ1ZiIsImUiLCJvbl9sb2FkX3JvbSIsImlucHV0X2VsIiwiZmlsZSIsInJ1bl9zZWxlY3RlZF9yb20iLCJyb21fcGF0aCIsInJlc3BvbnNlIiwiYmxvYiIsInNldF91cF9yb21fc2VsZWN0b3IiLCJzZWxlY3Rvcl9lbCIsInJvbV9vcHRpb24iLCJvbl9jaGFuZ2UiLCJzZXRfZGVmYXVsdF90aHJvdHRsZV92YWwiLCJjaGVja2JveF9lbCIsInVyaSIsInBhcmFtIiwic2V0X3Rocm90dGxlZF92YWwiLCJiIiwianN0ciIsIm9uX2NoZWNrYm94X2NoYW5nZSIsImNoZWNrZWQiLCJjYW52YXMiLCJyb20iLCJmdXQiXSwic291cmNlcyI6WyIvaG9tZS9ydW5uZXIvd29yay9DQU1MQk9ZL0NBTUxCT1kvX2J1aWxkLWRldi9kZWZhdWx0L2Jpbi93ZWIvaW5kZXgubWwiXSwibWFwcGluZ3MiOiI7O0k7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7OztLQVlJQTs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7OztLQUxBQztLQUNBQzthQWVBQyxNQUFNQztNQUNSLGdCQUFZLDZCQUNtQixxQkFGdkJBO01BRUU7Y0FBbUM7YUFFM0NDLFlBQVlDO01BQUk7TUFBa0Isd0RBQXRCQSxTQUFrQzthQUU5Q0MsY0FBY0M7TUFBdUM7b0NBQXZDQTtPQUF1Qzs7T0FBbEM7OENBQTJEO2FBRTlFQyxpQkFBaUJDLElBQUlDLFdBQVdDO01BQ2xDLDhCQUFRLGtCQURlRCxZQUV2Qkc7O01BQ0U7O1FBQ0U7O3FCQUZKQSxlQUNFQztXQUVRLHNCQUx3QkgsR0FFbENFO1dBR2dCLDRCQUZkQztVQUVjOzthQVlWLEVBYkVDO2FBYUYsU0FiRUE7YUFjRjthQURBLFNBYkVBO2FBZUY7YUFGQSxTQWJFQTthQWdCRjs7YUFiQSxFQUhFQTthQUdGLFNBSEVBO2FBSUY7YUFEQSxTQUhFQTthQUtGO2FBRkEsU0FIRUE7YUFNRjs7O2FBRUEsRUFSRUE7YUFRRixTQVJFQTthQVNGO2FBREEsU0FSRUE7YUFVRjthQUZBLFNBUkVBO2FBV0Y7O2FBT0EsRUFsQkVBO2FBa0JGLFNBbEJFQTthQW1CRjthQURBLFNBbEJFQTthQW9CRjthQUZBLFNBbEJFQTthQXFCRjtVQXJCRixTQURGRDs7VUFDRSxTQUZKRDs7VUEwQkEsb0NBNUJtQkosSUFBSUMsaUJBNEJvQjtRQUl2Q00sYUFDQUMsd0JB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LGVBRG9CSTtRQUNwQixRQUNjO01BSnlCLEdBSnJDRjtRQVlGLFNBWkVBLFNBWUYsOEJBREtHO1FBQ0w7aUJBRWM7aUJBREM7TUFHUCwyQkFBc0I7YUFFOUJDLG1CQUFtQk47TUFDckI7OztPQUFjLDJCQURPQTtNQUNQLGVBQVZPO01BQVUsUUFDTTtJQUlQOzs7Ozs7S0FDSCx1QkFETkM7S0FDTTs7O0lBQ1YsZUFESTVFO0lBRFM7S0FFYjtLQUNpQiwwQkFGYkEsSUE1UEZULEtBQ0FDO0tBNlBlOztLQUNSLGtCQTlQUEEsS0FEQUQ7SUFnUUYsaUJBSklTLElBRUFDLFdBQ0FDO0lBSlMsSUFPVGtFLFlBQWM7SUFDbEIseUJBRElBO0lBQ0osb0JBQzhCLDBCQUYxQkEsWUFFd0Q7SUFENUQ7SUFDQSwyQkFGSUE7SUFDSixJQUdJWCxTQUFXO3dCQUNlLG1CQVgxQnpELElBRUFDLFdBUUF3RCxTQUM2RDtJQURsRDtJQUNmLDJCQURJQTtJQUFXLElBR1hPLFlBQWM7SUFDbEIsb0JBZEloRSxJQUVBQyxXQVdBK0Q7SUFIVztLQUlmO0tBRVUsbUJBdlFSMUU7S0F1UVEsSUFBTnVGO0tBQ00scUJBakJON0UsSUFFQUM7SUFlTSxvQkFDZSxRQUFFO0lBRGpCO0lBQ1YsZUFESTZFO0lBQU07OztPQTdRUnZGO09BQ0FDO09BSUFGO09BV0FHO09BSUFFO09BRUFFO09BRUFFOztPQXVEQWtCO09BaUNBSztPQThCQWdCO09BRUFDO09BcUNBWTtPQWNBSztPQUtBRztPQVlBSTtPQWFBSTtPQW9CQU87SUF5QkY7VSIsInNvdXJjZXNDb250ZW50IjpbIm9wZW4gQ2FtbGJveV9saWJcbm9wZW4gQnJyXG5vcGVuIEJycl9jYW52YXNcbm9wZW4gQnJyX2lvXG5vcGVuIEZ1dC5TeW50YXhcblxuXG5sZXQgZ2JfdyA9IDE2MFxubGV0IGdiX2ggPSAxNDRcblxudHlwZSByb21fb3B0aW9uID0geyBuYW1lIDogc3RyaW5nOyBwYXRoIDogc3RyaW5nIH1cblxubGV0IHJvbV9vcHRpb25zID0gW1xuICB7bmFtZSA9IFwiVGhlIEJvdW5jaW5nIEJhbGxcIiA7IHBhdGggPSBcIi4vdGhlLWJvdW5jaW5nLWJhbGwuZ2JcIn07XG4gIHtuYW1lID0gXCJUb2J1IFRvYnUgR2lybFwiICAgIDsgcGF0aCA9IFwiLi90b2J1LmdiXCJ9O1xuICB7bmFtZSA9IFwiQ2F2ZXJuXCIgICAgICAgICAgICA7IHBhdGggPSBcIi4vY2F2ZXJuLmdiXCJ9O1xuICB7bmFtZSA9IFwiSW50byBUaGUgQmx1ZVwiICAgICA7IHBhdGggPSBcIi4vaW50by10aGUtYmx1ZS5nYlwifTtcbiAge25hbWUgPSBcIlJvY2tldCBNYW4gRGVtb1wiICAgOyBwYXRoID0gXCIuL3JvY2tldC1tYW4tZGVtby5nYlwifTtcbiAge25hbWUgPSBcIlJldHJvaWRcIiAgICAgICAgICAgOyBwYXRoID0gXCIuL3JldHJvaWQuZ2JcIn07XG4gIHtuYW1lID0gXCJXaXNoaW5nIFNhcmFoXCIgICAgIDsgcGF0aCA9IFwiLi9kcmVhbWluZy1zYXJhaC5nYlwifTtcbiAge25hbWUgPSBcIlNIRUVQIElUIFVQXCIgICAgICAgOyBwYXRoID0gXCIuL3NoZWVwLWl0LXVwLmdiXCJ9O1xuXVxuXG5sZXQgYWxlcnQgdiA9XG4gIGxldCBhbGVydCA9IEp2LmdldCBKdi5nbG9iYWwgXCJhbGVydFwiIGluXG4gIGlnbm9yZSBAQCBKdi5hcHBseSBhbGVydCBKdi5bfCBvZl9zdHJpbmcgdiB8XVxuXG5sZXQgY29uc29sZV9sb2cgcyA9IENvbnNvbGUubG9nIEpzdHIuW29mX3N0cmluZyBzXVxuXG5sZXQgZmluZF9lbF9ieV9pZCBpZCA9IERvY3VtZW50LmZpbmRfZWxfYnlfaWQgRy5kb2N1bWVudCAoSnN0ci52IGlkKSB8PiBPcHRpb24uZ2V0XG5cbmxldCBkcmF3X2ZyYW1lYnVmZmVyIGN0eCBpbWFnZV9kYXRhIGZiID1cbiAgbGV0IGQgPSBDMmQuSW1hZ2VfZGF0YS5kYXRhIGltYWdlX2RhdGEgaW5cbiAgZm9yIHkgPSAwIHRvIGdiX2ggLSAxIGRvXG4gICAgZm9yIHggPSAwIHRvIGdiX3cgLSAxIGRvXG4gICAgICBsZXQgb2ZmID0gNCAqICh5ICogZ2JfdyArIHgpIGluXG4gICAgICBtYXRjaCBmYi4oeSkuKHgpIHdpdGhcbiAgICAgIHwgYFdoaXRlIC0+XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICAgICkgMHhFNTtcbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgKyAxKSAweEZCO1xuICAgICAgICBUYXJyYXkuc2V0IGQgKG9mZiArIDIpIDB4RjQ7XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICsgMykgMHhGRjtcbiAgICAgIHwgYExpZ2h0X2dyYXkgLT5cbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgICAgKSAweDk3O1xuICAgICAgICBUYXJyYXkuc2V0IGQgKG9mZiArIDEpIDB4QUU7XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICsgMikgMHhCODtcbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgKyAzKSAweEZGO1xuICAgICAgfCBgRGFya19ncmF5IC0+XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICAgICkgMHg2MTtcbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgKyAxKSAweDY4O1xuICAgICAgICBUYXJyYXkuc2V0IGQgKG9mZiArIDIpIDB4N0Q7XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICsgMykgMHhGRjtcbiAgICAgIHwgYEJsYWNrIC0+XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICAgICkgMHgyMjtcbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgKyAxKSAweDFFO1xuICAgICAgICBUYXJyYXkuc2V0IGQgKG9mZiArIDIpIDB4MzE7XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICsgMykgMHhGRjtcbiAgICBkb25lXG4gIGRvbmU7XG4gIEMyZC5wdXRfaW1hZ2VfZGF0YSBjdHggaW1hZ2VfZGF0YSB+eDowIH55OjBcblxuKCoqIE1hbmFnZXMgc3RhdGUgdGhhdCBuZWVkIHRvIGJlIHJlc2V0IHdoZW4gbG9hZGluZyBhIG5ldyByb20gKilcbm1vZHVsZSBTdGF0ZSA9IHN0cnVjdFxuICBsZXQgcnVuX2lkID0gcmVmIE5vbmVcbiAgbGV0IGtleV9kb3duX2xpc3RlbmVyID0gcmVmIE5vbmVcbiAgbGV0IGtleV91cF9saXN0ZW5lciA9IHJlZiBOb25lXG4gIGxldCBzZXRfbGlzdGVuZXIgZG93biB1cCA9XG4gICAga2V5X2Rvd25fbGlzdGVuZXIgOj0gU29tZSBkb3duO1xuICAgIGtleV91cF9saXN0ZW5lciA6PSBTb21lIHVwXG4gIGxldCBjbGVhciAoKSA9XG4gICAgYmVnaW4gbWF0Y2ggIXJ1bl9pZCB3aXRoXG4gICAgICB8IE5vbmUgLT4gKClcbiAgICAgIHwgU29tZSB0aW1lcl9pZCAtPlxuICAgICAgICBHLnN0b3BfdGltZXIgdGltZXJfaWQ7XG4gICAgICAgIEcuY2FuY2VsX2FuaW1hdGlvbl9mcmFtZSB0aW1lcl9pZDtcbiAgICBlbmQ7XG4gICAgYmVnaW4gbWF0Y2ggIWtleV9kb3duX2xpc3RlbmVyIHdpdGhcbiAgICAgIHwgTm9uZSAtPiAoKVxuICAgICAgfCBTb21lIGxpc3RlciAtPiBFdi51bmxpc3RlbiBFdi5rZXlkb3duIGxpc3RlciBHLnRhcmdldFxuICAgIGVuZDtcbiAgICBiZWdpbiBtYXRjaCAha2V5X3VwX2xpc3RlbmVyIHdpdGhcbiAgICAgIHwgTm9uZSAtPiAoKVxuICAgICAgfCBTb21lIGxpc3RlciAtPiBFdi51bmxpc3RlbiBFdi5rZXl1cCBsaXN0ZXIgRy50YXJnZXRcbiAgICBlbmRcbmVuZFxuXG5sZXQgc2V0X3VwX2tleWJvYXJkICh0eXBlIGEpIChtb2R1bGUgQyA6IENhbWxib3lfaW50Zi5TIHdpdGggdHlwZSB0ID0gYSkgKHQgOiBhKSA9XG4gIGxldCBrZXlfZG93bl9saXN0ZW5lciBldiA9XG4gICAgbGV0IGtleV9ldiA9IEV2LmFzX3R5cGUgZXYgaW5cbiAgICBsZXQga2V5X25hbWUgPSBrZXlfZXYgfD4gRXYuS2V5Ym9hcmQua2V5IHw+IEpzdHIudG9fc3RyaW5nIGluXG4gICAgbWF0Y2gga2V5X25hbWUgd2l0aFxuICAgIHwgXCJFbnRlclwiIC0+IEMucHJlc3MgdCBTdGFydFxuICAgIHwgXCJTaGlmdFwiIC0+IEMucHJlc3MgdCBTZWxlY3RcbiAgICB8IFwialwiICAgICAtPiBDLnByZXNzIHQgQlxuICAgIHwgXCJrXCIgICAgIC0+IEMucHJlc3MgdCBBXG4gICAgfCBcIndcIiAgICAgLT4gQy5wcmVzcyB0IFVwXG4gICAgfCBcImFcIiAgICAgLT4gQy5wcmVzcyB0IExlZnRcbiAgICB8IFwic1wiICAgICAtPiBDLnByZXNzIHQgRG93blxuICAgIHwgXCJkXCIgICAgIC0+IEMucHJlc3MgdCBSaWdodFxuICAgIHwgXyAgICAgICAtPiAoKVxuICBpblxuICBsZXQga2V5X3VwX2xpc3RlbmVyIGV2ID1cbiAgICBsZXQga2V5X2V2ID0gRXYuYXNfdHlwZSBldiBpblxuICAgIGxldCBrZXlfbmFtZSA9IGtleV9ldiB8PiBFdi5LZXlib2FyZC5rZXkgfD4gSnN0ci50b19zdHJpbmcgaW5cbiAgICBtYXRjaCBrZXlfbmFtZSB3aXRoXG4gICAgfCBcIkVudGVyXCIgLT4gQy5yZWxlYXNlIHQgU3RhcnRcbiAgICB8IFwiU2hpZnRcIiAtPiBDLnJlbGVhc2UgdCBTZWxlY3RcbiAgICB8IFwialwiICAgICAtPiBDLnJlbGVhc2UgdCBCXG4gICAgfCBcImtcIiAgICAgLT4gQy5yZWxlYXNlIHQgQVxuICAgIHwgXCJ3XCIgICAgIC0+IEMucmVsZWFzZSB0IFVwXG4gICAgfCBcImFcIiAgICAgLT4gQy5yZWxlYXNlIHQgTGVmdFxuICAgIHwgXCJzXCIgICAgIC0+IEMucmVsZWFzZSB0IERvd25cbiAgICB8IFwiZFwiICAgICAtPiBDLnJlbGVhc2UgdCBSaWdodFxuICAgIHwgXyAgICAgICAtPiAoKVxuICBpblxuICBFdi5saXN0ZW4gRXYua2V5ZG93biAoa2V5X2Rvd25fbGlzdGVuZXIpIEcudGFyZ2V0O1xuICBFdi5saXN0ZW4gRXYua2V5dXAgKGtleV91cF9saXN0ZW5lcikgRy50YXJnZXQ7XG4gIFN0YXRlLnNldF9saXN0ZW5lciBrZXlfZG93bl9saXN0ZW5lciBrZXlfdXBfbGlzdGVuZXJcblxubGV0IHNldF91cF9qb3lwYWQgKHR5cGUgYSkgKG1vZHVsZSBDIDogQ2FtbGJveV9pbnRmLlMgd2l0aCB0eXBlIHQgPSBhKSAodCA6IGEpID1cbiAgbGV0IHVwX2VsLCBkb3duX2VsLCBsZWZ0X2VsLCByaWdodF9lbCA9XG4gICAgZmluZF9lbF9ieV9pZCBcInVwXCIsIGZpbmRfZWxfYnlfaWQgXCJkb3duXCIsIGZpbmRfZWxfYnlfaWQgXCJsZWZ0XCIsIGZpbmRfZWxfYnlfaWQgXCJyaWdodFwiIGluXG4gIGxldCBhX2VsLCBiX2VsID0gZmluZF9lbF9ieV9pZCBcImFcIiwgZmluZF9lbF9ieV9pZCBcImJcIiBpblxuICBsZXQgc3RhcnRfZWwsIHNlbGVjdF9lbCA9IGZpbmRfZWxfYnlfaWQgXCJzdGFydFwiLCBmaW5kX2VsX2J5X2lkIFwic2VsZWN0XCIgaW5cbiAgbGV0IHZpYmVyYXRlIG1zID1cbiAgICBsZXQgbmF2aWdhdG9yID0gRy5uYXZpZ2F0b3IgfD4gTmF2aWdhdG9yLnRvX2p2IGluXG4gICAgaWdub3JlIEBAIEp2LmNhbGwgbmF2aWdhdG9yIFwidmlicmF0ZVwiIEp2Llt8IG9mX2ludCBtcyB8XVxuICBpblxuICAoKiBUT0RPOiB1bmxpc3RlbiB0aGVzZSBsaXN0ZW5lciBvbiByb20gY2hhbmdlICopXG4gIGxldCBwcmVzcyBldiB0IGtleSA9IEV2LnByZXZlbnRfZGVmYXVsdCBldjsgdmliZXJhdGUgMTA7IEMucHJlc3MgdCBrZXkgaW5cbiAgbGV0IHJlbGVhc2UgZXYgdCBrZXkgPSBFdi5wcmV2ZW50X2RlZmF1bHQgZXY7IEMucmVsZWFzZSB0IGtleSBpblxuICBsZXQgbGlzdGVuX29wcyA9IEV2Lmxpc3Rlbl9vcHRzIH5jYXB0dXJlOnRydWUgKCkgaW5cbiAgRXYubGlzdGVuIE15X2V2LnRvdWNoc3RhcnQgfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHByZXNzIGV2IHQgVXApICAgICAoRWwuYXNfdGFyZ2V0IHVwX2VsKTtcbiAgRXYubGlzdGVuIE15X2V2LnRvdWNoc3RhcnQgfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHByZXNzIGV2IHQgRG93bikgICAoRWwuYXNfdGFyZ2V0IGRvd25fZWwpO1xuICBFdi5saXN0ZW4gTXlfZXYudG91Y2hzdGFydCB+b3B0czpsaXN0ZW5fb3BzIChmdW4gZXYgLT4gcHJlc3MgZXYgdCBMZWZ0KSAgIChFbC5hc190YXJnZXQgbGVmdF9lbCk7XG4gIEV2Lmxpc3RlbiBNeV9ldi50b3VjaHN0YXJ0IH5vcHRzOmxpc3Rlbl9vcHMgKGZ1biBldiAtPiBwcmVzcyBldiB0IFJpZ2h0KSAgKEVsLmFzX3RhcmdldCByaWdodF9lbCk7XG4gIEV2Lmxpc3RlbiBNeV9ldi50b3VjaHN0YXJ0IH5vcHRzOmxpc3Rlbl9vcHMgKGZ1biBldiAtPiBwcmVzcyBldiB0IEEpICAgICAgKEVsLmFzX3RhcmdldCBhX2VsKTtcbiAgRXYubGlzdGVuIE15X2V2LnRvdWNoc3RhcnQgfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHByZXNzIGV2IHQgQikgICAgICAoRWwuYXNfdGFyZ2V0IGJfZWwpO1xuICBFdi5saXN0ZW4gTXlfZXYudG91Y2hzdGFydCB+b3B0czpsaXN0ZW5fb3BzIChmdW4gZXYgLT4gcHJlc3MgZXYgdCBTdGFydCkgIChFbC5hc190YXJnZXQgc3RhcnRfZWwpO1xuICBFdi5saXN0ZW4gTXlfZXYudG91Y2hzdGFydCB+b3B0czpsaXN0ZW5fb3BzIChmdW4gZXYgLT4gcHJlc3MgZXYgdCBTZWxlY3QpIChFbC5hc190YXJnZXQgc2VsZWN0X2VsKTtcbiAgRXYubGlzdGVuIE15X2V2LnRvdWNoZW5kIH5vcHRzOmxpc3Rlbl9vcHMgKGZ1biBldiAtPiByZWxlYXNlIGV2IHQgVXApICAgICAoRWwuYXNfdGFyZ2V0IHVwX2VsKTtcbiAgRXYubGlzdGVuIE15X2V2LnRvdWNoZW5kIH5vcHRzOmxpc3Rlbl9vcHMgKGZ1biBldiAtPiByZWxlYXNlIGV2IHQgRG93bikgICAoRWwuYXNfdGFyZ2V0IGRvd25fZWwpO1xuICBFdi5saXN0ZW4gTXlfZXYudG91Y2hlbmQgfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHJlbGVhc2UgZXYgdCBMZWZ0KSAgIChFbC5hc190YXJnZXQgbGVmdF9lbCk7XG4gIEV2Lmxpc3RlbiBNeV9ldi50b3VjaGVuZCB+b3B0czpsaXN0ZW5fb3BzIChmdW4gZXYgLT4gcmVsZWFzZSBldiB0IFJpZ2h0KSAgKEVsLmFzX3RhcmdldCByaWdodF9lbCk7XG4gIEV2Lmxpc3RlbiBNeV9ldi50b3VjaGVuZCB+b3B0czpsaXN0ZW5fb3BzIChmdW4gZXYgLT4gcmVsZWFzZSBldiB0IEEpICAgICAgKEVsLmFzX3RhcmdldCBhX2VsKTtcbiAgRXYubGlzdGVuIE15X2V2LnRvdWNoZW5kIH5vcHRzOmxpc3Rlbl9vcHMgKGZ1biBldiAtPiByZWxlYXNlIGV2IHQgQikgICAgICAoRWwuYXNfdGFyZ2V0IGJfZWwpO1xuICBFdi5saXN0ZW4gTXlfZXYudG91Y2hlbmQgfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHJlbGVhc2UgZXYgdCBTdGFydCkgIChFbC5hc190YXJnZXQgc3RhcnRfZWwpO1xuICBFdi5saXN0ZW4gTXlfZXYudG91Y2hlbmQgfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHJlbGVhc2UgZXYgdCBTZWxlY3QpIChFbC5hc190YXJnZXQgc2VsZWN0X2VsKVxuXG5sZXQgdGhyb3R0bGVkID0gcmVmIHRydWVcblxubGV0IHJ1bl9yb21fYnl0ZXMgY3R4IGltYWdlX2RhdGEgcm9tX2J5dGVzID1cbiAgU3RhdGUuY2xlYXIgKCk7XG4gIGxldCBjYXJ0cmlkZ2UgPSBEZXRlY3RfY2FydHJpZGdlLmYgfnJvbV9ieXRlcyBpblxuICBsZXQgbW9kdWxlIEMgPSBDYW1sYm95Lk1ha2UodmFsIGNhcnRyaWRnZSkgaW5cbiAgbGV0IHQgPSAgQy5jcmVhdGVfd2l0aF9yb20gfnByaW50X3NlcmlhbF9wb3J0OnRydWUgfnJvbV9ieXRlcyBpblxuICBzZXRfdXBfa2V5Ym9hcmQgKG1vZHVsZSBDKSB0O1xuICBzZXRfdXBfam95cGFkIChtb2R1bGUgQykgdDtcbiAgbGV0IGNudCA9IHJlZiAwIGluXG4gIGxldCBzdGFydF90aW1lID0gcmVmIChQZXJmb3JtYW5jZS5ub3dfbXMgRy5wZXJmb3JtYW5jZSkgaW5cbiAgbGV0IHNldF9mcHMgZnBzID1cbiAgICBsZXQgZnBzX3N0ciA9IFByaW50Zi5zcHJpbnRmIFwiJS4xZlwiIGZwcyBpblxuICAgIGxldCBmcHNfZWwgPSBmaW5kX2VsX2J5X2lkIFwiZnBzXCIgaW5cbiAgICBFbC5zZXRfY2hpbGRyZW4gZnBzX2VsIFtFbC50eHQgKEpzdHIudiBmcHNfc3RyKV1cbiAgaW5cbiAgbGV0IHJlYyBtYWluX2xvb3AgKCkgPVxuICAgIGJlZ2luIG1hdGNoIEMucnVuX2luc3RydWN0aW9uIHQgd2l0aFxuICAgICAgfCBJbl9mcmFtZSAtPlxuICAgICAgICBtYWluX2xvb3AgKClcbiAgICAgIHwgRnJhbWVfZW5kZWQgZmIgLT5cbiAgICAgICAgaW5jciBjbnQ7XG4gICAgICAgIGlmICFjbnQgPSA2MCB0aGVuIGJlZ2luXG4gICAgICAgICAgbGV0IGVuZF90aW1lID0gUGVyZm9ybWFuY2Uubm93X21zIEcucGVyZm9ybWFuY2UgaW5cbiAgICAgICAgICBsZXQgc2VjX3Blcl82MF9mcmFtZSA9IChlbmRfdGltZSAtLiAhc3RhcnRfdGltZSkgLy4gMTAwMC4gaW5cbiAgICAgICAgICBsZXQgZnBzID0gNjAuIC8uICBzZWNfcGVyXzYwX2ZyYW1lIGluXG4gICAgICAgICAgc3RhcnRfdGltZSA6PSBlbmRfdGltZTtcbiAgICAgICAgICBzZXRfZnBzIGZwcztcbiAgICAgICAgICBjbnQgOj0gMDtcbiAgICAgICAgZW5kO1xuICAgICAgICBkcmF3X2ZyYW1lYnVmZmVyIGN0eCBpbWFnZV9kYXRhIGZiO1xuICAgICAgICBpZiBub3QgIXRocm90dGxlZCB0aGVuXG4gICAgICAgICAgU3RhdGUucnVuX2lkIDo9IFNvbWUgKEcuc2V0X3RpbWVvdXQgfm1zOjAgbWFpbl9sb29wKVxuICAgICAgICBlbHNlXG4gICAgICAgICAgU3RhdGUucnVuX2lkIDo9IFNvbWUgKEcucmVxdWVzdF9hbmltYXRpb25fZnJhbWUgKGZ1biBfIC0+IG1haW5fbG9vcCAoKSkpXG4gICAgZW5kO1xuICBpblxuICBtYWluX2xvb3AgKClcblxubGV0IHJ1bl9yb21fYmxvYiBjdHggaW1hZ2VfZGF0YSByb21fYmxvYiA9XG4gIGxldCogcmVzdWx0ID0gQmxvYi5hcnJheV9idWZmZXIgcm9tX2Jsb2IgaW5cbiAgbWF0Y2ggcmVzdWx0IHdpdGhcbiAgfCBPayBidWYgLT5cbiAgICBsZXQgcm9tX2J5dGVzID1cbiAgICAgIFRhcnJheS5vZl9idWZmZXIgVWludDggYnVmXG4gICAgICB8PiBUYXJyYXkudG9fYmlnYXJyYXkxXG4gICAgICAoKiBDb252ZXJ0IHVpbnQ4IGJpZ2FycmF5IHRvIGNoYXIgYmlnYXJyYXkgKilcbiAgICAgIHw+IE9iai5tYWdpY1xuICAgIGluXG4gICAgRnV0LnJldHVybiBAQCBydW5fcm9tX2J5dGVzIGN0eCBpbWFnZV9kYXRhIHJvbV9ieXRlc1xuICB8IEVycm9yIGUgLT5cbiAgICBGdXQucmV0dXJuIEBAIENvbnNvbGUuKGxvZyBbSnYuRXJyb3IubWVzc2FnZSBlXSlcblxubGV0IG9uX2xvYWRfcm9tIGN0eCBpbWFnZV9kYXRhIGlucHV0X2VsID1cbiAgbGV0IGZpbGUgPSBFbC5JbnB1dC5maWxlcyBpbnB1dF9lbCB8PiBMaXN0LmhkIGluXG4gIGxldCBibG9iID0gRmlsZS5hc19ibG9iIGZpbGUgaW5cbiAgRnV0LmF3YWl0IChydW5fcm9tX2Jsb2IgY3R4IGltYWdlX2RhdGEgYmxvYikgKGZ1biAoKSAtPiAoKSlcblxubGV0IHJ1bl9zZWxlY3RlZF9yb20gY3R4IGltYWdlX2RhdGEgcm9tX3BhdGggPVxuICBsZXQqIHJlc3VsdCA9IEZldGNoLnVybCAoSnN0ci52IHJvbV9wYXRoKSBpblxuICBtYXRjaCByZXN1bHQgd2l0aFxuICB8IE9rIHJlc3BvbnNlIC0+XG4gICAgbGV0IGJvZHkgPSBGZXRjaC5SZXNwb25zZS5hc19ib2R5IHJlc3BvbnNlIGluXG4gICAgbGV0KiByZXN1bHQgPSBGZXRjaC5Cb2R5LmJsb2IgYm9keSBpblxuICAgIGJlZ2luIG1hdGNoIHJlc3VsdCB3aXRoXG4gICAgICB8IE9rIGJsb2IgLT4gcnVuX3JvbV9ibG9iIGN0eCBpbWFnZV9kYXRhIGJsb2JcbiAgICAgIHwgRXJyb3IgZSAgLT4gRnV0LnJldHVybiBAQCBDb25zb2xlLihsb2cgW0p2LkVycm9yLm1lc3NhZ2UgZV0pXG4gICAgZW5kXG4gIHwgRXJyb3IgZSAgLT4gRnV0LnJldHVybiBAQCBDb25zb2xlLihsb2cgW0p2LkVycm9yLm1lc3NhZ2UgZV0pXG5cbmxldCBzZXRfdXBfcm9tX3NlbGVjdG9yIGN0eCBpbWFnZV9kYXRhIHNlbGVjdG9yX2VsID1cbiAgcm9tX29wdGlvbnNcbiAgfD4gTGlzdC5tYXAgKGZ1biByb21fb3B0aW9uIC0+XG4gICAgICBFbC5vcHRpb25cbiAgICAgICAgfmF0OkF0Llt2YWx1ZSAoSnN0ci52IHJvbV9vcHRpb24ucGF0aCldXG4gICAgICAgIFtFbC50eHQnIHJvbV9vcHRpb24ubmFtZV0pXG4gIHw+IEVsLmFwcGVuZF9jaGlsZHJlbiBzZWxlY3Rvcl9lbDtcbiAgbGV0IG9uX2NoYW5nZSBfID1cbiAgICBsZXQgcm9tX3BhdGggPSBFbC5wcm9wIChFbC5Qcm9wLnZhbHVlKSBzZWxlY3Rvcl9lbCB8PiBKc3RyLnRvX3N0cmluZyBpblxuICAgIEZ1dC5hd2FpdCAocnVuX3NlbGVjdGVkX3JvbSBjdHggaW1hZ2VfZGF0YSByb21fcGF0aCkgKGZ1biAoKSAtPiAoKSlcbiAgaW5cbiAgRXYubGlzdGVuIEV2LmNoYW5nZSBvbl9jaGFuZ2UgKEVsLmFzX3RhcmdldCBzZWxlY3Rvcl9lbClcblxubGV0IHNldF9kZWZhdWx0X3Rocm90dGxlX3ZhbCBjaGVja2JveF9lbCA9XG4gIGxldCB1cmkgPSBXaW5kb3cubG9jYXRpb24gRy53aW5kb3cgaW5cbiAgbGV0IHBhcmFtID1cbiAgICB1cmlcbiAgICB8PiBVcmkucXVlcnlcbiAgICB8PiBVcmkuUGFyYW1zLm9mX2pzdHJcbiAgICB8PiBVcmkuUGFyYW1zLmZpbmQgSnN0ci4odiBcInRocm90dGxlZFwiKVxuICBpblxuICBsZXQgc2V0X3Rocm90dGxlZF92YWwgYiA9XG4gICAgRWwuc2V0X3Byb3AgKEVsLlByb3AuY2hlY2tlZCkgYiBjaGVja2JveF9lbDtcbiAgICB0aHJvdHRsZWQgOj0gYlxuICBpblxuICBtYXRjaCBwYXJhbSB3aXRoXG4gIHwgU29tZSBqc3RyIC0+XG4gICAgYmVnaW4gbWF0Y2ggSnN0ci50b19zdHJpbmcganN0ciB3aXRoXG4gICAgICB8IFwiZmFsc2VcIiAtPiBzZXRfdGhyb3R0bGVkX3ZhbCBmYWxzZVxuICAgICAgfCBfICAgICAgLT4gc2V0X3Rocm90dGxlZF92YWwgdHJ1ZVxuICAgIGVuZFxuICB8IE5vbmUgLT4gc2V0X3Rocm90dGxlZF92YWwgdHJ1ZVxuXG5sZXQgb25fY2hlY2tib3hfY2hhbmdlIGNoZWNrYm94X2VsID1cbiAgbGV0IGNoZWNrZWQgPSBFbC5wcm9wIChFbC5Qcm9wLmNoZWNrZWQpIGNoZWNrYm94X2VsIGluXG4gIHRocm90dGxlZCA6PSBjaGVja2VkXG5cbmxldCAoKSA9XG4gICgqIFNldCB1cCBjYW52YXMgKilcbiAgbGV0IGNhbnZhcyA9IGZpbmRfZWxfYnlfaWQgXCJjYW52YXNcIiB8PiBDYW52YXMub2ZfZWwgaW5cbiAgbGV0IGN0eCA9IEMyZC5jcmVhdGUgY2FudmFzIGluXG4gIEMyZC5zY2FsZSBjdHggfnN4OjEuNSB+c3k6MS41O1xuICBsZXQgaW1hZ2VfZGF0YSA9IEMyZC5jcmVhdGVfaW1hZ2VfZGF0YSBjdHggfnc6Z2JfdyB+aDpnYl9oIGluXG4gIGxldCBmYiA9IEFycmF5Lm1ha2VfbWF0cml4IGdiX2ggZ2JfdyBgTGlnaHRfZ3JheSBpblxuICBkcmF3X2ZyYW1lYnVmZmVyIGN0eCBpbWFnZV9kYXRhIGZiO1xuICAoKiBTZXQgdXAgdGhyb3R0bGUgY2hlY2tib3ggKilcbiAgbGV0IGNoZWNrYm94X2VsID0gZmluZF9lbF9ieV9pZCBcInRocm90dGxlXCIgaW5cbiAgc2V0X2RlZmF1bHRfdGhyb3R0bGVfdmFsIGNoZWNrYm94X2VsO1xuICBFdi5saXN0ZW4gRXYuY2hhbmdlIChmdW4gXyAtPiBvbl9jaGVja2JveF9jaGFuZ2UgY2hlY2tib3hfZWwpIChFbC5hc190YXJnZXQgY2hlY2tib3hfZWwpO1xuICAoKiBTZXQgdXAgbG9hZCByb20gYnV0dG9uICopXG4gIGxldCBpbnB1dF9lbCA9IGZpbmRfZWxfYnlfaWQgXCJsb2FkLXJvbVwiIGluXG4gIEV2Lmxpc3RlbiBFdi5jaGFuZ2UgKGZ1biBfIC0+IG9uX2xvYWRfcm9tIGN0eCBpbWFnZV9kYXRhIGlucHV0X2VsKSAoRWwuYXNfdGFyZ2V0IGlucHV0X2VsKTtcbiAgKCogU2V0IHVwIHJvbSBzZWxlY3RvciAqKVxuICBsZXQgc2VsZWN0b3JfZWwgPSBmaW5kX2VsX2J5X2lkIFwicm9tLXNlbGVjdG9yXCIgaW5cbiAgc2V0X3VwX3JvbV9zZWxlY3RvciBjdHggaW1hZ2VfZGF0YSBzZWxlY3Rvcl9lbDtcbiAgKCogTG9hZCBpbml0aWFsIHJvbSAqKVxuICBsZXQgcm9tID0gTGlzdC5oZCByb21fb3B0aW9ucyBpblxuICBsZXQgZnV0ID0gcnVuX3NlbGVjdGVkX3JvbSBjdHggaW1hZ2VfZGF0YSByb20ucGF0aCBpblxuICBGdXQuYXdhaXQgZnV0IChmdW4gKCkgLT4gKCkpXG4iXX0=
