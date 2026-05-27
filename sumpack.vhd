-- Fisier: sumpack.vhd
PACKAGE sumpack IS
	FUNCTION suma(op1, op2: BIT_VECTOR; cin: BIT) RETURN BIT_VECTOR;
END sumpack;

PACKAGE BODY sumpack IS
	FUNCTION suma(op1, op2: BIT_VECTOR; cin: BIT) RETURN BIT_VECTOR IS
		VARIABLE carry_temp: BIT;
		VARIABLE res: BIT_VECTOR(op1'HIGH DOWNTO op1'LOW);
	BEGIN
		carry_temp:= cin;
		FOR i IN op1'LOW TO op1'HIGH LOOP
			res(i):= op1(i) XOR op2(i) XOR carry_temp;
			carry_temp:= (op1(i) AND op2(i)) OR (op1(i) AND carry_temp) OR (op2(i) AND carry_temp);
		END LOOP;
		RETURN res;
	END FUNCTION;
END PACKAGE BODY;