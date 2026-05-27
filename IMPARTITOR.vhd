ENTITY IMPARTITOR IS
    GENERIC( delay: TIME := 10 ns );
    PORT(
        clock, reset: IN BIT;
        start: IN BIT;
        
        -- Intrari de date
        Deimpartit_in: IN BIT_VECTOR(15 DOWNTO 0);
        Impartitor_in: IN BIT_VECTOR(15 DOWNTO 0);
        
        -- Iesiri
        Cat_out: OUT BIT_VECTOR(15 DOWNTO 0);
        Rest_out: OUT BIT_VECTOR(16 DOWNTO 0);
        Gata_out: OUT BIT
    );
END IMPARTITOR;

ARCHITECTURE structural OF IMPARTITOR IS
    COMPONENT ExecutionUnit IS
        GENERIC( delay: TIME := 10 ns);
        PORT(
            clock, reset: IN BIT;
            deimpartit: IN BIT_VECTOR(15 DOWNTO 0);
            impartitor: IN BIT_VECTOR(15 DOWNTO 0);
            load_init: IN BIT;
            shift_en: IN BIT;
            alu_load: IN BIT;
            alu_cmd: IN BIT;
            q_bit_set: IN BIT;
            A_semn: OUT BIT;
            count: OUT BIT;
            cat: OUT BIT_VECTOR(15 DOWNTO 0);
            rest: OUT BIT_VECTOR(16 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT ControlUnit IS
        GENERIC( delay: TIME := 10 ns );
        PORT(
            clock, reset, start: IN BIT;
            A_semn, count: IN BIT;
            load_init, shift_en, alu_load, alu_cmd, q_bit_set, ready: OUT BIT
        );
    END COMPONENT;

    SIGNAL w_load, w_shift, w_alu_load, w_alu_cmd, w_q_set: BIT;
    SIGNAL w_A_semn, w_count: BIT;

BEGIN

    Creier: ControlUnit
        GENERIC MAP(delay => 10 ns)
        PORT MAP(
            clock => clock, 
            reset => reset,
            start => start,
            -- ce vine de la Exec
            A_semn => w_A_semn,
            count  => w_count,
            -- ce merge la Exec
            load_init => w_load,
            shift_en  => w_shift,
            alu_load  => w_alu_load,
            alu_cmd   => w_alu_cmd,
            q_bit_set => w_q_set,
            
            ready     => Gata_out
        );

    Corp: ExecutionUnit 
        GENERIC MAP(delay => 10 ns)
        PORT MAP(
            clock => clock, 
            reset => reset,
            
            deimpartit => Deimpartit_in,
            impartitor => Impartitor_in,
            
            -- ce vine de la Control
            load_init => w_load,
            shift_en  => w_shift,
            alu_load  => w_alu_load,
            alu_cmd   => w_alu_cmd,
            q_bit_set => w_q_set,
            
            -- ce merge la Control
            A_semn    => w_A_semn,
            count     => w_count,
            
            cat       => Cat_out,
            rest      => Rest_out
        );

END structural;
