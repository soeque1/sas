%macro RandBetween(min, max);
	(&min + floor((1+&max-&min)*rand("uniform")));
%mend;

	proc fcmp outlib=work.funcs.baseballG;
		function check_ball(num1, num2, num3, ans1, ans2, ans3) $ 50;
		array ans {3} ans1 ans2 ans3;
		array input_num {3} num1 num2 num3;

		/* strike */
		s_cnt=0;

		/* ball   */
		b_cnt=0;

		do i=1 to dim(ans);

			do j=1 to dim(input_num);

				if input_num{i}=ans{j} and i=j then
					s_cnt=s_cnt + 1;
				else if input_num{i}=ans{j} and i <> j then
					b_cnt=b_cnt + 1;
			end;
		end;
		res=put(s_cnt, 1.)||'strikes, '|| put(b_cnt, 1.)||'balls';
		return (res);
	endsub;
		options cmplib=work.funcs;

		%MACRO run_baseball(ans);

		data ans;
			ans_1=%RandBetween(1, 10);
			ans_2=%RandBetween(1, 10);
			ans_3=%RandBetween(1, 10);
			array ans {3} ans_1 ans_2 ans3;

			do while (ans{1}=ans{2});
				ans{2}=%RandBetween(1, 10);
			end;

			do while (ans{1}=ans{3} or ans{2}=ans{3});
				ans{3}=%RandBetween(1, 10);
			end;
		run;

		%DO t_cnt=1 %TO 5;

			data _NULL_;
				
				%window info

				#5 @5 'Please Enter Numbers:'
				#5 @26 a 1 attr = underline
				#5 @28 b 1 attr = underline
				#5 @30 c 1 attr = underline;	
				
				%display info;

				set ans;
				t_cnt_p=&t_cnt||'th Trial';
				res=check_ball(a, b, c, ans_1, ans_2, ans_3);
				put t_cnt_p=;
				put res=;
			run;

		%END;
	%MEND;

	%run_baseball(ans);