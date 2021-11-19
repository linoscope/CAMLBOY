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
     {var alert=Jv[12].alert;alert(caml_call1(Jv[23],v));return 0}
    function console_log(s)
     {return caml_call1(Brr[12][9],[0,caml_jsstring_of_string(s),0])}
    function find_el_by_id(id)
     {var _ab_=caml_call2(Brr[10][2],Brr[16][2],caml_jsstring_of_string(id));
      return caml_call1(Stdlib_Option[4],_ab_)}
    function draw_framebuffer(ctx,image_data,fb)
     {var d=caml_call1(Brr_canvas[4][90][4],image_data),y=0;
      a:
      for(;;)
       {var x=0;
        for(;;)
         {var
           off=4 * ((y * 160 | 0) + x | 0) | 0,
           match=caml_check_bound(caml_check_bound(fb,y)[1 + y],x)[1 + x];
          if(-588596599 <= match)
           if(-126317716 <= match)
            {d[off] = 97;
             d[off + 1 | 0] = 104;
             d[off + 2 | 0] = 125;
             d[off + 3 | 0] = 255}
           else
            {d[off] = 229;
             d[off + 1 | 0] = 251;
             d[off + 2 | 0] = 244;
             d[off + 3 | 0] = 255}
          else
           if(-603547828 <= match)
            {d[off] = 151;
             d[off + 1 | 0] = 174;
             d[off + 2 | 0] = 184;
             d[off + 3 | 0] = 255}
           else
            {d[off] = 34;
             d[off + 1 | 0] = 30;
             d[off + 2 | 0] = 49;
             d[off + 3 | 0] = 255}
          var _aa_=x + 1 | 0;
          if(159 !== x){var x=_aa_;continue}
          var _$_=y + 1 | 0;
          if(143 !== y){var y=_$_;continue a}
          return caml_call4(Brr_canvas[4][93],ctx,image_data,0,0)}}}
    var run_id=[0,0],key_down_listener=[0,0],key_up_listener=[0,0];
    function set_listener(down,up)
     {key_down_listener[1] = [0,down];key_up_listener[1] = [0,up];return 0}
    function clear(param)
     {var _Y_=run_id[1];
      if(_Y_)
       {var timer_id=_Y_[1];
        caml_call1(Brr[16][10],timer_id);
        caml_call1(Brr[16][12],timer_id)}
      var _Z_=key_down_listener[1];
      if(_Z_)
       {var lister=_Z_[1];
        caml_call4(Brr[7][21],0,Brr[7][76],lister,Brr[16][6])}
      var ___=key_up_listener[1];
      if(___)
       {var lister$0=___[1];
        return caml_call4(Brr[7][21],0,Brr[7][77],lister$0,Brr[16][6])}
      return 0}
    var State=[0,run_id,key_down_listener,key_up_listener,set_listener,clear];
    function set_up_keyboard(C)
     {return function(t)
       {function key_down_listener(ev)
         {var key_name=caml_string_of_jsstring(caml_call1(Brr[7][31][2],ev));
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
         {var key_name=caml_string_of_jsstring(caml_call1(Brr[7][31][2],ev));
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
        caml_call4(Brr[7][20],0,Brr[7][76],key_down_listener,Brr[16][6]);
        caml_call4(Brr[7][20],0,Brr[7][77],key_up_listener,Brr[16][6]);
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
        function press(ev,t,key)
         {caml_call1(Brr[7][13],ev);
          var navigator=Brr[16][3];
          navigator.vibrate(10);
          return caml_call2(C[4],t,key)}
        function release(ev,t,key)
         {caml_call1(Brr[7][13],ev);return caml_call2(C[5],t,key)}
        var listen_ops=caml_call4(Brr[7][19],_a_,0,0,0);
        function _I_(ev){return press(ev,t,1)}
        caml_call4(Brr[7][20],[0,listen_ops],Dune_exe_My_ev[2],_I_,up_el);
        function _J_(ev){return press(ev,t,0)}
        caml_call4(Brr[7][20],[0,listen_ops],Dune_exe_My_ev[2],_J_,down_el);
        function _K_(ev){return press(ev,t,2)}
        caml_call4(Brr[7][20],[0,listen_ops],Dune_exe_My_ev[2],_K_,left_el);
        function _L_(ev){return press(ev,t,3)}
        caml_call4(Brr[7][20],[0,listen_ops],Dune_exe_My_ev[2],_L_,right_el);
        function _M_(ev){return press(ev,t,7)}
        caml_call4(Brr[7][20],[0,listen_ops],Dune_exe_My_ev[2],_M_,a_el);
        function _N_(ev){return press(ev,t,6)}
        caml_call4(Brr[7][20],[0,listen_ops],Dune_exe_My_ev[2],_N_,b_el);
        function _O_(ev){return press(ev,t,4)}
        caml_call4(Brr[7][20],[0,listen_ops],Dune_exe_My_ev[2],_O_,start_el);
        function _P_(ev){return press(ev,t,5)}
        caml_call4(Brr[7][20],[0,listen_ops],Dune_exe_My_ev[2],_P_,select_el);
        function _Q_(ev){return release(ev,t,1)}
        caml_call4(Brr[7][20],[0,listen_ops],Dune_exe_My_ev[3],_Q_,up_el);
        function _R_(ev){return release(ev,t,0)}
        caml_call4(Brr[7][20],[0,listen_ops],Dune_exe_My_ev[3],_R_,down_el);
        function _S_(ev){return release(ev,t,2)}
        caml_call4(Brr[7][20],[0,listen_ops],Dune_exe_My_ev[3],_S_,left_el);
        function _T_(ev){return release(ev,t,3)}
        caml_call4(Brr[7][20],[0,listen_ops],Dune_exe_My_ev[3],_T_,right_el);
        function _U_(ev){return release(ev,t,7)}
        caml_call4(Brr[7][20],[0,listen_ops],Dune_exe_My_ev[3],_U_,a_el);
        function _V_(ev){return release(ev,t,6)}
        caml_call4(Brr[7][20],[0,listen_ops],Dune_exe_My_ev[3],_V_,b_el);
        function _W_(ev){return release(ev,t,4)}
        caml_call4(Brr[7][20],[0,listen_ops],Dune_exe_My_ev[3],_W_,start_el);
        function _X_(ev){return release(ev,t,5)}
        return caml_call4
                (Brr[7][20],[0,listen_ops],Dune_exe_My_ev[3],_X_,select_el)}}
    var throttled=[0,1];
    function run_rom_bytes(ctx,image_data,rom_bytes)
     {caml_call1(State[5],0);
      var
       cartridge=caml_call1(Camlboy_lib_Detect_cartridge[1],rom_bytes),
       C=caml_call1(Camlboy_lib_Camlboy[1],cartridge),
       t=caml_call2(C[2],1,rom_bytes);
      caml_call1(set_up_keyboard(C),t);
      caml_call1(set_up_joypad(C),t);
      var cnt=[0,0],start_time=[0,caml_call1(Brr[15][9],Brr[16][4])];
      function main_loop(param)
       {for(;;)
         {var match=caml_call1(C[3],t);
          if(match)
           {var fb=match[1];
            cnt[1]++;
            if(60 === cnt[1])
             {var
               end_time=caml_call1(Brr[15][9],Brr[16][4]),
               sec_per_60_frame=(end_time - start_time[1]) / 1000.,
               fps=60. / sec_per_60_frame;
              start_time[1] = end_time;
              var
               fps_str=caml_call2(Stdlib_Printf[4],_b_,fps),
               fps_el=find_el_by_id(cst_fps),
               _E_=
                [0,caml_call2(Brr[9][2],0,caml_jsstring_of_string(fps_str)),0];
              caml_call2(Brr[9][18],fps_el,_E_);
              cnt[1] = 0}
            draw_framebuffer(ctx,image_data,fb);
            if(throttled[1])
             {var
               _F_=function(param){return main_loop(0)},
               _G_=[0,caml_call1(Brr[16][11],_F_)];
              State[1][1] = _G_;
              return 0}
            var _H_=[0,caml_call2(Brr[16][8],0,main_loop)];
            State[1][1] = _H_;
            return 0}
          continue}}
      return main_loop(0)}
    function run_rom_blob(ctx,image_data,rom_blob)
     {function _z_(result)
       {if(0 === result[0])
         {var
           buf=result[1],
           rom_bytes=
            runtime.caml_ba_from_typed_array(caml_call4(Brr[1][5],3,0,0,buf)),
           _B_=run_rom_bytes(ctx,image_data,rom_bytes);
          return caml_call1(Fut[3],_B_)}
        var
         e=result[1],
         _C_=[0,caml_call1(Jv[30][4],e),0],
         _D_=caml_call1(Brr[12][9],_C_);
        return caml_call1(Fut[3],_D_)}
      var _A_=caml_call1(Brr[2][8],rom_blob);
      return caml_call2(Fut[15][1],_A_,_z_)}
    function on_load_rom(ctx,image_data,input_el)
     {var
       _w_=caml_call1(Brr[9][56][1],input_el),
       file=caml_call1(Stdlib_List[5],_w_);
      function _x_(param){return 0}
      var _y_=run_rom_blob(ctx,image_data,file);
      return caml_call2(Fut[2],_y_,_x_)}
    function run_selected_rom(ctx,image_data,rom_path)
     {function _o_(result)
       {if(0 === result[0])
         {var
           response=result[1],
           _q_=
            function(result)
             {if(0 === result[0])
               {var blob=result[1];return run_rom_blob(ctx,image_data,blob)}
              var
               e=result[1],
               _u_=[0,caml_call1(Jv[30][4],e),0],
               _v_=caml_call1(Brr[12][9],_u_);
              return caml_call1(Fut[3],_v_)},
           _r_=caml_call1(Brr_io[3][1][9],response);
          return caml_call2(Fut[15][1],_r_,_q_)}
        var
         e=result[1],
         _s_=[0,caml_call1(Jv[30][4],e),0],
         _t_=caml_call1(Brr[12][9],_s_);
        return caml_call1(Fut[3],_t_)}
      var _p_=caml_call2(Brr_io[3][7],0,caml_jsstring_of_string(rom_path));
      return caml_call2(Fut[15][1],_p_,_o_)}
    function set_up_rom_selector(ctx,image_data,selector_el)
     {function _i_(rom_option)
       {var
         _m_=[0,caml_call2(Brr[9][3],0,rom_option[1]),0],
         _n_=
          [0,
           [0,caml_call1(Brr[8][37],caml_jsstring_of_string(rom_option[2])),0]];
        return caml_call3(Brr[9][127],0,_n_,_m_)}
      var _j_=caml_call1(caml_call1(Stdlib_List[19],_i_),rom_options);
      caml_call1(caml_call1(Brr[9][20],selector_el),_j_);
      function on_change(param)
       {var
         rom_path=
          caml_string_of_jsstring
           (caml_call2(Brr[9][26],Brr[9][25][10],selector_el));
        function _k_(param){return 0}
        var _l_=run_selected_rom(ctx,image_data,rom_path);
        return caml_call2(Fut[2],_l_,_k_)}
      return caml_call4(Brr[7][20],0,Brr[7][43],on_change,selector_el)}
    function set_default_throttle_val(checkbox_el)
     {var
       uri=caml_call1(Brr[13][12],Brr[16][5]),
       _g_=caml_call1(Brr[6][6],uri),
       _h_=caml_call1(Brr[6][9][7],_g_),
       param=caml_call1(caml_call1(Brr[6][9][3],"throttled"),_h_);
      function set_throttled_val(b)
       {caml_call3(Brr[9][27],Brr[9][25][5],b,checkbox_el);
        throttled[1] = b;
        return 0}
      if(param)
       {var jstr=param[1],match=caml_string_of_jsstring(jstr);
        return caml_string_notequal(match,cst_false)
                ?set_throttled_val(1)
                :set_throttled_val(0)}
      return set_throttled_val(1)}
    function on_checkbox_change(checkbox_el)
     {var checked=caml_call2(Brr[9][26],Brr[9][25][5],checkbox_el);
      throttled[1] = checked;
      return 0}
    var
     _c_=find_el_by_id(cst_canvas),
     canvas=caml_call1(Brr_canvas[3][2],_c_),
     ctx=caml_call2(Brr_canvas[4][15],0,canvas);
    caml_call3(Brr_canvas[4][36],ctx,1.5,1.5);
    var
     image_data=caml_call3(Brr_canvas[4][91],ctx,gb_w,gb_h),
     fb=caml_call3(Stdlib_Array[3],gb_h,gb_w,-603547828);
    draw_framebuffer(ctx,image_data,fb);
    var checkbox_el=find_el_by_id(cst_throttle);
    set_default_throttle_val(checkbox_el);
    function _d_(param){return on_checkbox_change(checkbox_el)}
    caml_call4(Brr[7][20],0,Brr[7][43],_d_,checkbox_el);
    var input_el=find_el_by_id(cst_load_rom);
    function _e_(param){return on_load_rom(ctx,image_data,input_el)}
    caml_call4(Brr[7][20],0,Brr[7][43],_e_,input_el);
    var selector_el=find_el_by_id(cst_rom_selector);
    set_up_rom_selector(ctx,image_data,selector_el);
    var
     rom=caml_call1(Stdlib_List[5],rom_options),
     fut=run_selected_rom(ctx,image_data,rom[2]);
    function _f_(param){return 0}
    caml_call2(Fut[2],fut,_f_);
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

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLjAsImZpbGUiOiIuaW5kZXguZW9ianMvYnl0ZS9kdW5lX19leGVfX0luZGV4LmNtby5qcyIsInNvdXJjZVJvb3QiOiIiLCJuYW1lcyI6WyJyb21fb3B0aW9ucyIsImdiX3ciLCJnYl9oIiwiYWxlcnQiLCJ2IiwiY29uc29sZV9sb2ciLCJzIiwiZmluZF9lbF9ieV9pZCIsImlkIiwiZHJhd19mcmFtZWJ1ZmZlciIsImN0eCIsImltYWdlX2RhdGEiLCJmYiIsImQiLCJ5IiwieCIsIm9mZiIsInJ1bl9pZCIsImtleV9kb3duX2xpc3RlbmVyIiwia2V5X3VwX2xpc3RlbmVyIiwic2V0X2xpc3RlbmVyIiwiZG93biIsInVwIiwiY2xlYXIiLCJ0aW1lcl9pZCIsImxpc3RlciIsImxpc3RlciQwIiwic2V0X3VwX2tleWJvYXJkIiwiQyIsInQiLCJldiIsImtleV9uYW1lIiwic2V0X3VwX2pveXBhZCIsInJpZ2h0X2VsIiwibGVmdF9lbCIsImRvd25fZWwiLCJ1cF9lbCIsImJfZWwiLCJhX2VsIiwic2VsZWN0X2VsIiwic3RhcnRfZWwiLCJwcmVzcyIsImtleSIsIm5hdmlnYXRvciIsInJlbGVhc2UiLCJsaXN0ZW5fb3BzIiwidGhyb3R0bGVkIiwicnVuX3JvbV9ieXRlcyIsInJvbV9ieXRlcyIsImNhcnRyaWRnZSIsImNudCIsInN0YXJ0X3RpbWUiLCJtYWluX2xvb3AiLCJlbmRfdGltZSIsInNlY19wZXJfNjBfZnJhbWUiLCJmcHMiLCJmcHNfc3RyIiwiZnBzX2VsIiwicnVuX3JvbV9ibG9iIiwicm9tX2Jsb2IiLCJyZXN1bHQiLCJidWYiLCJlIiwib25fbG9hZF9yb20iLCJpbnB1dF9lbCIsImZpbGUiLCJydW5fc2VsZWN0ZWRfcm9tIiwicm9tX3BhdGgiLCJyZXNwb25zZSIsImJsb2IiLCJzZXRfdXBfcm9tX3NlbGVjdG9yIiwic2VsZWN0b3JfZWwiLCJyb21fb3B0aW9uIiwib25fY2hhbmdlIiwic2V0X2RlZmF1bHRfdGhyb3R0bGVfdmFsIiwiY2hlY2tib3hfZWwiLCJ1cmkiLCJwYXJhbSIsInNldF90aHJvdHRsZWRfdmFsIiwiYiIsImpzdHIiLCJvbl9jaGVja2JveF9jaGFuZ2UiLCJjaGVja2VkIiwiY2FudmFzIiwicm9tIiwiZnV0Il0sInNvdXJjZXMiOlsiL2hvbWUvcnVubmVyL3dvcmsvQ0FNTEJPWS9DQU1MQk9ZL19idWlsZC9kZWZhdWx0L2Jpbi93ZWIvaW5kZXgubWwiXSwibWFwcGluZ3MiOiI7O0k7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7OztLQVlJQTs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7OztLQUxBQztLQUNBQzthQWVBQyxNQUFNQztNQUNJLElBQVJELG1CQUNNLE1BQXFCLGtCQUZ2QkMsSUFFRSxRQUFtQzthQUUzQ0MsWUFBWUM7TUFBc0Isd0RBQXRCQSxNQUFrQzthQUU5Q0MsY0FBY0M7TUFBSywwQ0FBa0Msd0JBQXZDQTtNQUFLLHdDQUEyRDthQUU5RUMsaUJBQWlCQyxJQUFJQyxXQUFXQztNQUMxQixzQ0FEZUQsWUFFdkJHOztNQUNFOztRQUNFOztxQkFGSkEsZUFDRUM7V0FFYyx1QkFBTixpQkFMd0JILEdBRWxDRSxVQUNFQztVQUVjOzthQVlWLEVBYkVDO2FBY0YsRUFkRUE7YUFlRixFQWZFQTthQWdCRixFQWhCRUE7O2FBR0YsRUFIRUE7YUFJRixFQUpFQTthQUtGLEVBTEVBO2FBTUYsRUFORUE7OzthQVFGLEVBUkVBO2FBU0YsRUFURUE7YUFVRixFQVZFQTthQVdGLEVBWEVBOzthQWtCRixFQWxCRUE7YUFtQkYsRUFuQkVBO2FBb0JGLEVBcEJFQTthQXFCRixFQXJCRUE7VUFBSixTQURGRDs7VUFDRSxRQUZKRDs7VUEwQkEsb0NBNUJtQkosSUFBSUMsaUJBNEJvQjtRQUl2Q00sYUFDQUMsd0JBQ0FDO2FBQ0FDLGFBQWFDLEtBQUtDO01BQ3BCLDBCQURlRCxNQUNmLHdCQURvQkMsSUFDcEIsUUFDMEI7YUFDeEJDO01BQ0YsUUFQRU47TUFPRjtRQUdJLElBREtPO1FBQ0ws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QUFjO0tBR1IsOEJBdlFSdkU7S0F3UVEscUJBakJOVSxJQUVBQyxXQWNBeUU7SUFDTSxvQkFDZSxRQUFFO0lBQTNCLGtCQURJQztJQUNKOzs7T0E5UUVwRjtPQUNBQztPQUlBRjtPQVdBRztPQUlBRTtPQUVBRTtPQUVBRTs7T0F1REFrQjtPQWlDQUs7T0E4QkFjO09BRUFDO09BcUNBVztPQWNBSztPQUtBRztPQVlBSTtPQWFBSTtPQW9CQU87SUF5QkY7VSIsInNvdXJjZXNDb250ZW50IjpbIm9wZW4gQ2FtbGJveV9saWJcbm9wZW4gQnJyXG5vcGVuIEJycl9jYW52YXNcbm9wZW4gQnJyX2lvXG5vcGVuIEZ1dC5TeW50YXhcblxuXG5sZXQgZ2JfdyA9IDE2MFxubGV0IGdiX2ggPSAxNDRcblxudHlwZSByb21fb3B0aW9uID0geyBuYW1lIDogc3RyaW5nOyBwYXRoIDogc3RyaW5nIH1cblxubGV0IHJvbV9vcHRpb25zID0gW1xuICB7bmFtZSA9IFwiVGhlIEJvdW5jaW5nIEJhbGxcIiA7IHBhdGggPSBcIi4vdGhlLWJvdW5jaW5nLWJhbGwuZ2JcIn07XG4gIHtuYW1lID0gXCJUb2J1IFRvYnUgR2lybFwiICAgIDsgcGF0aCA9IFwiLi90b2J1LmdiXCJ9O1xuICB7bmFtZSA9IFwiQ2F2ZXJuXCIgICAgICAgICAgICA7IHBhdGggPSBcIi4vY2F2ZXJuLmdiXCJ9O1xuICB7bmFtZSA9IFwiSW50byBUaGUgQmx1ZVwiICAgICA7IHBhdGggPSBcIi4vaW50by10aGUtYmx1ZS5nYlwifTtcbiAge25hbWUgPSBcIlJvY2tldCBNYW4gRGVtb1wiICAgOyBwYXRoID0gXCIuL3JvY2tldC1tYW4tZGVtby5nYlwifTtcbiAge25hbWUgPSBcIlJldHJvaWRcIiAgICAgICAgICAgOyBwYXRoID0gXCIuL3JldHJvaWQuZ2JcIn07XG4gIHtuYW1lID0gXCJXaXNoaW5nIFNhcmFoXCIgICAgIDsgcGF0aCA9IFwiLi9kcmVhbWluZy1zYXJhaC5nYlwifTtcbiAge25hbWUgPSBcIlNIRUVQIElUIFVQXCIgICAgICAgOyBwYXRoID0gXCIuL3NoZWVwLWl0LXVwLmdiXCJ9O1xuXVxuXG5sZXQgYWxlcnQgdiA9XG4gIGxldCBhbGVydCA9IEp2LmdldCBKdi5nbG9iYWwgXCJhbGVydFwiIGluXG4gIGlnbm9yZSBAQCBKdi5hcHBseSBhbGVydCBKdi5bfCBvZl9zdHJpbmcgdiB8XVxuXG5sZXQgY29uc29sZV9sb2cgcyA9IENvbnNvbGUubG9nIEpzdHIuW29mX3N0cmluZyBzXVxuXG5sZXQgZmluZF9lbF9ieV9pZCBpZCA9IERvY3VtZW50LmZpbmRfZWxfYnlfaWQgRy5kb2N1bWVudCAoSnN0ci52IGlkKSB8PiBPcHRpb24uZ2V0XG5cbmxldCBkcmF3X2ZyYW1lYnVmZmVyIGN0eCBpbWFnZV9kYXRhIGZiID1cbiAgbGV0IGQgPSBDMmQuSW1hZ2VfZGF0YS5kYXRhIGltYWdlX2RhdGEgaW5cbiAgZm9yIHkgPSAwIHRvIGdiX2ggLSAxIGRvXG4gICAgZm9yIHggPSAwIHRvIGdiX3cgLSAxIGRvXG4gICAgICBsZXQgb2ZmID0gNCAqICh5ICogZ2JfdyArIHgpIGluXG4gICAgICBtYXRjaCBmYi4oeSkuKHgpIHdpdGhcbiAgICAgIHwgYFdoaXRlIC0+XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICAgICkgMHhFNTtcbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgKyAxKSAweEZCO1xuICAgICAgICBUYXJyYXkuc2V0IGQgKG9mZiArIDIpIDB4RjQ7XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICsgMykgMHhGRjtcbiAgICAgIHwgYExpZ2h0X2dyYXkgLT5cbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgICAgKSAweDk3O1xuICAgICAgICBUYXJyYXkuc2V0IGQgKG9mZiArIDEpIDB4QUU7XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICsgMikgMHhCODtcbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgKyAzKSAweEZGO1xuICAgICAgfCBgRGFya19ncmF5IC0+XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICAgICkgMHg2MTtcbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgKyAxKSAweDY4O1xuICAgICAgICBUYXJyYXkuc2V0IGQgKG9mZiArIDIpIDB4N0Q7XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICsgMykgMHhGRjtcbiAgICAgIHwgYEJsYWNrIC0+XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICAgICkgMHgyMjtcbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgKyAxKSAweDFFO1xuICAgICAgICBUYXJyYXkuc2V0IGQgKG9mZiArIDIpIDB4MzE7XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICsgMykgMHhGRjtcbiAgICBkb25lXG4gIGRvbmU7XG4gIEMyZC5wdXRfaW1hZ2VfZGF0YSBjdHggaW1hZ2VfZGF0YSB+eDowIH55OjBcblxuKCoqIE1hbmFnZXMgc3RhdGUgdGhhdCBuZWVkIHRvIGJlIHJlc2V0IHdoZW4gbG9hZGluZyBhIG5ldyByb20gKilcbm1vZHVsZSBTdGF0ZSA9IHN0cnVjdFxuICBsZXQgcnVuX2lkID0gcmVmIE5vbmVcbiAgbGV0IGtleV9kb3duX2xpc3RlbmVyID0gcmVmIE5vbmVcbiAgbGV0IGtleV91cF9saXN0ZW5lciA9IHJlZiBOb25lXG4gIGxldCBzZXRfbGlzdGVuZXIgZG93biB1cCA9XG4gICAga2V5X2Rvd25fbGlzdGVuZXIgOj0gU29tZSBkb3duO1xuICAgIGtleV91cF9saXN0ZW5lciA6PSBTb21lIHVwXG4gIGxldCBjbGVhciAoKSA9XG4gICAgYmVnaW4gbWF0Y2ggIXJ1bl9pZCB3aXRoXG4gICAgICB8IE5vbmUgLT4gKClcbiAgICAgIHwgU29tZSB0aW1lcl9pZCAtPlxuICAgICAgICBHLnN0b3BfdGltZXIgdGltZXJfaWQ7XG4gICAgICAgIEcuY2FuY2VsX2FuaW1hdGlvbl9mcmFtZSB0aW1lcl9pZDtcbiAgICBlbmQ7XG4gICAgYmVnaW4gbWF0Y2ggIWtleV9kb3duX2xpc3RlbmVyIHdpdGhcbiAgICAgIHwgTm9uZSAtPiAoKVxuICAgICAgfCBTb21lIGxpc3RlciAtPiBFdi51bmxpc3RlbiBFdi5rZXlkb3duIGxpc3RlciBHLnRhcmdldFxuICAgIGVuZDtcbiAgICBiZWdpbiBtYXRjaCAha2V5X3VwX2xpc3RlbmVyIHdpdGhcbiAgICAgIHwgTm9uZSAtPiAoKVxuICAgICAgfCBTb21lIGxpc3RlciAtPiBFdi51bmxpc3RlbiBFdi5rZXl1cCBsaXN0ZXIgRy50YXJnZXRcbiAgICBlbmRcbmVuZFxuXG5sZXQgc2V0X3VwX2tleWJvYXJkICh0eXBlIGEpIChtb2R1bGUgQyA6IENhbWxib3lfaW50Zi5TIHdpdGggdHlwZSB0ID0gYSkgKHQgOiBhKSA9XG4gIGxldCBrZXlfZG93bl9saXN0ZW5lciBldiA9XG4gICAgbGV0IGtleV9ldiA9IEV2LmFzX3R5cGUgZXYgaW5cbiAgICBsZXQga2V5X25hbWUgPSBrZXlfZXYgfD4gRXYuS2V5Ym9hcmQua2V5IHw+IEpzdHIudG9fc3RyaW5nIGluXG4gICAgbWF0Y2gga2V5X25hbWUgd2l0aFxuICAgIHwgXCJFbnRlclwiIC0+IEMucHJlc3MgdCBTdGFydFxuICAgIHwgXCJTaGlmdFwiIC0+IEMucHJlc3MgdCBTZWxlY3RcbiAgICB8IFwialwiICAgICAtPiBDLnByZXNzIHQgQlxuICAgIHwgXCJrXCIgICAgIC0+IEMucHJlc3MgdCBBXG4gICAgfCBcIndcIiAgICAgLT4gQy5wcmVzcyB0IFVwXG4gICAgfCBcImFcIiAgICAgLT4gQy5wcmVzcyB0IExlZnRcbiAgICB8IFwic1wiICAgICAtPiBDLnByZXNzIHQgRG93blxuICAgIHwgXCJkXCIgICAgIC0+IEMucHJlc3MgdCBSaWdodFxuICAgIHwgXyAgICAgICAtPiAoKVxuICBpblxuICBsZXQga2V5X3VwX2xpc3RlbmVyIGV2ID1cbiAgICBsZXQga2V5X2V2ID0gRXYuYXNfdHlwZSBldiBpblxuICAgIGxldCBrZXlfbmFtZSA9IGtleV9ldiB8PiBFdi5LZXlib2FyZC5rZXkgfD4gSnN0ci50b19zdHJpbmcgaW5cbiAgICBtYXRjaCBrZXlfbmFtZSB3aXRoXG4gICAgfCBcIkVudGVyXCIgLT4gQy5yZWxlYXNlIHQgU3RhcnRcbiAgICB8IFwiU2hpZnRcIiAtPiBDLnJlbGVhc2UgdCBTZWxlY3RcbiAgICB8IFwialwiICAgICAtPiBDLnJlbGVhc2UgdCBCXG4gICAgfCBcImtcIiAgICAgLT4gQy5yZWxlYXNlIHQgQVxuICAgIHwgXCJ3XCIgICAgIC0+IEMucmVsZWFzZSB0IFVwXG4gICAgfCBcImFcIiAgICAgLT4gQy5yZWxlYXNlIHQgTGVmdFxuICAgIHwgXCJzXCIgICAgIC0+IEMucmVsZWFzZSB0IERvd25cbiAgICB8IFwiZFwiICAgICAtPiBDLnJlbGVhc2UgdCBSaWdodFxuICAgIHwgXyAgICAgICAtPiAoKVxuICBpblxuICBFdi5saXN0ZW4gRXYua2V5ZG93biAoa2V5X2Rvd25fbGlzdGVuZXIpIEcudGFyZ2V0O1xuICBFdi5saXN0ZW4gRXYua2V5dXAgKGtleV91cF9saXN0ZW5lcikgRy50YXJnZXQ7XG4gIFN0YXRlLnNldF9saXN0ZW5lciBrZXlfZG93bl9saXN0ZW5lciBrZXlfdXBfbGlzdGVuZXJcblxubGV0IHNldF91cF9qb3lwYWQgKHR5cGUgYSkgKG1vZHVsZSBDIDogQ2FtbGJveV9pbnRmLlMgd2l0aCB0eXBlIHQgPSBhKSAodCA6IGEpID1cbiAgbGV0IHVwX2VsLCBkb3duX2VsLCBsZWZ0X2VsLCByaWdodF9lbCA9XG4gICAgZmluZF9lbF9ieV9pZCBcInVwXCIsIGZpbmRfZWxfYnlfaWQgXCJkb3duXCIsIGZpbmRfZWxfYnlfaWQgXCJsZWZ0XCIsIGZpbmRfZWxfYnlfaWQgXCJyaWdodFwiIGluXG4gIGxldCBhX2VsLCBiX2VsID0gZmluZF9lbF9ieV9pZCBcImFcIiwgZmluZF9lbF9ieV9pZCBcImJcIiBpblxuICBsZXQgc3RhcnRfZWwsIHNlbGVjdF9lbCA9IGZpbmRfZWxfYnlfaWQgXCJzdGFydFwiLCBmaW5kX2VsX2J5X2lkIFwic2VsZWN0XCIgaW5cbiAgbGV0IHZpYmVyYXRlIG1zID1cbiAgICBsZXQgbmF2aWdhdG9yID0gRy5uYXZpZ2F0b3IgfD4gTmF2aWdhdG9yLnRvX2p2IGluXG4gICAgaWdub3JlIEBAIEp2LmNhbGwgbmF2aWdhdG9yIFwidmlicmF0ZVwiIEp2Llt8IG9mX2ludCBtcyB8XVxuICBpblxuICAoKiBUT0RPOiB1bmxpc3RlbiB0aGVzZSBsaXN0ZW5lciBvbiByb20gY2hhbmdlICopXG4gIGxldCBwcmVzcyBldiB0IGtleSA9IEV2LnByZXZlbnRfZGVmYXVsdCBldjsgdmliZXJhdGUgMTA7IEMucHJlc3MgdCBrZXkgaW5cbiAgbGV0IHJlbGVhc2UgZXYgdCBrZXkgPSBFdi5wcmV2ZW50X2RlZmF1bHQgZXY7IEMucmVsZWFzZSB0IGtleSBpblxuICBsZXQgbGlzdGVuX29wcyA9IEV2Lmxpc3Rlbl9vcHRzIH5jYXB0dXJlOnRydWUgKCkgaW5cbiAgRXYubGlzdGVuIE15X2V2LnRvdWNoc3RhcnQgfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHByZXNzIGV2IHQgVXApICAgICAoRWwuYXNfdGFyZ2V0IHVwX2VsKTtcbiAgRXYubGlzdGVuIE15X2V2LnRvdWNoc3RhcnQgfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHByZXNzIGV2IHQgRG93bikgICAoRWwuYXNfdGFyZ2V0IGRvd25fZWwpO1xuICBFdi5saXN0ZW4gTXlfZXYudG91Y2hzdGFydCB+b3B0czpsaXN0ZW5fb3BzIChmdW4gZXYgLT4gcHJlc3MgZXYgdCBMZWZ0KSAgIChFbC5hc190YXJnZXQgbGVmdF9lbCk7XG4gIEV2Lmxpc3RlbiBNeV9ldi50b3VjaHN0YXJ0IH5vcHRzOmxpc3Rlbl9vcHMgKGZ1biBldiAtPiBwcmVzcyBldiB0IFJpZ2h0KSAgKEVsLmFzX3RhcmdldCByaWdodF9lbCk7XG4gIEV2Lmxpc3RlbiBNeV9ldi50b3VjaHN0YXJ0IH5vcHRzOmxpc3Rlbl9vcHMgKGZ1biBldiAtPiBwcmVzcyBldiB0IEEpICAgICAgKEVsLmFzX3RhcmdldCBhX2VsKTtcbiAgRXYubGlzdGVuIE15X2V2LnRvdWNoc3RhcnQgfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHByZXNzIGV2IHQgQikgICAgICAoRWwuYXNfdGFyZ2V0IGJfZWwpO1xuICBFdi5saXN0ZW4gTXlfZXYudG91Y2hzdGFydCB+b3B0czpsaXN0ZW5fb3BzIChmdW4gZXYgLT4gcHJlc3MgZXYgdCBTdGFydCkgIChFbC5hc190YXJnZXQgc3RhcnRfZWwpO1xuICBFdi5saXN0ZW4gTXlfZXYudG91Y2hzdGFydCB+b3B0czpsaXN0ZW5fb3BzIChmdW4gZXYgLT4gcHJlc3MgZXYgdCBTZWxlY3QpIChFbC5hc190YXJnZXQgc2VsZWN0X2VsKTtcbiAgRXYubGlzdGVuIE15X2V2LnRvdWNoZW5kIH5vcHRzOmxpc3Rlbl9vcHMgKGZ1biBldiAtPiByZWxlYXNlIGV2IHQgVXApICAgICAoRWwuYXNfdGFyZ2V0IHVwX2VsKTtcbiAgRXYubGlzdGVuIE15X2V2LnRvdWNoZW5kIH5vcHRzOmxpc3Rlbl9vcHMgKGZ1biBldiAtPiByZWxlYXNlIGV2IHQgRG93bikgICAoRWwuYXNfdGFyZ2V0IGRvd25fZWwpO1xuICBFdi5saXN0ZW4gTXlfZXYudG91Y2hlbmQgfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHJlbGVhc2UgZXYgdCBMZWZ0KSAgIChFbC5hc190YXJnZXQgbGVmdF9lbCk7XG4gIEV2Lmxpc3RlbiBNeV9ldi50b3VjaGVuZCB+b3B0czpsaXN0ZW5fb3BzIChmdW4gZXYgLT4gcmVsZWFzZSBldiB0IFJpZ2h0KSAgKEVsLmFzX3RhcmdldCByaWdodF9lbCk7XG4gIEV2Lmxpc3RlbiBNeV9ldi50b3VjaGVuZCB+b3B0czpsaXN0ZW5fb3BzIChmdW4gZXYgLT4gcmVsZWFzZSBldiB0IEEpICAgICAgKEVsLmFzX3RhcmdldCBhX2VsKTtcbiAgRXYubGlzdGVuIE15X2V2LnRvdWNoZW5kIH5vcHRzOmxpc3Rlbl9vcHMgKGZ1biBldiAtPiByZWxlYXNlIGV2IHQgQikgICAgICAoRWwuYXNfdGFyZ2V0IGJfZWwpO1xuICBFdi5saXN0ZW4gTXlfZXYudG91Y2hlbmQgfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHJlbGVhc2UgZXYgdCBTdGFydCkgIChFbC5hc190YXJnZXQgc3RhcnRfZWwpO1xuICBFdi5saXN0ZW4gTXlfZXYudG91Y2hlbmQgfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHJlbGVhc2UgZXYgdCBTZWxlY3QpIChFbC5hc190YXJnZXQgc2VsZWN0X2VsKVxuXG5sZXQgdGhyb3R0bGVkID0gcmVmIHRydWVcblxubGV0IHJ1bl9yb21fYnl0ZXMgY3R4IGltYWdlX2RhdGEgcm9tX2J5dGVzID1cbiAgU3RhdGUuY2xlYXIgKCk7XG4gIGxldCBjYXJ0cmlkZ2UgPSBEZXRlY3RfY2FydHJpZGdlLmYgfnJvbV9ieXRlcyBpblxuICBsZXQgbW9kdWxlIEMgPSBDYW1sYm95Lk1ha2UodmFsIGNhcnRyaWRnZSkgaW5cbiAgbGV0IHQgPSAgQy5jcmVhdGVfd2l0aF9yb20gfnByaW50X3NlcmlhbF9wb3J0OnRydWUgfnJvbV9ieXRlcyBpblxuICBzZXRfdXBfa2V5Ym9hcmQgKG1vZHVsZSBDKSB0O1xuICBzZXRfdXBfam95cGFkIChtb2R1bGUgQykgdDtcbiAgbGV0IGNudCA9IHJlZiAwIGluXG4gIGxldCBzdGFydF90aW1lID0gcmVmIChQZXJmb3JtYW5jZS5ub3dfbXMgRy5wZXJmb3JtYW5jZSkgaW5cbiAgbGV0IHNldF9mcHMgZnBzID1cbiAgICBsZXQgZnBzX3N0ciA9IFByaW50Zi5zcHJpbnRmIFwiJS4xZlwiIGZwcyBpblxuICAgIGxldCBmcHNfZWwgPSBmaW5kX2VsX2J5X2lkIFwiZnBzXCIgaW5cbiAgICBFbC5zZXRfY2hpbGRyZW4gZnBzX2VsIFtFbC50eHQgKEpzdHIudiBmcHNfc3RyKV1cbiAgaW5cbiAgbGV0IHJlYyBtYWluX2xvb3AgKCkgPVxuICAgIGJlZ2luIG1hdGNoIEMucnVuX2luc3RydWN0aW9uIHQgd2l0aFxuICAgICAgfCBJbl9mcmFtZSAtPlxuICAgICAgICBtYWluX2xvb3AgKClcbiAgICAgIHwgRnJhbWVfZW5kZWQgZmIgLT5cbiAgICAgICAgaW5jciBjbnQ7XG4gICAgICAgIGlmICFjbnQgPSA2MCB0aGVuIGJlZ2luXG4gICAgICAgICAgbGV0IGVuZF90aW1lID0gUGVyZm9ybWFuY2Uubm93X21zIEcucGVyZm9ybWFuY2UgaW5cbiAgICAgICAgICBsZXQgc2VjX3Blcl82MF9mcmFtZSA9IChlbmRfdGltZSAtLiAhc3RhcnRfdGltZSkgLy4gMTAwMC4gaW5cbiAgICAgICAgICBsZXQgZnBzID0gNjAuIC8uICBzZWNfcGVyXzYwX2ZyYW1lIGluXG4gICAgICAgICAgc3RhcnRfdGltZSA6PSBlbmRfdGltZTtcbiAgICAgICAgICBzZXRfZnBzIGZwcztcbiAgICAgICAgICBjbnQgOj0gMDtcbiAgICAgICAgZW5kO1xuICAgICAgICBkcmF3X2ZyYW1lYnVmZmVyIGN0eCBpbWFnZV9kYXRhIGZiO1xuICAgICAgICBpZiBub3QgIXRocm90dGxlZCB0aGVuXG4gICAgICAgICAgU3RhdGUucnVuX2lkIDo9IFNvbWUgKEcuc2V0X3RpbWVvdXQgfm1zOjAgbWFpbl9sb29wKVxuICAgICAgICBlbHNlXG4gICAgICAgICAgU3RhdGUucnVuX2lkIDo9IFNvbWUgKEcucmVxdWVzdF9hbmltYXRpb25fZnJhbWUgKGZ1biBfIC0+IG1haW5fbG9vcCAoKSkpXG4gICAgZW5kO1xuICBpblxuICBtYWluX2xvb3AgKClcblxubGV0IHJ1bl9yb21fYmxvYiBjdHggaW1hZ2VfZGF0YSByb21fYmxvYiA9XG4gIGxldCogcmVzdWx0ID0gQmxvYi5hcnJheV9idWZmZXIgcm9tX2Jsb2IgaW5cbiAgbWF0Y2ggcmVzdWx0IHdpdGhcbiAgfCBPayBidWYgLT5cbiAgICBsZXQgcm9tX2J5dGVzID1cbiAgICAgIFRhcnJheS5vZl9idWZmZXIgVWludDggYnVmXG4gICAgICB8PiBUYXJyYXkudG9fYmlnYXJyYXkxXG4gICAgICAoKiBDb252ZXJ0IHVpbnQ4IGJpZ2FycmF5IHRvIGNoYXIgYmlnYXJyYXkgKilcbiAgICAgIHw+IE9iai5tYWdpY1xuICAgIGluXG4gICAgRnV0LnJldHVybiBAQCBydW5fcm9tX2J5dGVzIGN0eCBpbWFnZV9kYXRhIHJvbV9ieXRlc1xuICB8IEVycm9yIGUgLT5cbiAgICBGdXQucmV0dXJuIEBAIENvbnNvbGUuKGxvZyBbSnYuRXJyb3IubWVzc2FnZSBlXSlcblxubGV0IG9uX2xvYWRfcm9tIGN0eCBpbWFnZV9kYXRhIGlucHV0X2VsID1cbiAgbGV0IGZpbGUgPSBFbC5JbnB1dC5maWxlcyBpbnB1dF9lbCB8PiBMaXN0LmhkIGluXG4gIGxldCBibG9iID0gRmlsZS5hc19ibG9iIGZpbGUgaW5cbiAgRnV0LmF3YWl0IChydW5fcm9tX2Jsb2IgY3R4IGltYWdlX2RhdGEgYmxvYikgKGZ1biAoKSAtPiAoKSlcblxubGV0IHJ1bl9zZWxlY3RlZF9yb20gY3R4IGltYWdlX2RhdGEgcm9tX3BhdGggPVxuICBsZXQqIHJlc3VsdCA9IEZldGNoLnVybCAoSnN0ci52IHJvbV9wYXRoKSBpblxuICBtYXRjaCByZXN1bHQgd2l0aFxuICB8IE9rIHJlc3BvbnNlIC0+XG4gICAgbGV0IGJvZHkgPSBGZXRjaC5SZXNwb25zZS5hc19ib2R5IHJlc3BvbnNlIGluXG4gICAgbGV0KiByZXN1bHQgPSBGZXRjaC5Cb2R5LmJsb2IgYm9keSBpblxuICAgIGJlZ2luIG1hdGNoIHJlc3VsdCB3aXRoXG4gICAgICB8IE9rIGJsb2IgLT4gcnVuX3JvbV9ibG9iIGN0eCBpbWFnZV9kYXRhIGJsb2JcbiAgICAgIHwgRXJyb3IgZSAgLT4gRnV0LnJldHVybiBAQCBDb25zb2xlLihsb2cgW0p2LkVycm9yLm1lc3NhZ2UgZV0pXG4gICAgZW5kXG4gIHwgRXJyb3IgZSAgLT4gRnV0LnJldHVybiBAQCBDb25zb2xlLihsb2cgW0p2LkVycm9yLm1lc3NhZ2UgZV0pXG5cbmxldCBzZXRfdXBfcm9tX3NlbGVjdG9yIGN0eCBpbWFnZV9kYXRhIHNlbGVjdG9yX2VsID1cbiAgcm9tX29wdGlvbnNcbiAgfD4gTGlzdC5tYXAgKGZ1biByb21fb3B0aW9uIC0+XG4gICAgICBFbC5vcHRpb25cbiAgICAgICAgfmF0OkF0Llt2YWx1ZSAoSnN0ci52IHJvbV9vcHRpb24ucGF0aCldXG4gICAgICAgIFtFbC50eHQnIHJvbV9vcHRpb24ubmFtZV0pXG4gIHw+IEVsLmFwcGVuZF9jaGlsZHJlbiBzZWxlY3Rvcl9lbDtcbiAgbGV0IG9uX2NoYW5nZSBfID1cbiAgICBsZXQgcm9tX3BhdGggPSBFbC5wcm9wIChFbC5Qcm9wLnZhbHVlKSBzZWxlY3Rvcl9lbCB8PiBKc3RyLnRvX3N0cmluZyBpblxuICAgIEZ1dC5hd2FpdCAocnVuX3NlbGVjdGVkX3JvbSBjdHggaW1hZ2VfZGF0YSByb21fcGF0aCkgKGZ1biAoKSAtPiAoKSlcbiAgaW5cbiAgRXYubGlzdGVuIEV2LmNoYW5nZSBvbl9jaGFuZ2UgKEVsLmFzX3RhcmdldCBzZWxlY3Rvcl9lbClcblxubGV0IHNldF9kZWZhdWx0X3Rocm90dGxlX3ZhbCBjaGVja2JveF9lbCA9XG4gIGxldCB1cmkgPSBXaW5kb3cubG9jYXRpb24gRy53aW5kb3cgaW5cbiAgbGV0IHBhcmFtID1cbiAgICB1cmlcbiAgICB8PiBVcmkucXVlcnlcbiAgICB8PiBVcmkuUGFyYW1zLm9mX2pzdHJcbiAgICB8PiBVcmkuUGFyYW1zLmZpbmQgSnN0ci4odiBcInRocm90dGxlZFwiKVxuICBpblxuICBsZXQgc2V0X3Rocm90dGxlZF92YWwgYiA9XG4gICAgRWwuc2V0X3Byb3AgKEVsLlByb3AuY2hlY2tlZCkgYiBjaGVja2JveF9lbDtcbiAgICB0aHJvdHRsZWQgOj0gYlxuICBpblxuICBtYXRjaCBwYXJhbSB3aXRoXG4gIHwgU29tZSBqc3RyIC0+XG4gICAgYmVnaW4gbWF0Y2ggSnN0ci50b19zdHJpbmcganN0ciB3aXRoXG4gICAgICB8IFwiZmFsc2VcIiAtPiBzZXRfdGhyb3R0bGVkX3ZhbCBmYWxzZVxuICAgICAgfCBfICAgICAgLT4gc2V0X3Rocm90dGxlZF92YWwgdHJ1ZVxuICAgIGVuZFxuICB8IE5vbmUgLT4gc2V0X3Rocm90dGxlZF92YWwgdHJ1ZVxuXG5sZXQgb25fY2hlY2tib3hfY2hhbmdlIGNoZWNrYm94X2VsID1cbiAgbGV0IGNoZWNrZWQgPSBFbC5wcm9wIChFbC5Qcm9wLmNoZWNrZWQpIGNoZWNrYm94X2VsIGluXG4gIHRocm90dGxlZCA6PSBjaGVja2VkXG5cbmxldCAoKSA9XG4gICgqIFNldCB1cCBjYW52YXMgKilcbiAgbGV0IGNhbnZhcyA9IGZpbmRfZWxfYnlfaWQgXCJjYW52YXNcIiB8PiBDYW52YXMub2ZfZWwgaW5cbiAgbGV0IGN0eCA9IEMyZC5jcmVhdGUgY2FudmFzIGluXG4gIEMyZC5zY2FsZSBjdHggfnN4OjEuNSB+c3k6MS41O1xuICBsZXQgaW1hZ2VfZGF0YSA9IEMyZC5jcmVhdGVfaW1hZ2VfZGF0YSBjdHggfnc6Z2JfdyB+aDpnYl9oIGluXG4gIGxldCBmYiA9IEFycmF5Lm1ha2VfbWF0cml4IGdiX2ggZ2JfdyBgTGlnaHRfZ3JheSBpblxuICBkcmF3X2ZyYW1lYnVmZmVyIGN0eCBpbWFnZV9kYXRhIGZiO1xuICAoKiBTZXQgdXAgdGhyb3R0bGUgY2hlY2tib3ggKilcbiAgbGV0IGNoZWNrYm94X2VsID0gZmluZF9lbF9ieV9pZCBcInRocm90dGxlXCIgaW5cbiAgc2V0X2RlZmF1bHRfdGhyb3R0bGVfdmFsIGNoZWNrYm94X2VsO1xuICBFdi5saXN0ZW4gRXYuY2hhbmdlIChmdW4gXyAtPiBvbl9jaGVja2JveF9jaGFuZ2UgY2hlY2tib3hfZWwpIChFbC5hc190YXJnZXQgY2hlY2tib3hfZWwpO1xuICAoKiBTZXQgdXAgbG9hZCByb20gYnV0dG9uICopXG4gIGxldCBpbnB1dF9lbCA9IGZpbmRfZWxfYnlfaWQgXCJsb2FkLXJvbVwiIGluXG4gIEV2Lmxpc3RlbiBFdi5jaGFuZ2UgKGZ1biBfIC0+IG9uX2xvYWRfcm9tIGN0eCBpbWFnZV9kYXRhIGlucHV0X2VsKSAoRWwuYXNfdGFyZ2V0IGlucHV0X2VsKTtcbiAgKCogU2V0IHVwIHJvbSBzZWxlY3RvciAqKVxuICBsZXQgc2VsZWN0b3JfZWwgPSBmaW5kX2VsX2J5X2lkIFwicm9tLXNlbGVjdG9yXCIgaW5cbiAgc2V0X3VwX3JvbV9zZWxlY3RvciBjdHggaW1hZ2VfZGF0YSBzZWxlY3Rvcl9lbDtcbiAgKCogTG9hZCBpbml0aWFsIHJvbSAqKVxuICBsZXQgcm9tID0gTGlzdC5oZCByb21fb3B0aW9ucyBpblxuICBsZXQgZnV0ID0gcnVuX3NlbGVjdGVkX3JvbSBjdHggaW1hZ2VfZGF0YSByb20ucGF0aCBpblxuICBGdXQuYXdhaXQgZnV0IChmdW4gKCkgLT4gKCkpXG4iXX0=
