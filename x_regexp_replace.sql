create function `x_regexp_replace`
	(subject longtext, pattern varchar(10000), replace varchar(10000))
returns longtext deterministic
begin
	declare output longtext default '';
	declare ss longtext;
	declare s int unsigned;
	declare e int unsigned;
	main_loop: loop
		if subject regexp pattern and char_length(subject) > 0
		then
			set e = char_length(subject);
			after_loop: loop
				set ss = substring(subject, 1, e);
				if ss not regexp pattern
				then
					leave after_loop;
				end if;
				set e = e - 1;
			end loop;
			set e = e + 1;
			
			set s = 2;
			before_loop: loop
				set ss = substring(subject, s, (e-s)+1);
				if ss regexp pattern
				then
					set output = concat(output, substring(subject, s-1, 1));
				else
					set output = concat(output, replace);
					leave before_loop;
				end if;
				set s = s + 1;
			end loop;
			
			set subject = substring(subject, e+1);
		else
			set output = concat(output, subject);
			leave main_loop;
		end if;
	end loop;
	return output;
end
