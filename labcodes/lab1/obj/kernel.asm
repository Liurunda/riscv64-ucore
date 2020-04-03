
bin/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

00000000c0000000 <kern_entry>:
    c0000000:	00004117          	auipc	sp,0x4
    c0000004:	00010113          	mv	sp,sp
    c0000008:	a009                	j	c000000a <kern_init>

00000000c000000a <kern_init>:
    c000000a:	00004517          	auipc	a0,0x4
    c000000e:	ff650513          	addi	a0,a0,-10 # c0004000 <bootstacktop>
    c0000012:	00004617          	auipc	a2,0x4
    c0000016:	ffa60613          	addi	a2,a2,-6 # c000400c <end>
    c000001a:	1141                	addi	sp,sp,-16
    c000001c:	9e09                	subw	a2,a2,a0
    c000001e:	4581                	li	a1,0
    c0000020:	e406                	sd	ra,8(sp)
    c0000022:	532000ef          	jal	ra,c0000554 <memset>
    c0000026:	15a000ef          	jal	ra,c0000180 <cons_init>
    c000002a:	00001597          	auipc	a1,0x1
    c000002e:	93658593          	addi	a1,a1,-1738 # c0000960 <etext+0x4>
    c0000032:	00001517          	auipc	a0,0x1
    c0000036:	94e50513          	addi	a0,a0,-1714 # c0000980 <etext+0x24>
    c000003a:	038000ef          	jal	ra,c0000072 <cprintf>
    c000003e:	068000ef          	jal	ra,c00000a6 <print_kerninfo>
    c0000042:	4ea000ef          	jal	ra,c000052c <pmm_init>
    c0000046:	144000ef          	jal	ra,c000018a <pic_init>
    c000004a:	148000ef          	jal	ra,c0000192 <idt_init>
    c000004e:	0e6000ef          	jal	ra,c0000134 <clock_init>
    c0000052:	13a000ef          	jal	ra,c000018c <intr_enable>
    c0000056:	a001                	j	c0000056 <kern_init+0x4c>

00000000c0000058 <cputch>:
    c0000058:	1141                	addi	sp,sp,-16
    c000005a:	e022                	sd	s0,0(sp)
    c000005c:	e406                	sd	ra,8(sp)
    c000005e:	842e                	mv	s0,a1
    c0000060:	122000ef          	jal	ra,c0000182 <cons_putc>
    c0000064:	401c                	lw	a5,0(s0)
    c0000066:	60a2                	ld	ra,8(sp)
    c0000068:	2785                	addiw	a5,a5,1
    c000006a:	c01c                	sw	a5,0(s0)
    c000006c:	6402                	ld	s0,0(sp)
    c000006e:	0141                	addi	sp,sp,16
    c0000070:	8082                	ret

00000000c0000072 <cprintf>:
    c0000072:	711d                	addi	sp,sp,-96
    c0000074:	02810313          	addi	t1,sp,40 # c0004028 <end+0x1c>
    c0000078:	f42e                	sd	a1,40(sp)
    c000007a:	f832                	sd	a2,48(sp)
    c000007c:	fc36                	sd	a3,56(sp)
    c000007e:	862a                	mv	a2,a0
    c0000080:	004c                	addi	a1,sp,4
    c0000082:	00000517          	auipc	a0,0x0
    c0000086:	fd650513          	addi	a0,a0,-42 # c0000058 <cputch>
    c000008a:	869a                	mv	a3,t1
    c000008c:	ec06                	sd	ra,24(sp)
    c000008e:	e0ba                	sd	a4,64(sp)
    c0000090:	e4be                	sd	a5,72(sp)
    c0000092:	e8c2                	sd	a6,80(sp)
    c0000094:	ecc6                	sd	a7,88(sp)
    c0000096:	e41a                	sd	t1,8(sp)
    c0000098:	c202                	sw	zero,4(sp)
    c000009a:	542000ef          	jal	ra,c00005dc <vprintfmt>
    c000009e:	60e2                	ld	ra,24(sp)
    c00000a0:	4512                	lw	a0,4(sp)
    c00000a2:	6125                	addi	sp,sp,96
    c00000a4:	8082                	ret

00000000c00000a6 <print_kerninfo>:
    c00000a6:	1141                	addi	sp,sp,-16
    c00000a8:	00001517          	auipc	a0,0x1
    c00000ac:	8e050513          	addi	a0,a0,-1824 # c0000988 <etext+0x2c>
    c00000b0:	e406                	sd	ra,8(sp)
    c00000b2:	fc1ff0ef          	jal	ra,c0000072 <cprintf>
    c00000b6:	00000597          	auipc	a1,0x0
    c00000ba:	f5458593          	addi	a1,a1,-172 # c000000a <kern_init>
    c00000be:	00001517          	auipc	a0,0x1
    c00000c2:	8ea50513          	addi	a0,a0,-1814 # c00009a8 <etext+0x4c>
    c00000c6:	fadff0ef          	jal	ra,c0000072 <cprintf>
    c00000ca:	00001597          	auipc	a1,0x1
    c00000ce:	89258593          	addi	a1,a1,-1902 # c000095c <etext>
    c00000d2:	00001517          	auipc	a0,0x1
    c00000d6:	8f650513          	addi	a0,a0,-1802 # c00009c8 <etext+0x6c>
    c00000da:	f99ff0ef          	jal	ra,c0000072 <cprintf>
    c00000de:	00004597          	auipc	a1,0x4
    c00000e2:	f2258593          	addi	a1,a1,-222 # c0004000 <bootstacktop>
    c00000e6:	00001517          	auipc	a0,0x1
    c00000ea:	90250513          	addi	a0,a0,-1790 # c00009e8 <etext+0x8c>
    c00000ee:	f85ff0ef          	jal	ra,c0000072 <cprintf>
    c00000f2:	00004597          	auipc	a1,0x4
    c00000f6:	f1a58593          	addi	a1,a1,-230 # c000400c <end>
    c00000fa:	00001517          	auipc	a0,0x1
    c00000fe:	90e50513          	addi	a0,a0,-1778 # c0000a08 <etext+0xac>
    c0000102:	f71ff0ef          	jal	ra,c0000072 <cprintf>
    c0000106:	00004597          	auipc	a1,0x4
    c000010a:	30558593          	addi	a1,a1,773 # c000440b <end+0x3ff>
    c000010e:	00000797          	auipc	a5,0x0
    c0000112:	efc78793          	addi	a5,a5,-260 # c000000a <kern_init>
    c0000116:	40f587b3          	sub	a5,a1,a5
    c000011a:	43f7d593          	srai	a1,a5,0x3f
    c000011e:	60a2                	ld	ra,8(sp)
    c0000120:	3ff5f593          	andi	a1,a1,1023
    c0000124:	95be                	add	a1,a1,a5
    c0000126:	85a9                	srai	a1,a1,0xa
    c0000128:	00001517          	auipc	a0,0x1
    c000012c:	90050513          	addi	a0,a0,-1792 # c0000a28 <etext+0xcc>
    c0000130:	0141                	addi	sp,sp,16
    c0000132:	b781                	j	c0000072 <cprintf>

00000000c0000134 <clock_init>:
    c0000134:	1141                	addi	sp,sp,-16
    c0000136:	e406                	sd	ra,8(sp)
    c0000138:	880000e7          	jalr	-1920(zero) # 0 <BASE_ADDRESS-0xc0000000>
    c000013c:	1f400793          	li	a5,500
    c0000140:	02f55533          	divu	a0,a0,a5
    c0000144:	00004797          	auipc	a5,0x4
    c0000148:	eaa7be23          	sd	a0,-324(a5) # c0004000 <bootstacktop>
    c000014c:	c01027f3          	rdtime	a5
    c0000150:	953e                	add	a0,a0,a5
    c0000152:	8a0000e7          	jalr	-1888(zero) # 0 <BASE_ADDRESS-0xc0000000>
    c0000156:	60a2                	ld	ra,8(sp)
    c0000158:	00004797          	auipc	a5,0x4
    c000015c:	ea07a823          	sw	zero,-336(a5) # c0004008 <ticks>
    c0000160:	00001517          	auipc	a0,0x1
    c0000164:	8f850513          	addi	a0,a0,-1800 # c0000a58 <etext+0xfc>
    c0000168:	0141                	addi	sp,sp,16
    c000016a:	b721                	j	c0000072 <cprintf>

00000000c000016c <clock_set_next_event>:
    c000016c:	c0102573          	rdtime	a0
    c0000170:	00004797          	auipc	a5,0x4
    c0000174:	e9078793          	addi	a5,a5,-368 # c0004000 <bootstacktop>
    c0000178:	639c                	ld	a5,0(a5)
    c000017a:	953e                	add	a0,a0,a5
    c000017c:	8a000067          	jr	-1888(zero) # 0 <BASE_ADDRESS-0xc0000000>

00000000c0000180 <cons_init>:
    c0000180:	8082                	ret

00000000c0000182 <cons_putc>:
    c0000182:	0ff57513          	andi	a0,a0,255
    c0000186:	83000067          	jr	-2000(zero) # 0 <BASE_ADDRESS-0xc0000000>

00000000c000018a <pic_init>:
    c000018a:	8082                	ret

00000000c000018c <intr_enable>:
    c000018c:	100167f3          	csrrsi	a5,sstatus,2
    c0000190:	8082                	ret

00000000c0000192 <idt_init>:
    c0000192:	14005073          	csrwi	sscratch,0
    c0000196:	00000797          	auipc	a5,0x0
    c000019a:	2e078793          	addi	a5,a5,736 # c0000476 <__alltraps>
    c000019e:	10579073          	csrw	stvec,a5
    c00001a2:	8082                	ret

00000000c00001a4 <print_regs>:
    c00001a4:	410c                	lw	a1,0(a0)
    c00001a6:	1141                	addi	sp,sp,-16
    c00001a8:	e022                	sd	s0,0(sp)
    c00001aa:	842a                	mv	s0,a0
    c00001ac:	00001517          	auipc	a0,0x1
    c00001b0:	9ac50513          	addi	a0,a0,-1620 # c0000b58 <etext+0x1fc>
    c00001b4:	e406                	sd	ra,8(sp)
    c00001b6:	ebdff0ef          	jal	ra,c0000072 <cprintf>
    c00001ba:	404c                	lw	a1,4(s0)
    c00001bc:	00001517          	auipc	a0,0x1
    c00001c0:	9b450513          	addi	a0,a0,-1612 # c0000b70 <etext+0x214>
    c00001c4:	eafff0ef          	jal	ra,c0000072 <cprintf>
    c00001c8:	440c                	lw	a1,8(s0)
    c00001ca:	00001517          	auipc	a0,0x1
    c00001ce:	9be50513          	addi	a0,a0,-1602 # c0000b88 <etext+0x22c>
    c00001d2:	ea1ff0ef          	jal	ra,c0000072 <cprintf>
    c00001d6:	444c                	lw	a1,12(s0)
    c00001d8:	00001517          	auipc	a0,0x1
    c00001dc:	9c850513          	addi	a0,a0,-1592 # c0000ba0 <etext+0x244>
    c00001e0:	e93ff0ef          	jal	ra,c0000072 <cprintf>
    c00001e4:	480c                	lw	a1,16(s0)
    c00001e6:	00001517          	auipc	a0,0x1
    c00001ea:	9d250513          	addi	a0,a0,-1582 # c0000bb8 <etext+0x25c>
    c00001ee:	e85ff0ef          	jal	ra,c0000072 <cprintf>
    c00001f2:	484c                	lw	a1,20(s0)
    c00001f4:	00001517          	auipc	a0,0x1
    c00001f8:	9dc50513          	addi	a0,a0,-1572 # c0000bd0 <etext+0x274>
    c00001fc:	e77ff0ef          	jal	ra,c0000072 <cprintf>
    c0000200:	4c0c                	lw	a1,24(s0)
    c0000202:	00001517          	auipc	a0,0x1
    c0000206:	9e650513          	addi	a0,a0,-1562 # c0000be8 <etext+0x28c>
    c000020a:	e69ff0ef          	jal	ra,c0000072 <cprintf>
    c000020e:	4c4c                	lw	a1,28(s0)
    c0000210:	00001517          	auipc	a0,0x1
    c0000214:	9f050513          	addi	a0,a0,-1552 # c0000c00 <etext+0x2a4>
    c0000218:	e5bff0ef          	jal	ra,c0000072 <cprintf>
    c000021c:	500c                	lw	a1,32(s0)
    c000021e:	00001517          	auipc	a0,0x1
    c0000222:	9fa50513          	addi	a0,a0,-1542 # c0000c18 <etext+0x2bc>
    c0000226:	e4dff0ef          	jal	ra,c0000072 <cprintf>
    c000022a:	504c                	lw	a1,36(s0)
    c000022c:	00001517          	auipc	a0,0x1
    c0000230:	a0450513          	addi	a0,a0,-1532 # c0000c30 <etext+0x2d4>
    c0000234:	e3fff0ef          	jal	ra,c0000072 <cprintf>
    c0000238:	540c                	lw	a1,40(s0)
    c000023a:	00001517          	auipc	a0,0x1
    c000023e:	a0e50513          	addi	a0,a0,-1522 # c0000c48 <etext+0x2ec>
    c0000242:	e31ff0ef          	jal	ra,c0000072 <cprintf>
    c0000246:	544c                	lw	a1,44(s0)
    c0000248:	00001517          	auipc	a0,0x1
    c000024c:	a1850513          	addi	a0,a0,-1512 # c0000c60 <etext+0x304>
    c0000250:	e23ff0ef          	jal	ra,c0000072 <cprintf>
    c0000254:	580c                	lw	a1,48(s0)
    c0000256:	00001517          	auipc	a0,0x1
    c000025a:	a2250513          	addi	a0,a0,-1502 # c0000c78 <etext+0x31c>
    c000025e:	e15ff0ef          	jal	ra,c0000072 <cprintf>
    c0000262:	584c                	lw	a1,52(s0)
    c0000264:	00001517          	auipc	a0,0x1
    c0000268:	a2c50513          	addi	a0,a0,-1492 # c0000c90 <etext+0x334>
    c000026c:	e07ff0ef          	jal	ra,c0000072 <cprintf>
    c0000270:	5c0c                	lw	a1,56(s0)
    c0000272:	00001517          	auipc	a0,0x1
    c0000276:	a3650513          	addi	a0,a0,-1482 # c0000ca8 <etext+0x34c>
    c000027a:	df9ff0ef          	jal	ra,c0000072 <cprintf>
    c000027e:	5c4c                	lw	a1,60(s0)
    c0000280:	00001517          	auipc	a0,0x1
    c0000284:	a4050513          	addi	a0,a0,-1472 # c0000cc0 <etext+0x364>
    c0000288:	debff0ef          	jal	ra,c0000072 <cprintf>
    c000028c:	402c                	lw	a1,64(s0)
    c000028e:	00001517          	auipc	a0,0x1
    c0000292:	a4a50513          	addi	a0,a0,-1462 # c0000cd8 <etext+0x37c>
    c0000296:	dddff0ef          	jal	ra,c0000072 <cprintf>
    c000029a:	406c                	lw	a1,68(s0)
    c000029c:	00001517          	auipc	a0,0x1
    c00002a0:	a5450513          	addi	a0,a0,-1452 # c0000cf0 <etext+0x394>
    c00002a4:	dcfff0ef          	jal	ra,c0000072 <cprintf>
    c00002a8:	442c                	lw	a1,72(s0)
    c00002aa:	00001517          	auipc	a0,0x1
    c00002ae:	a5e50513          	addi	a0,a0,-1442 # c0000d08 <etext+0x3ac>
    c00002b2:	dc1ff0ef          	jal	ra,c0000072 <cprintf>
    c00002b6:	446c                	lw	a1,76(s0)
    c00002b8:	00001517          	auipc	a0,0x1
    c00002bc:	a6850513          	addi	a0,a0,-1432 # c0000d20 <etext+0x3c4>
    c00002c0:	db3ff0ef          	jal	ra,c0000072 <cprintf>
    c00002c4:	482c                	lw	a1,80(s0)
    c00002c6:	00001517          	auipc	a0,0x1
    c00002ca:	a7250513          	addi	a0,a0,-1422 # c0000d38 <etext+0x3dc>
    c00002ce:	da5ff0ef          	jal	ra,c0000072 <cprintf>
    c00002d2:	486c                	lw	a1,84(s0)
    c00002d4:	00001517          	auipc	a0,0x1
    c00002d8:	a7c50513          	addi	a0,a0,-1412 # c0000d50 <etext+0x3f4>
    c00002dc:	d97ff0ef          	jal	ra,c0000072 <cprintf>
    c00002e0:	4c2c                	lw	a1,88(s0)
    c00002e2:	00001517          	auipc	a0,0x1
    c00002e6:	a8650513          	addi	a0,a0,-1402 # c0000d68 <etext+0x40c>
    c00002ea:	d89ff0ef          	jal	ra,c0000072 <cprintf>
    c00002ee:	4c6c                	lw	a1,92(s0)
    c00002f0:	00001517          	auipc	a0,0x1
    c00002f4:	a9050513          	addi	a0,a0,-1392 # c0000d80 <etext+0x424>
    c00002f8:	d7bff0ef          	jal	ra,c0000072 <cprintf>
    c00002fc:	502c                	lw	a1,96(s0)
    c00002fe:	00001517          	auipc	a0,0x1
    c0000302:	a9a50513          	addi	a0,a0,-1382 # c0000d98 <etext+0x43c>
    c0000306:	d6dff0ef          	jal	ra,c0000072 <cprintf>
    c000030a:	506c                	lw	a1,100(s0)
    c000030c:	00001517          	auipc	a0,0x1
    c0000310:	aa450513          	addi	a0,a0,-1372 # c0000db0 <etext+0x454>
    c0000314:	d5fff0ef          	jal	ra,c0000072 <cprintf>
    c0000318:	542c                	lw	a1,104(s0)
    c000031a:	00001517          	auipc	a0,0x1
    c000031e:	aae50513          	addi	a0,a0,-1362 # c0000dc8 <etext+0x46c>
    c0000322:	d51ff0ef          	jal	ra,c0000072 <cprintf>
    c0000326:	546c                	lw	a1,108(s0)
    c0000328:	00001517          	auipc	a0,0x1
    c000032c:	ab850513          	addi	a0,a0,-1352 # c0000de0 <etext+0x484>
    c0000330:	d43ff0ef          	jal	ra,c0000072 <cprintf>
    c0000334:	582c                	lw	a1,112(s0)
    c0000336:	00001517          	auipc	a0,0x1
    c000033a:	ac250513          	addi	a0,a0,-1342 # c0000df8 <etext+0x49c>
    c000033e:	d35ff0ef          	jal	ra,c0000072 <cprintf>
    c0000342:	586c                	lw	a1,116(s0)
    c0000344:	00001517          	auipc	a0,0x1
    c0000348:	acc50513          	addi	a0,a0,-1332 # c0000e10 <etext+0x4b4>
    c000034c:	d27ff0ef          	jal	ra,c0000072 <cprintf>
    c0000350:	5c2c                	lw	a1,120(s0)
    c0000352:	00001517          	auipc	a0,0x1
    c0000356:	ad650513          	addi	a0,a0,-1322 # c0000e28 <etext+0x4cc>
    c000035a:	d19ff0ef          	jal	ra,c0000072 <cprintf>
    c000035e:	5c6c                	lw	a1,124(s0)
    c0000360:	6402                	ld	s0,0(sp)
    c0000362:	60a2                	ld	ra,8(sp)
    c0000364:	00001517          	auipc	a0,0x1
    c0000368:	adc50513          	addi	a0,a0,-1316 # c0000e40 <etext+0x4e4>
    c000036c:	0141                	addi	sp,sp,16
    c000036e:	b311                	j	c0000072 <cprintf>

00000000c0000370 <print_trapframe>:
    c0000370:	1141                	addi	sp,sp,-16
    c0000372:	e022                	sd	s0,0(sp)
    c0000374:	85aa                	mv	a1,a0
    c0000376:	842a                	mv	s0,a0
    c0000378:	00001517          	auipc	a0,0x1
    c000037c:	ae050513          	addi	a0,a0,-1312 # c0000e58 <etext+0x4fc>
    c0000380:	e406                	sd	ra,8(sp)
    c0000382:	cf1ff0ef          	jal	ra,c0000072 <cprintf>
    c0000386:	8522                	mv	a0,s0
    c0000388:	e1dff0ef          	jal	ra,c00001a4 <print_regs>
    c000038c:	08042583          	lw	a1,128(s0)
    c0000390:	00001517          	auipc	a0,0x1
    c0000394:	ae050513          	addi	a0,a0,-1312 # c0000e70 <etext+0x514>
    c0000398:	cdbff0ef          	jal	ra,c0000072 <cprintf>
    c000039c:	08442583          	lw	a1,132(s0)
    c00003a0:	00001517          	auipc	a0,0x1
    c00003a4:	ae850513          	addi	a0,a0,-1304 # c0000e88 <etext+0x52c>
    c00003a8:	ccbff0ef          	jal	ra,c0000072 <cprintf>
    c00003ac:	08842583          	lw	a1,136(s0)
    c00003b0:	00001517          	auipc	a0,0x1
    c00003b4:	af050513          	addi	a0,a0,-1296 # c0000ea0 <etext+0x544>
    c00003b8:	cbbff0ef          	jal	ra,c0000072 <cprintf>
    c00003bc:	08c42583          	lw	a1,140(s0)
    c00003c0:	6402                	ld	s0,0(sp)
    c00003c2:	60a2                	ld	ra,8(sp)
    c00003c4:	00001517          	auipc	a0,0x1
    c00003c8:	af450513          	addi	a0,a0,-1292 # c0000eb8 <etext+0x55c>
    c00003cc:	0141                	addi	sp,sp,16
    c00003ce:	b155                	j	c0000072 <cprintf>

00000000c00003d0 <interrupt_handler>:
    c00003d0:	08c52783          	lw	a5,140(a0)
    c00003d4:	472d                	li	a4,11
    c00003d6:	1786                	slli	a5,a5,0x21
    c00003d8:	9385                	srli	a5,a5,0x21
    c00003da:	06f76a63          	bltu	a4,a5,c000044e <interrupt_handler+0x7e>
    c00003de:	00000717          	auipc	a4,0x0
    c00003e2:	69670713          	addi	a4,a4,1686 # c0000a74 <etext+0x118>
    c00003e6:	078a                	slli	a5,a5,0x2
    c00003e8:	97ba                	add	a5,a5,a4
    c00003ea:	439c                	lw	a5,0(a5)
    c00003ec:	97ba                	add	a5,a5,a4
    c00003ee:	8782                	jr	a5
    c00003f0:	00000517          	auipc	a0,0x0
    c00003f4:	71850513          	addi	a0,a0,1816 # c0000b08 <etext+0x1ac>
    c00003f8:	b9ad                	j	c0000072 <cprintf>
    c00003fa:	00000517          	auipc	a0,0x0
    c00003fe:	6ee50513          	addi	a0,a0,1774 # c0000ae8 <etext+0x18c>
    c0000402:	b985                	j	c0000072 <cprintf>
    c0000404:	00000517          	auipc	a0,0x0
    c0000408:	6a450513          	addi	a0,a0,1700 # c0000aa8 <etext+0x14c>
    c000040c:	b19d                	j	c0000072 <cprintf>
    c000040e:	00000517          	auipc	a0,0x0
    c0000412:	6ba50513          	addi	a0,a0,1722 # c0000ac8 <etext+0x16c>
    c0000416:	b9b1                	j	c0000072 <cprintf>
    c0000418:	00000517          	auipc	a0,0x0
    c000041c:	72050513          	addi	a0,a0,1824 # c0000b38 <etext+0x1dc>
    c0000420:	b989                	j	c0000072 <cprintf>
    c0000422:	1141                	addi	sp,sp,-16
    c0000424:	e406                	sd	ra,8(sp)
    c0000426:	d47ff0ef          	jal	ra,c000016c <clock_set_next_event>
    c000042a:	00004797          	auipc	a5,0x4
    c000042e:	bde78793          	addi	a5,a5,-1058 # c0004008 <ticks>
    c0000432:	439c                	lw	a5,0(a5)
    c0000434:	06400713          	li	a4,100
    c0000438:	2785                	addiw	a5,a5,1
    c000043a:	02e7f73b          	remuw	a4,a5,a4
    c000043e:	00004697          	auipc	a3,0x4
    c0000442:	bcf6a523          	sw	a5,-1078(a3) # c0004008 <ticks>
    c0000446:	c709                	beqz	a4,c0000450 <interrupt_handler+0x80>
    c0000448:	60a2                	ld	ra,8(sp)
    c000044a:	0141                	addi	sp,sp,16
    c000044c:	8082                	ret
    c000044e:	b70d                	j	c0000370 <print_trapframe>
    c0000450:	60a2                	ld	ra,8(sp)
    c0000452:	06400593          	li	a1,100
    c0000456:	00000517          	auipc	a0,0x0
    c000045a:	6d250513          	addi	a0,a0,1746 # c0000b28 <etext+0x1cc>
    c000045e:	0141                	addi	sp,sp,16
    c0000460:	b909                	j	c0000072 <cprintf>

00000000c0000462 <trap>:
    c0000462:	08c52783          	lw	a5,140(a0)
    c0000466:	0007c763          	bltz	a5,c0000474 <trap+0x12>
    c000046a:	472d                	li	a4,11
    c000046c:	00f76363          	bltu	a4,a5,c0000472 <trap+0x10>
    c0000470:	8082                	ret
    c0000472:	bdfd                	j	c0000370 <print_trapframe>
    c0000474:	bfb1                	j	c00003d0 <interrupt_handler>

00000000c0000476 <__alltraps>:
    c0000476:	14011073          	csrw	sscratch,sp
    c000047a:	712d                	addi	sp,sp,-288
    c000047c:	e002                	sd	zero,0(sp)
    c000047e:	e406                	sd	ra,8(sp)
    c0000480:	ec0e                	sd	gp,24(sp)
    c0000482:	f012                	sd	tp,32(sp)
    c0000484:	f416                	sd	t0,40(sp)
    c0000486:	f81a                	sd	t1,48(sp)
    c0000488:	fc1e                	sd	t2,56(sp)
    c000048a:	e0a2                	sd	s0,64(sp)
    c000048c:	e4a6                	sd	s1,72(sp)
    c000048e:	e8aa                	sd	a0,80(sp)
    c0000490:	ecae                	sd	a1,88(sp)
    c0000492:	f0b2                	sd	a2,96(sp)
    c0000494:	f4b6                	sd	a3,104(sp)
    c0000496:	f8ba                	sd	a4,112(sp)
    c0000498:	fcbe                	sd	a5,120(sp)
    c000049a:	e142                	sd	a6,128(sp)
    c000049c:	e546                	sd	a7,136(sp)
    c000049e:	e94a                	sd	s2,144(sp)
    c00004a0:	ed4e                	sd	s3,152(sp)
    c00004a2:	f152                	sd	s4,160(sp)
    c00004a4:	f556                	sd	s5,168(sp)
    c00004a6:	f95a                	sd	s6,176(sp)
    c00004a8:	fd5e                	sd	s7,184(sp)
    c00004aa:	e1e2                	sd	s8,192(sp)
    c00004ac:	e5e6                	sd	s9,200(sp)
    c00004ae:	e9ea                	sd	s10,208(sp)
    c00004b0:	edee                	sd	s11,216(sp)
    c00004b2:	f1f2                	sd	t3,224(sp)
    c00004b4:	f5f6                	sd	t4,232(sp)
    c00004b6:	f9fa                	sd	t5,240(sp)
    c00004b8:	fdfe                	sd	t6,248(sp)
    c00004ba:	14001473          	csrrw	s0,sscratch,zero
    c00004be:	100024f3          	csrr	s1,sstatus
    c00004c2:	14102973          	csrr	s2,sepc
    c00004c6:	143029f3          	csrr	s3,stval
    c00004ca:	14202a73          	csrr	s4,scause
    c00004ce:	e822                	sd	s0,16(sp)
    c00004d0:	e226                	sd	s1,256(sp)
    c00004d2:	e64a                	sd	s2,264(sp)
    c00004d4:	ea4e                	sd	s3,272(sp)
    c00004d6:	ee52                	sd	s4,280(sp)
    c00004d8:	850a                	mv	a0,sp
    c00004da:	f89ff0ef          	jal	ra,c0000462 <trap>

00000000c00004de <__trapret>:
    c00004de:	6492                	ld	s1,256(sp)
    c00004e0:	6932                	ld	s2,264(sp)
    c00004e2:	10049073          	csrw	sstatus,s1
    c00004e6:	14191073          	csrw	sepc,s2
    c00004ea:	60a2                	ld	ra,8(sp)
    c00004ec:	61e2                	ld	gp,24(sp)
    c00004ee:	7202                	ld	tp,32(sp)
    c00004f0:	72a2                	ld	t0,40(sp)
    c00004f2:	7342                	ld	t1,48(sp)
    c00004f4:	73e2                	ld	t2,56(sp)
    c00004f6:	6406                	ld	s0,64(sp)
    c00004f8:	64a6                	ld	s1,72(sp)
    c00004fa:	6546                	ld	a0,80(sp)
    c00004fc:	65e6                	ld	a1,88(sp)
    c00004fe:	7606                	ld	a2,96(sp)
    c0000500:	76a6                	ld	a3,104(sp)
    c0000502:	7746                	ld	a4,112(sp)
    c0000504:	77e6                	ld	a5,120(sp)
    c0000506:	680a                	ld	a6,128(sp)
    c0000508:	68aa                	ld	a7,136(sp)
    c000050a:	694a                	ld	s2,144(sp)
    c000050c:	69ea                	ld	s3,152(sp)
    c000050e:	7a0a                	ld	s4,160(sp)
    c0000510:	7aaa                	ld	s5,168(sp)
    c0000512:	7b4a                	ld	s6,176(sp)
    c0000514:	7bea                	ld	s7,184(sp)
    c0000516:	6c0e                	ld	s8,192(sp)
    c0000518:	6cae                	ld	s9,200(sp)
    c000051a:	6d4e                	ld	s10,208(sp)
    c000051c:	6dee                	ld	s11,216(sp)
    c000051e:	7e0e                	ld	t3,224(sp)
    c0000520:	7eae                	ld	t4,232(sp)
    c0000522:	7f4e                	ld	t5,240(sp)
    c0000524:	7fee                	ld	t6,248(sp)
    c0000526:	6142                	ld	sp,16(sp)
    c0000528:	10200073          	sret

00000000c000052c <pmm_init>:
    c000052c:	8082                	ret

00000000c000052e <strnlen>:
    c000052e:	c18d                	beqz	a1,c0000550 <strnlen+0x22>
    c0000530:	00054703          	lbu	a4,0(a0)
    c0000534:	00150793          	addi	a5,a0,1
    c0000538:	4501                	li	a0,0
    c000053a:	e709                	bnez	a4,c0000544 <strnlen+0x16>
    c000053c:	a801                	j	c000054c <strnlen+0x1e>
    c000053e:	fff7c703          	lbu	a4,-1(a5)
    c0000542:	c711                	beqz	a4,c000054e <strnlen+0x20>
    c0000544:	2505                	addiw	a0,a0,1
    c0000546:	0785                	addi	a5,a5,1
    c0000548:	fea59be3          	bne	a1,a0,c000053e <strnlen+0x10>
    c000054c:	8082                	ret
    c000054e:	8082                	ret
    c0000550:	4501                	li	a0,0
    c0000552:	8082                	ret

00000000c0000554 <memset>:
    c0000554:	fff6071b          	addiw	a4,a2,-1
    c0000558:	ca19                	beqz	a2,c000056e <memset+0x1a>
    c000055a:	1702                	slli	a4,a4,0x20
    c000055c:	9301                	srli	a4,a4,0x20
    c000055e:	0705                	addi	a4,a4,1
    c0000560:	972a                	add	a4,a4,a0
    c0000562:	87aa                	mv	a5,a0
    c0000564:	0785                	addi	a5,a5,1
    c0000566:	feb78fa3          	sb	a1,-1(a5)
    c000056a:	fee79de3          	bne	a5,a4,c0000564 <memset+0x10>
    c000056e:	8082                	ret

00000000c0000570 <printnum>:
    c0000570:	02069813          	slli	a6,a3,0x20
    c0000574:	7179                	addi	sp,sp,-48
    c0000576:	02085813          	srli	a6,a6,0x20
    c000057a:	e052                	sd	s4,0(sp)
    c000057c:	03067a33          	remu	s4,a2,a6
    c0000580:	f022                	sd	s0,32(sp)
    c0000582:	ec26                	sd	s1,24(sp)
    c0000584:	e84a                	sd	s2,16(sp)
    c0000586:	f406                	sd	ra,40(sp)
    c0000588:	e44e                	sd	s3,8(sp)
    c000058a:	84aa                	mv	s1,a0
    c000058c:	892e                	mv	s2,a1
    c000058e:	fff7041b          	addiw	s0,a4,-1
    c0000592:	2a01                	sext.w	s4,s4
    c0000594:	03067e63          	bgeu	a2,a6,c00005d0 <printnum+0x60>
    c0000598:	89be                	mv	s3,a5
    c000059a:	00805763          	blez	s0,c00005a8 <printnum+0x38>
    c000059e:	347d                	addiw	s0,s0,-1
    c00005a0:	85ca                	mv	a1,s2
    c00005a2:	854e                	mv	a0,s3
    c00005a4:	9482                	jalr	s1
    c00005a6:	fc65                	bnez	s0,c000059e <printnum+0x2e>
    c00005a8:	1a02                	slli	s4,s4,0x20
    c00005aa:	020a5a13          	srli	s4,s4,0x20
    c00005ae:	00001797          	auipc	a5,0x1
    c00005b2:	ab278793          	addi	a5,a5,-1358 # c0001060 <error_string+0x38>
    c00005b6:	9a3e                	add	s4,s4,a5
    c00005b8:	7402                	ld	s0,32(sp)
    c00005ba:	000a4503          	lbu	a0,0(s4)
    c00005be:	70a2                	ld	ra,40(sp)
    c00005c0:	69a2                	ld	s3,8(sp)
    c00005c2:	6a02                	ld	s4,0(sp)
    c00005c4:	85ca                	mv	a1,s2
    c00005c6:	8326                	mv	t1,s1
    c00005c8:	6942                	ld	s2,16(sp)
    c00005ca:	64e2                	ld	s1,24(sp)
    c00005cc:	6145                	addi	sp,sp,48
    c00005ce:	8302                	jr	t1
    c00005d0:	03065633          	divu	a2,a2,a6
    c00005d4:	8722                	mv	a4,s0
    c00005d6:	f9bff0ef          	jal	ra,c0000570 <printnum>
    c00005da:	b7f9                	j	c00005a8 <printnum+0x38>

00000000c00005dc <vprintfmt>:
    c00005dc:	7119                	addi	sp,sp,-128
    c00005de:	f4a6                	sd	s1,104(sp)
    c00005e0:	f0ca                	sd	s2,96(sp)
    c00005e2:	e8d2                	sd	s4,80(sp)
    c00005e4:	e4d6                	sd	s5,72(sp)
    c00005e6:	e0da                	sd	s6,64(sp)
    c00005e8:	fc5e                	sd	s7,56(sp)
    c00005ea:	f862                	sd	s8,48(sp)
    c00005ec:	f06a                	sd	s10,32(sp)
    c00005ee:	fc86                	sd	ra,120(sp)
    c00005f0:	f8a2                	sd	s0,112(sp)
    c00005f2:	ecce                	sd	s3,88(sp)
    c00005f4:	f466                	sd	s9,40(sp)
    c00005f6:	ec6e                	sd	s11,24(sp)
    c00005f8:	892a                	mv	s2,a0
    c00005fa:	84ae                	mv	s1,a1
    c00005fc:	8d32                	mv	s10,a2
    c00005fe:	8ab6                	mv	s5,a3
    c0000600:	5b7d                	li	s6,-1
    c0000602:	00001a17          	auipc	s4,0x1
    c0000606:	8caa0a13          	addi	s4,s4,-1846 # c0000ecc <etext+0x570>
    c000060a:	05e00b93          	li	s7,94
    c000060e:	00001c17          	auipc	s8,0x1
    c0000612:	a1ac0c13          	addi	s8,s8,-1510 # c0001028 <error_string>
    c0000616:	000d4503          	lbu	a0,0(s10)
    c000061a:	02500793          	li	a5,37
    c000061e:	001d0413          	addi	s0,s10,1
    c0000622:	00f50e63          	beq	a0,a5,c000063e <vprintfmt+0x62>
    c0000626:	c521                	beqz	a0,c000066e <vprintfmt+0x92>
    c0000628:	02500993          	li	s3,37
    c000062c:	a011                	j	c0000630 <vprintfmt+0x54>
    c000062e:	c121                	beqz	a0,c000066e <vprintfmt+0x92>
    c0000630:	85a6                	mv	a1,s1
    c0000632:	0405                	addi	s0,s0,1
    c0000634:	9902                	jalr	s2
    c0000636:	fff44503          	lbu	a0,-1(s0)
    c000063a:	ff351ae3          	bne	a0,s3,c000062e <vprintfmt+0x52>
    c000063e:	00044603          	lbu	a2,0(s0)
    c0000642:	02000793          	li	a5,32
    c0000646:	4981                	li	s3,0
    c0000648:	4801                	li	a6,0
    c000064a:	5cfd                	li	s9,-1
    c000064c:	5dfd                	li	s11,-1
    c000064e:	05500593          	li	a1,85
    c0000652:	4525                	li	a0,9
    c0000654:	fdd6069b          	addiw	a3,a2,-35
    c0000658:	0ff6f693          	andi	a3,a3,255
    c000065c:	00140d13          	addi	s10,s0,1
    c0000660:	1ed5ef63          	bltu	a1,a3,c000085e <vprintfmt+0x282>
    c0000664:	068a                	slli	a3,a3,0x2
    c0000666:	96d2                	add	a3,a3,s4
    c0000668:	4294                	lw	a3,0(a3)
    c000066a:	96d2                	add	a3,a3,s4
    c000066c:	8682                	jr	a3
    c000066e:	70e6                	ld	ra,120(sp)
    c0000670:	7446                	ld	s0,112(sp)
    c0000672:	74a6                	ld	s1,104(sp)
    c0000674:	7906                	ld	s2,96(sp)
    c0000676:	69e6                	ld	s3,88(sp)
    c0000678:	6a46                	ld	s4,80(sp)
    c000067a:	6aa6                	ld	s5,72(sp)
    c000067c:	6b06                	ld	s6,64(sp)
    c000067e:	7be2                	ld	s7,56(sp)
    c0000680:	7c42                	ld	s8,48(sp)
    c0000682:	7ca2                	ld	s9,40(sp)
    c0000684:	7d02                	ld	s10,32(sp)
    c0000686:	6de2                	ld	s11,24(sp)
    c0000688:	6109                	addi	sp,sp,128
    c000068a:	8082                	ret
    c000068c:	87b2                	mv	a5,a2
    c000068e:	00144603          	lbu	a2,1(s0)
    c0000692:	846a                	mv	s0,s10
    c0000694:	b7c1                	j	c0000654 <vprintfmt+0x78>
    c0000696:	000aac83          	lw	s9,0(s5)
    c000069a:	00144603          	lbu	a2,1(s0)
    c000069e:	0aa1                	addi	s5,s5,8
    c00006a0:	846a                	mv	s0,s10
    c00006a2:	fa0dd9e3          	bgez	s11,c0000654 <vprintfmt+0x78>
    c00006a6:	8de6                	mv	s11,s9
    c00006a8:	5cfd                	li	s9,-1
    c00006aa:	b76d                	j	c0000654 <vprintfmt+0x78>
    c00006ac:	fffdc693          	not	a3,s11
    c00006b0:	96fd                	srai	a3,a3,0x3f
    c00006b2:	00ddfdb3          	and	s11,s11,a3
    c00006b6:	00144603          	lbu	a2,1(s0)
    c00006ba:	2d81                	sext.w	s11,s11
    c00006bc:	846a                	mv	s0,s10
    c00006be:	bf59                	j	c0000654 <vprintfmt+0x78>
    c00006c0:	4705                	li	a4,1
    c00006c2:	008a8593          	addi	a1,s5,8
    c00006c6:	01074463          	blt	a4,a6,c00006ce <vprintfmt+0xf2>
    c00006ca:	22080863          	beqz	a6,c00008fa <vprintfmt+0x31e>
    c00006ce:	000ab603          	ld	a2,0(s5)
    c00006d2:	46c1                	li	a3,16
    c00006d4:	8aae                	mv	s5,a1
    c00006d6:	a291                	j	c000081a <vprintfmt+0x23e>
    c00006d8:	fd060c9b          	addiw	s9,a2,-48
    c00006dc:	00144603          	lbu	a2,1(s0)
    c00006e0:	846a                	mv	s0,s10
    c00006e2:	fd06069b          	addiw	a3,a2,-48
    c00006e6:	0006089b          	sext.w	a7,a2
    c00006ea:	fad56ce3          	bltu	a0,a3,c00006a2 <vprintfmt+0xc6>
    c00006ee:	0405                	addi	s0,s0,1
    c00006f0:	002c969b          	slliw	a3,s9,0x2
    c00006f4:	00044603          	lbu	a2,0(s0)
    c00006f8:	0196873b          	addw	a4,a3,s9
    c00006fc:	0017171b          	slliw	a4,a4,0x1
    c0000700:	0117073b          	addw	a4,a4,a7
    c0000704:	fd06069b          	addiw	a3,a2,-48
    c0000708:	fd070c9b          	addiw	s9,a4,-48
    c000070c:	0006089b          	sext.w	a7,a2
    c0000710:	fcd57fe3          	bgeu	a0,a3,c00006ee <vprintfmt+0x112>
    c0000714:	b779                	j	c00006a2 <vprintfmt+0xc6>
    c0000716:	000aa503          	lw	a0,0(s5)
    c000071a:	85a6                	mv	a1,s1
    c000071c:	0aa1                	addi	s5,s5,8
    c000071e:	9902                	jalr	s2
    c0000720:	bddd                	j	c0000616 <vprintfmt+0x3a>
    c0000722:	4705                	li	a4,1
    c0000724:	008a8993          	addi	s3,s5,8
    c0000728:	01074463          	blt	a4,a6,c0000730 <vprintfmt+0x154>
    c000072c:	1c080463          	beqz	a6,c00008f4 <vprintfmt+0x318>
    c0000730:	000ab403          	ld	s0,0(s5)
    c0000734:	1c044a63          	bltz	s0,c0000908 <vprintfmt+0x32c>
    c0000738:	8622                	mv	a2,s0
    c000073a:	8ace                	mv	s5,s3
    c000073c:	46a9                	li	a3,10
    c000073e:	a8f1                	j	c000081a <vprintfmt+0x23e>
    c0000740:	000aa783          	lw	a5,0(s5)
    c0000744:	4719                	li	a4,6
    c0000746:	0aa1                	addi	s5,s5,8
    c0000748:	41f7d69b          	sraiw	a3,a5,0x1f
    c000074c:	8fb5                	xor	a5,a5,a3
    c000074e:	40d786bb          	subw	a3,a5,a3
    c0000752:	12d74963          	blt	a4,a3,c0000884 <vprintfmt+0x2a8>
    c0000756:	00369793          	slli	a5,a3,0x3
    c000075a:	97e2                	add	a5,a5,s8
    c000075c:	639c                	ld	a5,0(a5)
    c000075e:	12078363          	beqz	a5,c0000884 <vprintfmt+0x2a8>
    c0000762:	86be                	mv	a3,a5
    c0000764:	00001617          	auipc	a2,0x1
    c0000768:	9ac60613          	addi	a2,a2,-1620 # c0001110 <error_string+0xe8>
    c000076c:	85a6                	mv	a1,s1
    c000076e:	854a                	mv	a0,s2
    c0000770:	1cc000ef          	jal	ra,c000093c <printfmt>
    c0000774:	b54d                	j	c0000616 <vprintfmt+0x3a>
    c0000776:	000ab603          	ld	a2,0(s5)
    c000077a:	0aa1                	addi	s5,s5,8
    c000077c:	1a060163          	beqz	a2,c000091e <vprintfmt+0x342>
    c0000780:	00160413          	addi	s0,a2,1
    c0000784:	15b05763          	blez	s11,c00008d2 <vprintfmt+0x2f6>
    c0000788:	02d00593          	li	a1,45
    c000078c:	10b79d63          	bne	a5,a1,c00008a6 <vprintfmt+0x2ca>
    c0000790:	00064783          	lbu	a5,0(a2)
    c0000794:	0007851b          	sext.w	a0,a5
    c0000798:	c905                	beqz	a0,c00007c8 <vprintfmt+0x1ec>
    c000079a:	000cc563          	bltz	s9,c00007a4 <vprintfmt+0x1c8>
    c000079e:	3cfd                	addiw	s9,s9,-1
    c00007a0:	036c8263          	beq	s9,s6,c00007c4 <vprintfmt+0x1e8>
    c00007a4:	85a6                	mv	a1,s1
    c00007a6:	14098f63          	beqz	s3,c0000904 <vprintfmt+0x328>
    c00007aa:	3781                	addiw	a5,a5,-32
    c00007ac:	14fbfc63          	bgeu	s7,a5,c0000904 <vprintfmt+0x328>
    c00007b0:	03f00513          	li	a0,63
    c00007b4:	9902                	jalr	s2
    c00007b6:	0405                	addi	s0,s0,1
    c00007b8:	fff44783          	lbu	a5,-1(s0)
    c00007bc:	3dfd                	addiw	s11,s11,-1
    c00007be:	0007851b          	sext.w	a0,a5
    c00007c2:	fd61                	bnez	a0,c000079a <vprintfmt+0x1be>
    c00007c4:	e5b059e3          	blez	s11,c0000616 <vprintfmt+0x3a>
    c00007c8:	3dfd                	addiw	s11,s11,-1
    c00007ca:	85a6                	mv	a1,s1
    c00007cc:	02000513          	li	a0,32
    c00007d0:	9902                	jalr	s2
    c00007d2:	e40d82e3          	beqz	s11,c0000616 <vprintfmt+0x3a>
    c00007d6:	3dfd                	addiw	s11,s11,-1
    c00007d8:	85a6                	mv	a1,s1
    c00007da:	02000513          	li	a0,32
    c00007de:	9902                	jalr	s2
    c00007e0:	fe0d94e3          	bnez	s11,c00007c8 <vprintfmt+0x1ec>
    c00007e4:	bd0d                	j	c0000616 <vprintfmt+0x3a>
    c00007e6:	4705                	li	a4,1
    c00007e8:	008a8593          	addi	a1,s5,8
    c00007ec:	01074463          	blt	a4,a6,c00007f4 <vprintfmt+0x218>
    c00007f0:	0e080863          	beqz	a6,c00008e0 <vprintfmt+0x304>
    c00007f4:	000ab603          	ld	a2,0(s5)
    c00007f8:	46a1                	li	a3,8
    c00007fa:	8aae                	mv	s5,a1
    c00007fc:	a839                	j	c000081a <vprintfmt+0x23e>
    c00007fe:	03000513          	li	a0,48
    c0000802:	85a6                	mv	a1,s1
    c0000804:	e03e                	sd	a5,0(sp)
    c0000806:	9902                	jalr	s2
    c0000808:	85a6                	mv	a1,s1
    c000080a:	07800513          	li	a0,120
    c000080e:	9902                	jalr	s2
    c0000810:	0aa1                	addi	s5,s5,8
    c0000812:	ff8ab603          	ld	a2,-8(s5)
    c0000816:	6782                	ld	a5,0(sp)
    c0000818:	46c1                	li	a3,16
    c000081a:	2781                	sext.w	a5,a5
    c000081c:	876e                	mv	a4,s11
    c000081e:	85a6                	mv	a1,s1
    c0000820:	854a                	mv	a0,s2
    c0000822:	d4fff0ef          	jal	ra,c0000570 <printnum>
    c0000826:	bbc5                	j	c0000616 <vprintfmt+0x3a>
    c0000828:	00144603          	lbu	a2,1(s0)
    c000082c:	2805                	addiw	a6,a6,1
    c000082e:	846a                	mv	s0,s10
    c0000830:	b515                	j	c0000654 <vprintfmt+0x78>
    c0000832:	00144603          	lbu	a2,1(s0)
    c0000836:	4985                	li	s3,1
    c0000838:	846a                	mv	s0,s10
    c000083a:	bd29                	j	c0000654 <vprintfmt+0x78>
    c000083c:	85a6                	mv	a1,s1
    c000083e:	02500513          	li	a0,37
    c0000842:	9902                	jalr	s2
    c0000844:	bbc9                	j	c0000616 <vprintfmt+0x3a>
    c0000846:	4705                	li	a4,1
    c0000848:	008a8593          	addi	a1,s5,8
    c000084c:	01074463          	blt	a4,a6,c0000854 <vprintfmt+0x278>
    c0000850:	08080d63          	beqz	a6,c00008ea <vprintfmt+0x30e>
    c0000854:	000ab603          	ld	a2,0(s5)
    c0000858:	46a9                	li	a3,10
    c000085a:	8aae                	mv	s5,a1
    c000085c:	bf7d                	j	c000081a <vprintfmt+0x23e>
    c000085e:	85a6                	mv	a1,s1
    c0000860:	02500513          	li	a0,37
    c0000864:	9902                	jalr	s2
    c0000866:	fff44703          	lbu	a4,-1(s0)
    c000086a:	02500793          	li	a5,37
    c000086e:	8d22                	mv	s10,s0
    c0000870:	daf703e3          	beq	a4,a5,c0000616 <vprintfmt+0x3a>
    c0000874:	02500713          	li	a4,37
    c0000878:	1d7d                	addi	s10,s10,-1
    c000087a:	fffd4783          	lbu	a5,-1(s10)
    c000087e:	fee79de3          	bne	a5,a4,c0000878 <vprintfmt+0x29c>
    c0000882:	bb51                	j	c0000616 <vprintfmt+0x3a>
    c0000884:	00001617          	auipc	a2,0x1
    c0000888:	87c60613          	addi	a2,a2,-1924 # c0001100 <error_string+0xd8>
    c000088c:	85a6                	mv	a1,s1
    c000088e:	854a                	mv	a0,s2
    c0000890:	0ac000ef          	jal	ra,c000093c <printfmt>
    c0000894:	b349                	j	c0000616 <vprintfmt+0x3a>
    c0000896:	00001617          	auipc	a2,0x1
    c000089a:	86260613          	addi	a2,a2,-1950 # c00010f8 <error_string+0xd0>
    c000089e:	00001417          	auipc	s0,0x1
    c00008a2:	85b40413          	addi	s0,s0,-1957 # c00010f9 <error_string+0xd1>
    c00008a6:	8532                	mv	a0,a2
    c00008a8:	85e6                	mv	a1,s9
    c00008aa:	e032                	sd	a2,0(sp)
    c00008ac:	e43e                	sd	a5,8(sp)
    c00008ae:	c81ff0ef          	jal	ra,c000052e <strnlen>
    c00008b2:	40ad8dbb          	subw	s11,s11,a0
    c00008b6:	6602                	ld	a2,0(sp)
    c00008b8:	01b05d63          	blez	s11,c00008d2 <vprintfmt+0x2f6>
    c00008bc:	67a2                	ld	a5,8(sp)
    c00008be:	2781                	sext.w	a5,a5
    c00008c0:	e43e                	sd	a5,8(sp)
    c00008c2:	6522                	ld	a0,8(sp)
    c00008c4:	85a6                	mv	a1,s1
    c00008c6:	e032                	sd	a2,0(sp)
    c00008c8:	3dfd                	addiw	s11,s11,-1
    c00008ca:	9902                	jalr	s2
    c00008cc:	6602                	ld	a2,0(sp)
    c00008ce:	fe0d9ae3          	bnez	s11,c00008c2 <vprintfmt+0x2e6>
    c00008d2:	00064783          	lbu	a5,0(a2)
    c00008d6:	0007851b          	sext.w	a0,a5
    c00008da:	ec0510e3          	bnez	a0,c000079a <vprintfmt+0x1be>
    c00008de:	bb25                	j	c0000616 <vprintfmt+0x3a>
    c00008e0:	000ae603          	lwu	a2,0(s5)
    c00008e4:	46a1                	li	a3,8
    c00008e6:	8aae                	mv	s5,a1
    c00008e8:	bf0d                	j	c000081a <vprintfmt+0x23e>
    c00008ea:	000ae603          	lwu	a2,0(s5)
    c00008ee:	46a9                	li	a3,10
    c00008f0:	8aae                	mv	s5,a1
    c00008f2:	b725                	j	c000081a <vprintfmt+0x23e>
    c00008f4:	000aa403          	lw	s0,0(s5)
    c00008f8:	bd35                	j	c0000734 <vprintfmt+0x158>
    c00008fa:	000ae603          	lwu	a2,0(s5)
    c00008fe:	46c1                	li	a3,16
    c0000900:	8aae                	mv	s5,a1
    c0000902:	bf21                	j	c000081a <vprintfmt+0x23e>
    c0000904:	9902                	jalr	s2
    c0000906:	bd45                	j	c00007b6 <vprintfmt+0x1da>
    c0000908:	85a6                	mv	a1,s1
    c000090a:	02d00513          	li	a0,45
    c000090e:	e03e                	sd	a5,0(sp)
    c0000910:	9902                	jalr	s2
    c0000912:	8ace                	mv	s5,s3
    c0000914:	40800633          	neg	a2,s0
    c0000918:	46a9                	li	a3,10
    c000091a:	6782                	ld	a5,0(sp)
    c000091c:	bdfd                	j	c000081a <vprintfmt+0x23e>
    c000091e:	01b05663          	blez	s11,c000092a <vprintfmt+0x34e>
    c0000922:	02d00693          	li	a3,45
    c0000926:	f6d798e3          	bne	a5,a3,c0000896 <vprintfmt+0x2ba>
    c000092a:	00000417          	auipc	s0,0x0
    c000092e:	7cf40413          	addi	s0,s0,1999 # c00010f9 <error_string+0xd1>
    c0000932:	02800513          	li	a0,40
    c0000936:	02800793          	li	a5,40
    c000093a:	b585                	j	c000079a <vprintfmt+0x1be>

00000000c000093c <printfmt>:
    c000093c:	715d                	addi	sp,sp,-80
    c000093e:	02810313          	addi	t1,sp,40
    c0000942:	f436                	sd	a3,40(sp)
    c0000944:	869a                	mv	a3,t1
    c0000946:	ec06                	sd	ra,24(sp)
    c0000948:	f83a                	sd	a4,48(sp)
    c000094a:	fc3e                	sd	a5,56(sp)
    c000094c:	e0c2                	sd	a6,64(sp)
    c000094e:	e4c6                	sd	a7,72(sp)
    c0000950:	e41a                	sd	t1,8(sp)
    c0000952:	c8bff0ef          	jal	ra,c00005dc <vprintfmt>
    c0000956:	60e2                	ld	ra,24(sp)
    c0000958:	6161                	addi	sp,sp,80
    c000095a:	8082                	ret
