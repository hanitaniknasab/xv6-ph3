
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc f0 73 11 80       	mov    $0x801173f0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 d0 30 10 80       	mov    $0x801030d0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 c0 7d 10 80       	push   $0x80107dc0
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 75 4f 00 00       	call   80104fd0 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 c7 7d 10 80       	push   $0x80107dc7
80100097:	50                   	push   %eax
80100098:	e8 03 4e 00 00       	call   80104ea0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 b7 50 00 00       	call   801051a0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 d9 4f 00 00       	call   80105140 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 6e 4d 00 00       	call   80104ee0 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 bf 21 00 00       	call   80102350 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 ce 7d 10 80       	push   $0x80107dce
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 bd 4d 00 00       	call   80104f80 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 77 21 00 00       	jmp    80102350 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 df 7d 10 80       	push   $0x80107ddf
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 7c 4d 00 00       	call   80104f80 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 2c 4d 00 00       	call   80104f40 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 80 4f 00 00       	call   801051a0 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 cf 4e 00 00       	jmp    80105140 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 e6 7d 10 80       	push   $0x80107de6
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 37 16 00 00       	call   801018d0 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 fb 4e 00 00       	call   801051a0 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002b5:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ff 10 80       	push   $0x8010ff20
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 0e 41 00 00       	call   801043e0 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 49 37 00 00       	call   80103a30 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 45 4e 00 00       	call   80105140 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 ec 14 00 00       	call   801017f0 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ff 10 80       	push   $0x8010ff20
8010034c:	e8 ef 4d 00 00       	call   80105140 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 96 14 00 00       	call   801017f0 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 54 ff 10 80 00 	movl   $0x0,0x8010ff54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 c2 25 00 00       	call   80102960 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 ed 7d 10 80       	push   $0x80107ded
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 cc 83 10 80 	movl   $0x801083cc,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 23 4c 00 00       	call   80104ff0 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 01 7e 10 80       	push   $0x80107e01
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ff 10 80 01 	movl   $0x1,0x8010ff58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 b1 64 00 00       	call   801068d0 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 92 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100456:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045c:	74 72                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010045e:	0f b6 db             	movzbl %bl,%ebx
80100461:	8d 70 01             	lea    0x1(%eax),%esi
80100464:	80 cf 07             	or     $0x7,%bh
80100467:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010046e:	80 
  if(pos < 0 || pos > 25*80)
8010046f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100475:	0f 8f fb 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	0f 8f a9 00 00 00    	jg     80100530 <consputc.part.0+0x130>
  outb(CRTPORT+1, pos>>8);
80100487:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
80100489:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100490:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100493:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100496:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049b:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a0:	89 da                	mov    %ebx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a8:	89 f8                	mov    %edi,%eax
801004aa:	89 ca                	mov    %ecx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004b9:	89 ca                	mov    %ecx,%edx
801004bb:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004bc:	b8 20 07 00 00       	mov    $0x720,%eax
801004c1:	66 89 06             	mov    %ax,(%esi)
}
801004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c7:	5b                   	pop    %ebx
801004c8:	5e                   	pop    %esi
801004c9:	5f                   	pop    %edi
801004ca:	5d                   	pop    %ebp
801004cb:	c3                   	ret    
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0) --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 98                	jne    8010046f <consputc.part.0+0x6f>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b2                	jmp    80100496 <consputc.part.0+0x96>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 6f ff ff ff       	jmp    8010046f <consputc.part.0+0x6f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 c6 63 00 00       	call   801068d0 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 ba 63 00 00       	call   801068d0 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 ae 63 00 00       	call   801068d0 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 aa 4d 00 00       	call   80105300 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 f5 4c 00 00       	call   80105260 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 05 7e 10 80       	push   $0x80107e05
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100599:	ff 75 08             	push   0x8(%ebp)
{
8010059c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010059f:	e8 2c 13 00 00       	call   801018d0 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005ab:	e8 f0 4b 00 00       	call   801051a0 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i] & 0xff);
801005c3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005c6:	85 d2                	test   %edx,%edx
801005c8:	74 06                	je     801005d0 <consolewrite+0x40>
  asm volatile("cli");
801005ca:	fa                   	cli    
    for(;;)
801005cb:	eb fe                	jmp    801005cb <consolewrite+0x3b>
801005cd:	8d 76 00             	lea    0x0(%esi),%esi
801005d0:	e8 2b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005d5:	83 c3 01             	add    $0x1,%ebx
801005d8:	39 df                	cmp    %ebx,%edi
801005da:	75 e1                	jne    801005bd <consolewrite+0x2d>
  release(&cons.lock);
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 20 ff 10 80       	push   $0x8010ff20
801005e4:	e8 57 4b 00 00       	call   80105140 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 fe 11 00 00       	call   801017f0 <ilock>

  return n;
}
801005f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f5:	89 f0                	mov    %esi,%eax
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret    
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 2c             	sub    $0x2c,%esp
80100609:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010060c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010060f:	85 c9                	test   %ecx,%ecx
80100611:	74 04                	je     80100617 <printint+0x17>
80100613:	85 c0                	test   %eax,%eax
80100615:	78 6d                	js     80100684 <printint+0x84>
    x = xx;
80100617:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010061e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100620:	31 db                	xor    %ebx,%ebx
80100622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100628:	89 c8                	mov    %ecx,%eax
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	89 de                	mov    %ebx,%esi
8010062e:	89 cf                	mov    %ecx,%edi
80100630:	f7 75 d4             	divl   -0x2c(%ebp)
80100633:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100636:	0f b6 92 30 7e 10 80 	movzbl -0x7fef81d0(%edx),%edx
  }while((x /= base) != 0);
8010063d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010063f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100643:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100646:	73 e0                	jae    80100628 <printint+0x28>
  if(sign)
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	85 c9                	test   %ecx,%ecx
8010064d:	74 0c                	je     8010065b <printint+0x5b>
    buf[i++] = '-';
8010064f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100654:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100656:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010065b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065f:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100662:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100668:	85 d2                	test   %edx,%edx
8010066a:	74 04                	je     80100670 <printint+0x70>
8010066c:	fa                   	cli    
    for(;;)
8010066d:	eb fe                	jmp    8010066d <printint+0x6d>
8010066f:	90                   	nop
80100670:	e8 8b fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
80100675:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100678:	39 c3                	cmp    %eax,%ebx
8010067a:	74 0e                	je     8010068a <printint+0x8a>
    consputc(buf[i]);
8010067c:	0f be 03             	movsbl (%ebx),%eax
8010067f:	83 eb 01             	sub    $0x1,%ebx
80100682:	eb de                	jmp    80100662 <printint+0x62>
    x = -xx;
80100684:	f7 d8                	neg    %eax
80100686:	89 c1                	mov    %eax,%ecx
80100688:	eb 96                	jmp    80100620 <printint+0x20>
}
8010068a:	83 c4 2c             	add    $0x2c,%esp
8010068d:	5b                   	pop    %ebx
8010068e:	5e                   	pop    %esi
8010068f:	5f                   	pop    %edi
80100690:	5d                   	pop    %ebp
80100691:	c3                   	ret    
80100692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 54 ff 10 80       	mov    0x8010ff54,%eax
801006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 27 01 00 00    	jne    801007e0 <cprintf+0x140>
  if (fmt == 0)
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	85 f6                	test   %esi,%esi
801006be:	0f 84 ac 01 00 00    	je     80100870 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ca:	31 db                	xor    %ebx,%ebx
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 56                	je     80100726 <cprintf+0x86>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	0f 85 cf 00 00 00    	jne    801007a8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
801006d9:	83 c3 01             	add    $0x1,%ebx
801006dc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006e0:	85 d2                	test   %edx,%edx
801006e2:	74 42                	je     80100726 <cprintf+0x86>
    switch(c){
801006e4:	83 fa 70             	cmp    $0x70,%edx
801006e7:	0f 84 90 00 00 00    	je     8010077d <cprintf+0xdd>
801006ed:	7f 51                	jg     80100740 <cprintf+0xa0>
801006ef:	83 fa 25             	cmp    $0x25,%edx
801006f2:	0f 84 c0 00 00 00    	je     801007b8 <cprintf+0x118>
801006f8:	83 fa 64             	cmp    $0x64,%edx
801006fb:	0f 85 f4 00 00 00    	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100701:	8d 47 04             	lea    0x4(%edi),%eax
80100704:	b9 01 00 00 00       	mov    $0x1,%ecx
80100709:	ba 0a 00 00 00       	mov    $0xa,%edx
8010070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100711:	8b 07                	mov    (%edi),%eax
80100713:	e8 e8 fe ff ff       	call   80100600 <printint>
80100718:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071b:	83 c3 01             	add    $0x1,%ebx
8010071e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100722:	85 c0                	test   %eax,%eax
80100724:	75 aa                	jne    801006d0 <cprintf+0x30>
  if(locking)
80100726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	0f 85 22 01 00 00    	jne    80100853 <cprintf+0x1b3>
}
80100731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100734:	5b                   	pop    %ebx
80100735:	5e                   	pop    %esi
80100736:	5f                   	pop    %edi
80100737:	5d                   	pop    %ebp
80100738:	c3                   	ret    
80100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100740:	83 fa 73             	cmp    $0x73,%edx
80100743:	75 33                	jne    80100778 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100745:	8d 47 04             	lea    0x4(%edi),%eax
80100748:	8b 3f                	mov    (%edi),%edi
8010074a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010074d:	85 ff                	test   %edi,%edi
8010074f:	0f 84 e3 00 00 00    	je     80100838 <cprintf+0x198>
      for(; *s; s++)
80100755:	0f be 07             	movsbl (%edi),%eax
80100758:	84 c0                	test   %al,%al
8010075a:	0f 84 08 01 00 00    	je     80100868 <cprintf+0x1c8>
  if(panicked){
80100760:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100766:	85 d2                	test   %edx,%edx
80100768:	0f 84 b2 00 00 00    	je     80100820 <cprintf+0x180>
8010076e:	fa                   	cli    
    for(;;)
8010076f:	eb fe                	jmp    8010076f <cprintf+0xcf>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100778:	83 fa 78             	cmp    $0x78,%edx
8010077b:	75 78                	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 16, 0);
8010077d:	8d 47 04             	lea    0x4(%edi),%eax
80100780:	31 c9                	xor    %ecx,%ecx
80100782:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100787:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010078d:	8b 07                	mov    (%edi),%eax
8010078f:	e8 6c fe ff ff       	call   80100600 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100794:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
80100798:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010079b:	85 c0                	test   %eax,%eax
8010079d:	0f 85 2d ff ff ff    	jne    801006d0 <cprintf+0x30>
801007a3:	eb 81                	jmp    80100726 <cprintf+0x86>
801007a5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007a8:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
801007bd:	85 c0                	test   %eax,%eax
801007bf:	75 6c                	jne    8010082d <cprintf+0x18d>
801007c1:	b8 25 00 00 00       	mov    $0x25,%eax
801007c6:	e8 35 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007cb:	83 c3 01             	add    $0x1,%ebx
801007ce:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007d2:	85 c0                	test   %eax,%eax
801007d4:	0f 85 f6 fe ff ff    	jne    801006d0 <cprintf+0x30>
801007da:	e9 47 ff ff ff       	jmp    80100726 <cprintf+0x86>
801007df:	90                   	nop
    acquire(&cons.lock);
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 20 ff 10 80       	push   $0x8010ff20
801007e8:	e8 b3 49 00 00       	call   801051a0 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100812:	85 d2                	test   %edx,%edx
80100814:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100817:	74 2e                	je     80100847 <cprintf+0x1a7>
80100819:	fa                   	cli    
    for(;;)
8010081a:	eb fe                	jmp    8010081a <cprintf+0x17a>
8010081c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100820:	e8 db fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100825:	83 c7 01             	add    $0x1,%edi
80100828:	e9 28 ff ff ff       	jmp    80100755 <cprintf+0xb5>
8010082d:	fa                   	cli    
    for(;;)
8010082e:	eb fe                	jmp    8010082e <cprintf+0x18e>
80100830:	fa                   	cli    
80100831:	eb fe                	jmp    80100831 <cprintf+0x191>
80100833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100837:	90                   	nop
        s = "(null)";
80100838:	bf 18 7e 10 80       	mov    $0x80107e18,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ff 10 80       	push   $0x8010ff20
8010085b:	e8 e0 48 00 00       	call   80105140 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 1f 7e 10 80       	push   $0x80107e1f
80100878:	e8 03 fb ff ff       	call   80100380 <panic>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi

80100880 <consoleintr>:
{
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	57                   	push   %edi
80100884:	56                   	push   %esi
  int c, doprocdump = 0;
80100885:	31 f6                	xor    %esi,%esi
{
80100887:	53                   	push   %ebx
80100888:	83 ec 18             	sub    $0x18,%esp
8010088b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010088e:	68 20 ff 10 80       	push   $0x8010ff20
80100893:	e8 08 49 00 00       	call   801051a0 <acquire>
  while((c = getc()) >= 0){
80100898:	83 c4 10             	add    $0x10,%esp
8010089b:	eb 1a                	jmp    801008b7 <consoleintr+0x37>
8010089d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008a0:	83 fb 08             	cmp    $0x8,%ebx
801008a3:	0f 84 d7 00 00 00    	je     80100980 <consoleintr+0x100>
801008a9:	83 fb 10             	cmp    $0x10,%ebx
801008ac:	0f 85 32 01 00 00    	jne    801009e4 <consoleintr+0x164>
801008b2:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801008b7:	ff d7                	call   *%edi
801008b9:	89 c3                	mov    %eax,%ebx
801008bb:	85 c0                	test   %eax,%eax
801008bd:	0f 88 05 01 00 00    	js     801009c8 <consoleintr+0x148>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 78                	je     80100940 <consoleintr+0xc0>
801008c8:	7e d6                	jle    801008a0 <consoleintr+0x20>
801008ca:	83 fb 7f             	cmp    $0x7f,%ebx
801008cd:	0f 84 ad 00 00 00    	je     80100980 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d3:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
801008e0:	83 fa 7f             	cmp    $0x7f,%edx
801008e3:	77 d2                	ja     801008b7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e5:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008e8:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008ee:	83 e0 7f             	and    $0x7f,%eax
801008f1:	89 0d 08 ff 10 80    	mov    %ecx,0x8010ff08
        c = (c == '\r') ? '\n' : c;
801008f7:	83 fb 0d             	cmp    $0xd,%ebx
801008fa:	0f 84 13 01 00 00    	je     80100a13 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
80100900:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
  if(panicked){
80100906:	85 d2                	test   %edx,%edx
80100908:	0f 85 10 01 00 00    	jne    80100a1e <consoleintr+0x19e>
8010090e:	89 d8                	mov    %ebx,%eax
80100910:	e8 eb fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100915:	83 fb 0a             	cmp    $0xa,%ebx
80100918:	0f 84 14 01 00 00    	je     80100a32 <consoleintr+0x1b2>
8010091e:	83 fb 04             	cmp    $0x4,%ebx
80100921:	0f 84 0b 01 00 00    	je     80100a32 <consoleintr+0x1b2>
80100927:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010092c:	83 e8 80             	sub    $0xffffff80,%eax
8010092f:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
80100935:	75 80                	jne    801008b7 <consoleintr+0x37>
80100937:	e9 fb 00 00 00       	jmp    80100a37 <consoleintr+0x1b7>
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100940:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100945:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
8010094b:	0f 84 66 ff ff ff    	je     801008b7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100951:	83 e8 01             	sub    $0x1,%eax
80100954:	89 c2                	mov    %eax,%edx
80100956:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100959:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
80100960:	0f 84 51 ff ff ff    	je     801008b7 <consoleintr+0x37>
  if(panicked){
80100966:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.e--;
8010096c:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100971:	85 d2                	test   %edx,%edx
80100973:	74 33                	je     801009a8 <consoleintr+0x128>
80100975:	fa                   	cli    
    for(;;)
80100976:	eb fe                	jmp    80100976 <consoleintr+0xf6>
80100978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097f:	90                   	nop
      if(input.e != input.w){
80100980:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100985:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
8010098b:	0f 84 26 ff ff ff    	je     801008b7 <consoleintr+0x37>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100999:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 56                	je     801009f8 <consoleintr+0x178>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x123>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009b2:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801009b7:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801009bd:	75 92                	jne    80100951 <consoleintr+0xd1>
801009bf:	e9 f3 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
801009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 20 ff 10 80       	push   $0x8010ff20
801009d0:	e8 6b 47 00 00       	call   80105140 <release>
  if(doprocdump) {
801009d5:	83 c4 10             	add    $0x10,%esp
801009d8:	85 f6                	test   %esi,%esi
801009da:	75 2b                	jne    80100a07 <consoleintr+0x187>
}
801009dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009df:	5b                   	pop    %ebx
801009e0:	5e                   	pop    %esi
801009e1:	5f                   	pop    %edi
801009e2:	5d                   	pop    %ebp
801009e3:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009e4:	85 db                	test   %ebx,%ebx
801009e6:	0f 84 cb fe ff ff    	je     801008b7 <consoleintr+0x37>
801009ec:	e9 e2 fe ff ff       	jmp    801008d3 <consoleintr+0x53>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f8:	b8 00 01 00 00       	mov    $0x100,%eax
801009fd:	e8 fe f9 ff ff       	call   80100400 <consputc.part.0>
80100a02:	e9 b0 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
}
80100a07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a0a:	5b                   	pop    %ebx
80100a0b:	5e                   	pop    %esi
80100a0c:	5f                   	pop    %edi
80100a0d:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a0e:	e9 cd 3b 00 00       	jmp    801045e0 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a13:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
  if(panicked){
80100a1a:	85 d2                	test   %edx,%edx
80100a1c:	74 0a                	je     80100a28 <consoleintr+0x1a8>
80100a1e:	fa                   	cli    
    for(;;)
80100a1f:	eb fe                	jmp    80100a1f <consoleintr+0x19f>
80100a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a28:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a2d:	e8 ce f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a32:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
          wakeup(&input.r);
80100a37:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a3a:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
80100a3f:	68 00 ff 10 80       	push   $0x8010ff00
80100a44:	e8 57 3a 00 00       	call   801044a0 <wakeup>
80100a49:	83 c4 10             	add    $0x10,%esp
80100a4c:	e9 66 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
80100a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 28 7e 10 80       	push   $0x80107e28
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 5b 45 00 00       	call   80104fd0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c 09 11 80 90 	movl   $0x80100590,0x8011090c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 09 11 80 80 	movl   $0x80100280,0x80110908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 52 1a 00 00       	call   801024f0 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave  
80100aa2:	c3                   	ret    
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 6f 2f 00 00       	call   80103a30 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 04 23 00 00       	call   80102dd0 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 39 16 00 00       	call   80102110 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 6e 03 00 00    	je     80100e50 <exec+0x3a0>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 03 0d 00 00       	call   801017f0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 02 10 00 00       	call   80101b00 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	74 22                	je     80100b28 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b06:	83 ec 0c             	sub    $0xc,%esp
80100b09:	53                   	push   %ebx
80100b0a:	e8 71 0f 00 00       	call   80101a80 <iunlockput>
    end_op();
80100b0f:	e8 2c 23 00 00       	call   80102e40 <end_op>
80100b14:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b1f:	5b                   	pop    %ebx
80100b20:	5e                   	pop    %esi
80100b21:	5f                   	pop    %edi
80100b22:	5d                   	pop    %ebp
80100b23:	c3                   	ret    
80100b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b28:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b2f:	45 4c 46 
80100b32:	75 d2                	jne    80100b06 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b34:	e8 27 6f 00 00       	call   80107a60 <setupkvm>
80100b39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b3f:	85 c0                	test   %eax,%eax
80100b41:	74 c3                	je     80100b06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4a:	00 
80100b4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b51:	0f 84 18 03 00 00    	je     80100e6f <exec+0x3bf>
  sz = 0;
80100b57:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b5e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b61:	31 ff                	xor    %edi,%edi
80100b63:	e9 8e 00 00 00       	jmp    80100bf6 <exec+0x146>
80100b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b6f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100b70:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b77:	75 6c                	jne    80100be5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b79:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b7f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b85:	0f 82 87 00 00 00    	jb     80100c12 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b8b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b91:	72 7f                	jb     80100c12 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b93:	83 ec 04             	sub    $0x4,%esp
80100b96:	50                   	push   %eax
80100b97:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b9d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ba3:	e8 d8 6c 00 00       	call   80107880 <allocuvm>
80100ba8:	83 c4 10             	add    $0x10,%esp
80100bab:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	74 5d                	je     80100c12 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100bb5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bbb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bc0:	75 50                	jne    80100c12 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bc2:	83 ec 0c             	sub    $0xc,%esp
80100bc5:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bcb:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bd1:	53                   	push   %ebx
80100bd2:	50                   	push   %eax
80100bd3:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bd9:	e8 b2 6b 00 00       	call   80107790 <loaduvm>
80100bde:	83 c4 20             	add    $0x20,%esp
80100be1:	85 c0                	test   %eax,%eax
80100be3:	78 2d                	js     80100c12 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100be5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bec:	83 c7 01             	add    $0x1,%edi
80100bef:	83 c6 20             	add    $0x20,%esi
80100bf2:	39 f8                	cmp    %edi,%eax
80100bf4:	7e 3a                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bf6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bfc:	6a 20                	push   $0x20
80100bfe:	56                   	push   %esi
80100bff:	50                   	push   %eax
80100c00:	53                   	push   %ebx
80100c01:	e8 fa 0e 00 00       	call   80101b00 <readi>
80100c06:	83 c4 10             	add    $0x10,%esp
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	0f 84 5e ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c1b:	e8 c0 6d 00 00       	call   801079e0 <freevm>
  if(ip){
80100c20:	83 c4 10             	add    $0x10,%esp
80100c23:	e9 de fe ff ff       	jmp    80100b06 <exec+0x56>
80100c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c2f:	90                   	nop
  sz = PGROUNDUP(sz);
80100c30:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c36:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c3c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c42:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	53                   	push   %ebx
80100c4c:	e8 2f 0e 00 00       	call   80101a80 <iunlockput>
  end_op();
80100c51:	e8 ea 21 00 00       	call   80102e40 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 19 6c 00 00       	call   80107880 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c6                	mov    %eax,%esi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 94 00 00 00    	je     80100d08 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c7d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 78 6e 00 00       	call   80107b00 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c94:	8b 00                	mov    (%eax),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	0f 84 8b 00 00 00    	je     80100d29 <exec+0x279>
80100c9e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100ca4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100caa:	eb 23                	jmp    80100ccf <exec+0x21f>
80100cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100cb3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100cba:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cbd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100cc3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cc6:	85 c0                	test   %eax,%eax
80100cc8:	74 59                	je     80100d23 <exec+0x273>
    if(argc >= MAXARG)
80100cca:	83 ff 20             	cmp    $0x20,%edi
80100ccd:	74 39                	je     80100d08 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ccf:	83 ec 0c             	sub    $0xc,%esp
80100cd2:	50                   	push   %eax
80100cd3:	e8 88 47 00 00       	call   80105460 <strlen>
80100cd8:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cda:	58                   	pop    %eax
80100cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cde:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce1:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ce4:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce7:	e8 74 47 00 00       	call   80105460 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 d3 6f 00 00       	call   80107cd0 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 ca 6c 00 00       	call   801079e0 <freevm>
80100d16:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d1e:	e9 f9 fd ff ff       	jmp    80100b1c <exec+0x6c>
80100d23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d29:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d30:	89 d9                	mov    %ebx,%ecx
  ustack[1] = argc;
80100d32:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[3+argc] = 0;
80100d38:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d3f:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d43:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d45:	89 df                	mov    %ebx,%edi
80100d47:	83 c0 0c             	add    $0xc,%eax
80100d4a:	29 c7                	sub    %eax,%edi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d4c:	50                   	push   %eax
80100d4d:	52                   	push   %edx
80100d4e:	57                   	push   %edi
80100d4f:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d55:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d5c:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d5f:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d65:	e8 66 6f 00 00       	call   80107cd0 <copyout>
80100d6a:	83 c4 10             	add    $0x10,%esp
80100d6d:	85 c0                	test   %eax,%eax
80100d6f:	78 97                	js     80100d08 <exec+0x258>
  for(last=s=path; *s; s++)
80100d71:	8b 45 08             	mov    0x8(%ebp),%eax
80100d74:	8b 55 08             	mov    0x8(%ebp),%edx
80100d77:	0f b6 00             	movzbl (%eax),%eax
80100d7a:	84 c0                	test   %al,%al
80100d7c:	74 11                	je     80100d8f <exec+0x2df>
80100d7e:	89 d1                	mov    %edx,%ecx
      last = s+1;
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d85:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d88:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d8f:	8b 8d ec fe ff ff    	mov    -0x114(%ebp),%ecx
80100d95:	83 ec 04             	sub    $0x4,%esp
80100d98:	6a 10                	push   $0x10
80100d9a:	8d 59 6c             	lea    0x6c(%ecx),%ebx
80100d9d:	52                   	push   %edx
80100d9e:	53                   	push   %ebx
80100d9f:	e8 7c 46 00 00       	call   80105420 <safestrcpy>
  oldpgdir = curproc->pgdir;
80100da4:	8b 8d ec fe ff ff    	mov    -0x114(%ebp),%ecx
80100daa:	8b 41 04             	mov    0x4(%ecx),%eax
  curproc->tf->eip = elf.entry;  // main
80100dad:	8b 51 18             	mov    0x18(%ecx),%edx
  curproc->sz = sz;
80100db0:	89 31                	mov    %esi,(%ecx)
  oldpgdir = curproc->pgdir;
80100db2:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
  curproc->pgdir = pgdir;
80100db8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100dbe:	89 41 04             	mov    %eax,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100dc1:	89 c8                	mov    %ecx,%eax
80100dc3:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
80100dc9:	89 4a 38             	mov    %ecx,0x38(%edx)
  curproc->tf->esp = sp;
80100dcc:	8b 50 18             	mov    0x18(%eax),%edx
80100dcf:	89 7a 44             	mov    %edi,0x44(%edx)
  switchuvm(curproc);
80100dd2:	89 04 24             	mov    %eax,(%esp)
80100dd5:	e8 26 68 00 00       	call   80107600 <switchuvm>
  freevm(oldpgdir);
80100dda:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100de0:	89 04 24             	mov    %eax,(%esp)
80100de3:	e8 f8 6b 00 00       	call   801079e0 <freevm>
  if(strncmp(curproc->name,"sh",3) != 0  && strncmp(curproc->name ,"init",5) != 0 && curproc->queue != CLASS1){
80100de8:	83 c4 0c             	add    $0xc,%esp
80100deb:	6a 03                	push   $0x3
80100ded:	68 4d 7e 10 80       	push   $0x80107e4d
80100df2:	53                   	push   %ebx
80100df3:	e8 78 45 00 00       	call   80105370 <strncmp>
80100df8:	83 c4 10             	add    $0x10,%esp
80100dfb:	85 c0                	test   %eax,%eax
80100dfd:	75 07                	jne    80100e06 <exec+0x356>
  return 0;
80100dff:	31 c0                	xor    %eax,%eax
80100e01:	e9 16 fd ff ff       	jmp    80100b1c <exec+0x6c>
  if(strncmp(curproc->name,"sh",3) != 0  && strncmp(curproc->name ,"init",5) != 0 && curproc->queue != CLASS1){
80100e06:	83 ec 04             	sub    $0x4,%esp
80100e09:	6a 05                	push   $0x5
80100e0b:	68 50 7e 10 80       	push   $0x80107e50
80100e10:	53                   	push   %ebx
80100e11:	e8 5a 45 00 00       	call   80105370 <strncmp>
80100e16:	83 c4 10             	add    $0x10,%esp
80100e19:	85 c0                	test   %eax,%eax
80100e1b:	74 e2                	je     80100dff <exec+0x34f>
80100e1d:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100e23:	83 78 7c 00          	cmpl   $0x0,0x7c(%eax)
80100e27:	74 d6                	je     80100dff <exec+0x34f>
    change_num(curproc, -1);
80100e29:	52                   	push   %edx
80100e2a:	89 c6                	mov    %eax,%esi
80100e2c:	52                   	push   %edx
80100e2d:	6a ff                	push   $0xffffffff
80100e2f:	50                   	push   %eax
80100e30:	e8 1b 2b 00 00       	call   80103950 <change_num>
    curproc->queue = CLASS2_FCFS ;
80100e35:	c7 46 7c 02 00 00 00 	movl   $0x2,0x7c(%esi)
    change_num(curproc, 1);
80100e3c:	59                   	pop    %ecx
80100e3d:	5b                   	pop    %ebx
80100e3e:	6a 01                	push   $0x1
80100e40:	56                   	push   %esi
80100e41:	e8 0a 2b 00 00       	call   80103950 <change_num>
80100e46:	83 c4 10             	add    $0x10,%esp
  return 0;
80100e49:	31 c0                	xor    %eax,%eax
80100e4b:	e9 cc fc ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100e50:	e8 eb 1f 00 00       	call   80102e40 <end_op>
    cprintf("exec: fail\n");
80100e55:	83 ec 0c             	sub    $0xc,%esp
80100e58:	68 41 7e 10 80       	push   $0x80107e41
80100e5d:	e8 3e f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100e62:	83 c4 10             	add    $0x10,%esp
80100e65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e6a:	e9 ad fc ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e6f:	be 00 20 00 00       	mov    $0x2000,%esi
80100e74:	31 ff                	xor    %edi,%edi
80100e76:	e9 cd fd ff ff       	jmp    80100c48 <exec+0x198>
80100e7b:	66 90                	xchg   %ax,%ax
80100e7d:	66 90                	xchg   %ax,%ax
80100e7f:	90                   	nop

80100e80 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e80:	55                   	push   %ebp
80100e81:	89 e5                	mov    %esp,%ebp
80100e83:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e86:	68 55 7e 10 80       	push   $0x80107e55
80100e8b:	68 60 ff 10 80       	push   $0x8010ff60
80100e90:	e8 3b 41 00 00       	call   80104fd0 <initlock>
}
80100e95:	83 c4 10             	add    $0x10,%esp
80100e98:	c9                   	leave  
80100e99:	c3                   	ret    
80100e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ea0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ea4:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100ea9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100eac:	68 60 ff 10 80       	push   $0x8010ff60
80100eb1:	e8 ea 42 00 00       	call   801051a0 <acquire>
80100eb6:	83 c4 10             	add    $0x10,%esp
80100eb9:	eb 10                	jmp    80100ecb <filealloc+0x2b>
80100ebb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ebf:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ec0:	83 c3 18             	add    $0x18,%ebx
80100ec3:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100ec9:	74 25                	je     80100ef0 <filealloc+0x50>
    if(f->ref == 0){
80100ecb:	8b 43 04             	mov    0x4(%ebx),%eax
80100ece:	85 c0                	test   %eax,%eax
80100ed0:	75 ee                	jne    80100ec0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100ed2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100ed5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100edc:	68 60 ff 10 80       	push   $0x8010ff60
80100ee1:	e8 5a 42 00 00       	call   80105140 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100ee6:	89 d8                	mov    %ebx,%eax
      return f;
80100ee8:	83 c4 10             	add    $0x10,%esp
}
80100eeb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eee:	c9                   	leave  
80100eef:	c3                   	ret    
  release(&ftable.lock);
80100ef0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100ef3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100ef5:	68 60 ff 10 80       	push   $0x8010ff60
80100efa:	e8 41 42 00 00       	call   80105140 <release>
}
80100eff:	89 d8                	mov    %ebx,%eax
  return 0;
80100f01:	83 c4 10             	add    $0x10,%esp
}
80100f04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f07:	c9                   	leave  
80100f08:	c3                   	ret    
80100f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 10             	sub    $0x10,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100f1a:	68 60 ff 10 80       	push   $0x8010ff60
80100f1f:	e8 7c 42 00 00       	call   801051a0 <acquire>
  if(f->ref < 1)
80100f24:	8b 43 04             	mov    0x4(%ebx),%eax
80100f27:	83 c4 10             	add    $0x10,%esp
80100f2a:	85 c0                	test   %eax,%eax
80100f2c:	7e 1a                	jle    80100f48 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100f2e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100f31:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100f34:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100f37:	68 60 ff 10 80       	push   $0x8010ff60
80100f3c:	e8 ff 41 00 00       	call   80105140 <release>
  return f;
}
80100f41:	89 d8                	mov    %ebx,%eax
80100f43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f46:	c9                   	leave  
80100f47:	c3                   	ret    
    panic("filedup");
80100f48:	83 ec 0c             	sub    $0xc,%esp
80100f4b:	68 5c 7e 10 80       	push   $0x80107e5c
80100f50:	e8 2b f4 ff ff       	call   80100380 <panic>
80100f55:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f60 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 28             	sub    $0x28,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f6c:	68 60 ff 10 80       	push   $0x8010ff60
80100f71:	e8 2a 42 00 00       	call   801051a0 <acquire>
  if(f->ref < 1)
80100f76:	8b 53 04             	mov    0x4(%ebx),%edx
80100f79:	83 c4 10             	add    $0x10,%esp
80100f7c:	85 d2                	test   %edx,%edx
80100f7e:	0f 8e a5 00 00 00    	jle    80101029 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f84:	83 ea 01             	sub    $0x1,%edx
80100f87:	89 53 04             	mov    %edx,0x4(%ebx)
80100f8a:	75 44                	jne    80100fd0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f8c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f90:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f93:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f95:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f9b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f9e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100fa1:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100fa4:	68 60 ff 10 80       	push   $0x8010ff60
  ff = *f;
80100fa9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100fac:	e8 8f 41 00 00       	call   80105140 <release>

  if(ff.type == FD_PIPE)
80100fb1:	83 c4 10             	add    $0x10,%esp
80100fb4:	83 ff 01             	cmp    $0x1,%edi
80100fb7:	74 57                	je     80101010 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100fb9:	83 ff 02             	cmp    $0x2,%edi
80100fbc:	74 2a                	je     80100fe8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100fbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc1:	5b                   	pop    %ebx
80100fc2:	5e                   	pop    %esi
80100fc3:	5f                   	pop    %edi
80100fc4:	5d                   	pop    %ebp
80100fc5:	c3                   	ret    
80100fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fcd:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100fd0:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80100fd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fda:	5b                   	pop    %ebx
80100fdb:	5e                   	pop    %esi
80100fdc:	5f                   	pop    %edi
80100fdd:	5d                   	pop    %ebp
    release(&ftable.lock);
80100fde:	e9 5d 41 00 00       	jmp    80105140 <release>
80100fe3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100fe7:	90                   	nop
    begin_op();
80100fe8:	e8 e3 1d 00 00       	call   80102dd0 <begin_op>
    iput(ff.ip);
80100fed:	83 ec 0c             	sub    $0xc,%esp
80100ff0:	ff 75 e0             	push   -0x20(%ebp)
80100ff3:	e8 28 09 00 00       	call   80101920 <iput>
    end_op();
80100ff8:	83 c4 10             	add    $0x10,%esp
}
80100ffb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ffe:	5b                   	pop    %ebx
80100fff:	5e                   	pop    %esi
80101000:	5f                   	pop    %edi
80101001:	5d                   	pop    %ebp
    end_op();
80101002:	e9 39 1e 00 00       	jmp    80102e40 <end_op>
80101007:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010100e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80101010:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101014:	83 ec 08             	sub    $0x8,%esp
80101017:	53                   	push   %ebx
80101018:	56                   	push   %esi
80101019:	e8 82 25 00 00       	call   801035a0 <pipeclose>
8010101e:	83 c4 10             	add    $0x10,%esp
}
80101021:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101024:	5b                   	pop    %ebx
80101025:	5e                   	pop    %esi
80101026:	5f                   	pop    %edi
80101027:	5d                   	pop    %ebp
80101028:	c3                   	ret    
    panic("fileclose");
80101029:	83 ec 0c             	sub    $0xc,%esp
8010102c:	68 64 7e 10 80       	push   $0x80107e64
80101031:	e8 4a f3 ff ff       	call   80100380 <panic>
80101036:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010103d:	8d 76 00             	lea    0x0(%esi),%esi

80101040 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101040:	55                   	push   %ebp
80101041:	89 e5                	mov    %esp,%ebp
80101043:	53                   	push   %ebx
80101044:	83 ec 04             	sub    $0x4,%esp
80101047:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010104a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010104d:	75 31                	jne    80101080 <filestat+0x40>
    ilock(f->ip);
8010104f:	83 ec 0c             	sub    $0xc,%esp
80101052:	ff 73 10             	push   0x10(%ebx)
80101055:	e8 96 07 00 00       	call   801017f0 <ilock>
    stati(f->ip, st);
8010105a:	58                   	pop    %eax
8010105b:	5a                   	pop    %edx
8010105c:	ff 75 0c             	push   0xc(%ebp)
8010105f:	ff 73 10             	push   0x10(%ebx)
80101062:	e8 69 0a 00 00       	call   80101ad0 <stati>
    iunlock(f->ip);
80101067:	59                   	pop    %ecx
80101068:	ff 73 10             	push   0x10(%ebx)
8010106b:	e8 60 08 00 00       	call   801018d0 <iunlock>
    return 0;
  }
  return -1;
}
80101070:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101073:	83 c4 10             	add    $0x10,%esp
80101076:	31 c0                	xor    %eax,%eax
}
80101078:	c9                   	leave  
80101079:	c3                   	ret    
8010107a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101080:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101083:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101088:	c9                   	leave  
80101089:	c3                   	ret    
8010108a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101090 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101090:	55                   	push   %ebp
80101091:	89 e5                	mov    %esp,%ebp
80101093:	57                   	push   %edi
80101094:	56                   	push   %esi
80101095:	53                   	push   %ebx
80101096:	83 ec 0c             	sub    $0xc,%esp
80101099:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010109c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010109f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801010a2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801010a6:	74 60                	je     80101108 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
801010a8:	8b 03                	mov    (%ebx),%eax
801010aa:	83 f8 01             	cmp    $0x1,%eax
801010ad:	74 41                	je     801010f0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010af:	83 f8 02             	cmp    $0x2,%eax
801010b2:	75 5b                	jne    8010110f <fileread+0x7f>
    ilock(f->ip);
801010b4:	83 ec 0c             	sub    $0xc,%esp
801010b7:	ff 73 10             	push   0x10(%ebx)
801010ba:	e8 31 07 00 00       	call   801017f0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801010bf:	57                   	push   %edi
801010c0:	ff 73 14             	push   0x14(%ebx)
801010c3:	56                   	push   %esi
801010c4:	ff 73 10             	push   0x10(%ebx)
801010c7:	e8 34 0a 00 00       	call   80101b00 <readi>
801010cc:	83 c4 20             	add    $0x20,%esp
801010cf:	89 c6                	mov    %eax,%esi
801010d1:	85 c0                	test   %eax,%eax
801010d3:	7e 03                	jle    801010d8 <fileread+0x48>
      f->off += r;
801010d5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801010d8:	83 ec 0c             	sub    $0xc,%esp
801010db:	ff 73 10             	push   0x10(%ebx)
801010de:	e8 ed 07 00 00       	call   801018d0 <iunlock>
    return r;
801010e3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	89 f0                	mov    %esi,%eax
801010eb:	5b                   	pop    %ebx
801010ec:	5e                   	pop    %esi
801010ed:	5f                   	pop    %edi
801010ee:	5d                   	pop    %ebp
801010ef:	c3                   	ret    
    return piperead(f->pipe, addr, n);
801010f0:	8b 43 0c             	mov    0xc(%ebx),%eax
801010f3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010f9:	5b                   	pop    %ebx
801010fa:	5e                   	pop    %esi
801010fb:	5f                   	pop    %edi
801010fc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010fd:	e9 3e 26 00 00       	jmp    80103740 <piperead>
80101102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101108:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010110d:	eb d7                	jmp    801010e6 <fileread+0x56>
  panic("fileread");
8010110f:	83 ec 0c             	sub    $0xc,%esp
80101112:	68 6e 7e 10 80       	push   $0x80107e6e
80101117:	e8 64 f2 ff ff       	call   80100380 <panic>
8010111c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101120 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101120:	55                   	push   %ebp
80101121:	89 e5                	mov    %esp,%ebp
80101123:	57                   	push   %edi
80101124:	56                   	push   %esi
80101125:	53                   	push   %ebx
80101126:	83 ec 1c             	sub    $0x1c,%esp
80101129:	8b 45 0c             	mov    0xc(%ebp),%eax
8010112c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010112f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101132:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101135:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101139:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010113c:	0f 84 bd 00 00 00    	je     801011ff <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
80101142:	8b 03                	mov    (%ebx),%eax
80101144:	83 f8 01             	cmp    $0x1,%eax
80101147:	0f 84 bf 00 00 00    	je     8010120c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010114d:	83 f8 02             	cmp    $0x2,%eax
80101150:	0f 85 c8 00 00 00    	jne    8010121e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101156:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101159:	31 f6                	xor    %esi,%esi
    while(i < n){
8010115b:	85 c0                	test   %eax,%eax
8010115d:	7f 30                	jg     8010118f <filewrite+0x6f>
8010115f:	e9 94 00 00 00       	jmp    801011f8 <filewrite+0xd8>
80101164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101168:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010116b:	83 ec 0c             	sub    $0xc,%esp
8010116e:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101171:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101174:	e8 57 07 00 00       	call   801018d0 <iunlock>
      end_op();
80101179:	e8 c2 1c 00 00       	call   80102e40 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010117e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101181:	83 c4 10             	add    $0x10,%esp
80101184:	39 c7                	cmp    %eax,%edi
80101186:	75 5c                	jne    801011e4 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101188:	01 fe                	add    %edi,%esi
    while(i < n){
8010118a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010118d:	7e 69                	jle    801011f8 <filewrite+0xd8>
      int n1 = n - i;
8010118f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101192:	b8 00 06 00 00       	mov    $0x600,%eax
80101197:	29 f7                	sub    %esi,%edi
80101199:	39 c7                	cmp    %eax,%edi
8010119b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010119e:	e8 2d 1c 00 00       	call   80102dd0 <begin_op>
      ilock(f->ip);
801011a3:	83 ec 0c             	sub    $0xc,%esp
801011a6:	ff 73 10             	push   0x10(%ebx)
801011a9:	e8 42 06 00 00       	call   801017f0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801011ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011b1:	57                   	push   %edi
801011b2:	ff 73 14             	push   0x14(%ebx)
801011b5:	01 f0                	add    %esi,%eax
801011b7:	50                   	push   %eax
801011b8:	ff 73 10             	push   0x10(%ebx)
801011bb:	e8 40 0a 00 00       	call   80101c00 <writei>
801011c0:	83 c4 20             	add    $0x20,%esp
801011c3:	85 c0                	test   %eax,%eax
801011c5:	7f a1                	jg     80101168 <filewrite+0x48>
      iunlock(f->ip);
801011c7:	83 ec 0c             	sub    $0xc,%esp
801011ca:	ff 73 10             	push   0x10(%ebx)
801011cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011d0:	e8 fb 06 00 00       	call   801018d0 <iunlock>
      end_op();
801011d5:	e8 66 1c 00 00       	call   80102e40 <end_op>
      if(r < 0)
801011da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801011dd:	83 c4 10             	add    $0x10,%esp
801011e0:	85 c0                	test   %eax,%eax
801011e2:	75 1b                	jne    801011ff <filewrite+0xdf>
        panic("short filewrite");
801011e4:	83 ec 0c             	sub    $0xc,%esp
801011e7:	68 77 7e 10 80       	push   $0x80107e77
801011ec:	e8 8f f1 ff ff       	call   80100380 <panic>
801011f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
801011f8:	89 f0                	mov    %esi,%eax
801011fa:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
801011fd:	74 05                	je     80101204 <filewrite+0xe4>
801011ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101204:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101207:	5b                   	pop    %ebx
80101208:	5e                   	pop    %esi
80101209:	5f                   	pop    %edi
8010120a:	5d                   	pop    %ebp
8010120b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010120c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010120f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101212:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101215:	5b                   	pop    %ebx
80101216:	5e                   	pop    %esi
80101217:	5f                   	pop    %edi
80101218:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101219:	e9 22 24 00 00       	jmp    80103640 <pipewrite>
  panic("filewrite");
8010121e:	83 ec 0c             	sub    $0xc,%esp
80101221:	68 7d 7e 10 80       	push   $0x80107e7d
80101226:	e8 55 f1 ff ff       	call   80100380 <panic>
8010122b:	66 90                	xchg   %ax,%ax
8010122d:	66 90                	xchg   %ax,%ax
8010122f:	90                   	nop

80101230 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101230:	55                   	push   %ebp
80101231:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101233:	89 d0                	mov    %edx,%eax
80101235:	c1 e8 0c             	shr    $0xc,%eax
80101238:	03 05 cc 25 11 80    	add    0x801125cc,%eax
{
8010123e:	89 e5                	mov    %esp,%ebp
80101240:	56                   	push   %esi
80101241:	53                   	push   %ebx
80101242:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101244:	83 ec 08             	sub    $0x8,%esp
80101247:	50                   	push   %eax
80101248:	51                   	push   %ecx
80101249:	e8 82 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010124e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101250:	c1 fb 03             	sar    $0x3,%ebx
80101253:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101256:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101258:	83 e1 07             	and    $0x7,%ecx
8010125b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101260:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101266:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101268:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010126d:	85 c1                	test   %eax,%ecx
8010126f:	74 23                	je     80101294 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101271:	f7 d0                	not    %eax
  log_write(bp);
80101273:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101276:	21 c8                	and    %ecx,%eax
80101278:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010127c:	56                   	push   %esi
8010127d:	e8 2e 1d 00 00       	call   80102fb0 <log_write>
  brelse(bp);
80101282:	89 34 24             	mov    %esi,(%esp)
80101285:	e8 66 ef ff ff       	call   801001f0 <brelse>
}
8010128a:	83 c4 10             	add    $0x10,%esp
8010128d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101290:	5b                   	pop    %ebx
80101291:	5e                   	pop    %esi
80101292:	5d                   	pop    %ebp
80101293:	c3                   	ret    
    panic("freeing free block");
80101294:	83 ec 0c             	sub    $0xc,%esp
80101297:	68 87 7e 10 80       	push   $0x80107e87
8010129c:	e8 df f0 ff ff       	call   80100380 <panic>
801012a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012af:	90                   	nop

801012b0 <balloc>:
{
801012b0:	55                   	push   %ebp
801012b1:	89 e5                	mov    %esp,%ebp
801012b3:	57                   	push   %edi
801012b4:	56                   	push   %esi
801012b5:	53                   	push   %ebx
801012b6:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
801012b9:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
801012bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801012c2:	85 c9                	test   %ecx,%ecx
801012c4:	0f 84 87 00 00 00    	je     80101351 <balloc+0xa1>
801012ca:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801012d1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801012d4:	83 ec 08             	sub    $0x8,%esp
801012d7:	89 f0                	mov    %esi,%eax
801012d9:	c1 f8 0c             	sar    $0xc,%eax
801012dc:	03 05 cc 25 11 80    	add    0x801125cc,%eax
801012e2:	50                   	push   %eax
801012e3:	ff 75 d8             	push   -0x28(%ebp)
801012e6:	e8 e5 ed ff ff       	call   801000d0 <bread>
801012eb:	83 c4 10             	add    $0x10,%esp
801012ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012f1:	a1 b4 25 11 80       	mov    0x801125b4,%eax
801012f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801012f9:	31 c0                	xor    %eax,%eax
801012fb:	eb 2f                	jmp    8010132c <balloc+0x7c>
801012fd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101300:	89 c1                	mov    %eax,%ecx
80101302:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101307:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010130a:	83 e1 07             	and    $0x7,%ecx
8010130d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010130f:	89 c1                	mov    %eax,%ecx
80101311:	c1 f9 03             	sar    $0x3,%ecx
80101314:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101319:	89 fa                	mov    %edi,%edx
8010131b:	85 df                	test   %ebx,%edi
8010131d:	74 41                	je     80101360 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010131f:	83 c0 01             	add    $0x1,%eax
80101322:	83 c6 01             	add    $0x1,%esi
80101325:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010132a:	74 05                	je     80101331 <balloc+0x81>
8010132c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010132f:	77 cf                	ja     80101300 <balloc+0x50>
    brelse(bp);
80101331:	83 ec 0c             	sub    $0xc,%esp
80101334:	ff 75 e4             	push   -0x1c(%ebp)
80101337:	e8 b4 ee ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010133c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101343:	83 c4 10             	add    $0x10,%esp
80101346:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101349:	39 05 b4 25 11 80    	cmp    %eax,0x801125b4
8010134f:	77 80                	ja     801012d1 <balloc+0x21>
  panic("balloc: out of blocks");
80101351:	83 ec 0c             	sub    $0xc,%esp
80101354:	68 9a 7e 10 80       	push   $0x80107e9a
80101359:	e8 22 f0 ff ff       	call   80100380 <panic>
8010135e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101360:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101363:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101366:	09 da                	or     %ebx,%edx
80101368:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010136c:	57                   	push   %edi
8010136d:	e8 3e 1c 00 00       	call   80102fb0 <log_write>
        brelse(bp);
80101372:	89 3c 24             	mov    %edi,(%esp)
80101375:	e8 76 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010137a:	58                   	pop    %eax
8010137b:	5a                   	pop    %edx
8010137c:	56                   	push   %esi
8010137d:	ff 75 d8             	push   -0x28(%ebp)
80101380:	e8 4b ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101385:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101388:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010138a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010138d:	68 00 02 00 00       	push   $0x200
80101392:	6a 00                	push   $0x0
80101394:	50                   	push   %eax
80101395:	e8 c6 3e 00 00       	call   80105260 <memset>
  log_write(bp);
8010139a:	89 1c 24             	mov    %ebx,(%esp)
8010139d:	e8 0e 1c 00 00       	call   80102fb0 <log_write>
  brelse(bp);
801013a2:	89 1c 24             	mov    %ebx,(%esp)
801013a5:	e8 46 ee ff ff       	call   801001f0 <brelse>
}
801013aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013ad:	89 f0                	mov    %esi,%eax
801013af:	5b                   	pop    %ebx
801013b0:	5e                   	pop    %esi
801013b1:	5f                   	pop    %edi
801013b2:	5d                   	pop    %ebp
801013b3:	c3                   	ret    
801013b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013bf:	90                   	nop

801013c0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801013c0:	55                   	push   %ebp
801013c1:	89 e5                	mov    %esp,%ebp
801013c3:	57                   	push   %edi
801013c4:	89 c7                	mov    %eax,%edi
801013c6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801013c7:	31 f6                	xor    %esi,%esi
{
801013c9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013ca:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
801013cf:	83 ec 28             	sub    $0x28,%esp
801013d2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801013d5:	68 60 09 11 80       	push   $0x80110960
801013da:	e8 c1 3d 00 00       	call   801051a0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
801013e2:	83 c4 10             	add    $0x10,%esp
801013e5:	eb 1b                	jmp    80101402 <iget+0x42>
801013e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013ee:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f0:	39 3b                	cmp    %edi,(%ebx)
801013f2:	74 6c                	je     80101460 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013f4:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013fa:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101400:	73 26                	jae    80101428 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101402:	8b 43 08             	mov    0x8(%ebx),%eax
80101405:	85 c0                	test   %eax,%eax
80101407:	7f e7                	jg     801013f0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101409:	85 f6                	test   %esi,%esi
8010140b:	75 e7                	jne    801013f4 <iget+0x34>
8010140d:	85 c0                	test   %eax,%eax
8010140f:	75 76                	jne    80101487 <iget+0xc7>
80101411:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101413:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101419:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
8010141f:	72 e1                	jb     80101402 <iget+0x42>
80101421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101428:	85 f6                	test   %esi,%esi
8010142a:	74 79                	je     801014a5 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010142c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010142f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101431:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101434:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010143b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101442:	68 60 09 11 80       	push   $0x80110960
80101447:	e8 f4 3c 00 00       	call   80105140 <release>

  return ip;
8010144c:	83 c4 10             	add    $0x10,%esp
}
8010144f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101452:	89 f0                	mov    %esi,%eax
80101454:	5b                   	pop    %ebx
80101455:	5e                   	pop    %esi
80101456:	5f                   	pop    %edi
80101457:	5d                   	pop    %ebp
80101458:	c3                   	ret    
80101459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101460:	39 53 04             	cmp    %edx,0x4(%ebx)
80101463:	75 8f                	jne    801013f4 <iget+0x34>
      release(&icache.lock);
80101465:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101468:	83 c0 01             	add    $0x1,%eax
      return ip;
8010146b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010146d:	68 60 09 11 80       	push   $0x80110960
      ip->ref++;
80101472:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101475:	e8 c6 3c 00 00       	call   80105140 <release>
      return ip;
8010147a:	83 c4 10             	add    $0x10,%esp
}
8010147d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101480:	89 f0                	mov    %esi,%eax
80101482:	5b                   	pop    %ebx
80101483:	5e                   	pop    %esi
80101484:	5f                   	pop    %edi
80101485:	5d                   	pop    %ebp
80101486:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101487:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010148d:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101493:	73 10                	jae    801014a5 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101495:	8b 43 08             	mov    0x8(%ebx),%eax
80101498:	85 c0                	test   %eax,%eax
8010149a:	0f 8f 50 ff ff ff    	jg     801013f0 <iget+0x30>
801014a0:	e9 68 ff ff ff       	jmp    8010140d <iget+0x4d>
    panic("iget: no inodes");
801014a5:	83 ec 0c             	sub    $0xc,%esp
801014a8:	68 b0 7e 10 80       	push   $0x80107eb0
801014ad:	e8 ce ee ff ff       	call   80100380 <panic>
801014b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801014c0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801014c0:	55                   	push   %ebp
801014c1:	89 e5                	mov    %esp,%ebp
801014c3:	57                   	push   %edi
801014c4:	56                   	push   %esi
801014c5:	89 c6                	mov    %eax,%esi
801014c7:	53                   	push   %ebx
801014c8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801014cb:	83 fa 0b             	cmp    $0xb,%edx
801014ce:	0f 86 8c 00 00 00    	jbe    80101560 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801014d4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801014d7:	83 fb 7f             	cmp    $0x7f,%ebx
801014da:	0f 87 a2 00 00 00    	ja     80101582 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801014e0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801014e6:	85 c0                	test   %eax,%eax
801014e8:	74 5e                	je     80101548 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801014ea:	83 ec 08             	sub    $0x8,%esp
801014ed:	50                   	push   %eax
801014ee:	ff 36                	push   (%esi)
801014f0:	e8 db eb ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801014f5:	83 c4 10             	add    $0x10,%esp
801014f8:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
801014fc:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
801014fe:	8b 3b                	mov    (%ebx),%edi
80101500:	85 ff                	test   %edi,%edi
80101502:	74 1c                	je     80101520 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101504:	83 ec 0c             	sub    $0xc,%esp
80101507:	52                   	push   %edx
80101508:	e8 e3 ec ff ff       	call   801001f0 <brelse>
8010150d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101510:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101513:	89 f8                	mov    %edi,%eax
80101515:	5b                   	pop    %ebx
80101516:	5e                   	pop    %esi
80101517:	5f                   	pop    %edi
80101518:	5d                   	pop    %ebp
80101519:	c3                   	ret    
8010151a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101520:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101523:	8b 06                	mov    (%esi),%eax
80101525:	e8 86 fd ff ff       	call   801012b0 <balloc>
      log_write(bp);
8010152a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010152d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101530:	89 03                	mov    %eax,(%ebx)
80101532:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101534:	52                   	push   %edx
80101535:	e8 76 1a 00 00       	call   80102fb0 <log_write>
8010153a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010153d:	83 c4 10             	add    $0x10,%esp
80101540:	eb c2                	jmp    80101504 <bmap+0x44>
80101542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101548:	8b 06                	mov    (%esi),%eax
8010154a:	e8 61 fd ff ff       	call   801012b0 <balloc>
8010154f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101555:	eb 93                	jmp    801014ea <bmap+0x2a>
80101557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010155e:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
80101560:	8d 5a 14             	lea    0x14(%edx),%ebx
80101563:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101567:	85 ff                	test   %edi,%edi
80101569:	75 a5                	jne    80101510 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010156b:	8b 00                	mov    (%eax),%eax
8010156d:	e8 3e fd ff ff       	call   801012b0 <balloc>
80101572:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101576:	89 c7                	mov    %eax,%edi
}
80101578:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010157b:	5b                   	pop    %ebx
8010157c:	89 f8                	mov    %edi,%eax
8010157e:	5e                   	pop    %esi
8010157f:	5f                   	pop    %edi
80101580:	5d                   	pop    %ebp
80101581:	c3                   	ret    
  panic("bmap: out of range");
80101582:	83 ec 0c             	sub    $0xc,%esp
80101585:	68 c0 7e 10 80       	push   $0x80107ec0
8010158a:	e8 f1 ed ff ff       	call   80100380 <panic>
8010158f:	90                   	nop

80101590 <readsb>:
{
80101590:	55                   	push   %ebp
80101591:	89 e5                	mov    %esp,%ebp
80101593:	56                   	push   %esi
80101594:	53                   	push   %ebx
80101595:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101598:	83 ec 08             	sub    $0x8,%esp
8010159b:	6a 01                	push   $0x1
8010159d:	ff 75 08             	push   0x8(%ebp)
801015a0:	e8 2b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015a5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015a8:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015aa:	8d 40 5c             	lea    0x5c(%eax),%eax
801015ad:	6a 1c                	push   $0x1c
801015af:	50                   	push   %eax
801015b0:	56                   	push   %esi
801015b1:	e8 4a 3d 00 00       	call   80105300 <memmove>
  brelse(bp);
801015b6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801015b9:	83 c4 10             	add    $0x10,%esp
}
801015bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015bf:	5b                   	pop    %ebx
801015c0:	5e                   	pop    %esi
801015c1:	5d                   	pop    %ebp
  brelse(bp);
801015c2:	e9 29 ec ff ff       	jmp    801001f0 <brelse>
801015c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015ce:	66 90                	xchg   %ax,%ax

801015d0 <iinit>:
{
801015d0:	55                   	push   %ebp
801015d1:	89 e5                	mov    %esp,%ebp
801015d3:	53                   	push   %ebx
801015d4:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
801015d9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801015dc:	68 d3 7e 10 80       	push   $0x80107ed3
801015e1:	68 60 09 11 80       	push   $0x80110960
801015e6:	e8 e5 39 00 00       	call   80104fd0 <initlock>
  for(i = 0; i < NINODE; i++) {
801015eb:	83 c4 10             	add    $0x10,%esp
801015ee:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801015f0:	83 ec 08             	sub    $0x8,%esp
801015f3:	68 da 7e 10 80       	push   $0x80107eda
801015f8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801015f9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801015ff:	e8 9c 38 00 00       	call   80104ea0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101604:	83 c4 10             	add    $0x10,%esp
80101607:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
8010160d:	75 e1                	jne    801015f0 <iinit+0x20>
  bp = bread(dev, 1);
8010160f:	83 ec 08             	sub    $0x8,%esp
80101612:	6a 01                	push   $0x1
80101614:	ff 75 08             	push   0x8(%ebp)
80101617:	e8 b4 ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010161c:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010161f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101621:	8d 40 5c             	lea    0x5c(%eax),%eax
80101624:	6a 1c                	push   $0x1c
80101626:	50                   	push   %eax
80101627:	68 b4 25 11 80       	push   $0x801125b4
8010162c:	e8 cf 3c 00 00       	call   80105300 <memmove>
  brelse(bp);
80101631:	89 1c 24             	mov    %ebx,(%esp)
80101634:	e8 b7 eb ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101639:	ff 35 cc 25 11 80    	push   0x801125cc
8010163f:	ff 35 c8 25 11 80    	push   0x801125c8
80101645:	ff 35 c4 25 11 80    	push   0x801125c4
8010164b:	ff 35 c0 25 11 80    	push   0x801125c0
80101651:	ff 35 bc 25 11 80    	push   0x801125bc
80101657:	ff 35 b8 25 11 80    	push   0x801125b8
8010165d:	ff 35 b4 25 11 80    	push   0x801125b4
80101663:	68 40 7f 10 80       	push   $0x80107f40
80101668:	e8 33 f0 ff ff       	call   801006a0 <cprintf>
}
8010166d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101670:	83 c4 30             	add    $0x30,%esp
80101673:	c9                   	leave  
80101674:	c3                   	ret    
80101675:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010167c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101680 <ialloc>:
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	57                   	push   %edi
80101684:	56                   	push   %esi
80101685:	53                   	push   %ebx
80101686:	83 ec 1c             	sub    $0x1c,%esp
80101689:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010168c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
80101693:	8b 75 08             	mov    0x8(%ebp),%esi
80101696:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101699:	0f 86 91 00 00 00    	jbe    80101730 <ialloc+0xb0>
8010169f:	bf 01 00 00 00       	mov    $0x1,%edi
801016a4:	eb 21                	jmp    801016c7 <ialloc+0x47>
801016a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801016ad:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801016b0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801016b3:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
801016b6:	53                   	push   %ebx
801016b7:	e8 34 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801016bc:	83 c4 10             	add    $0x10,%esp
801016bf:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
801016c5:	73 69                	jae    80101730 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801016c7:	89 f8                	mov    %edi,%eax
801016c9:	83 ec 08             	sub    $0x8,%esp
801016cc:	c1 e8 03             	shr    $0x3,%eax
801016cf:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801016d5:	50                   	push   %eax
801016d6:	56                   	push   %esi
801016d7:	e8 f4 e9 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
801016dc:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801016df:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
801016e1:	89 f8                	mov    %edi,%eax
801016e3:	83 e0 07             	and    $0x7,%eax
801016e6:	c1 e0 06             	shl    $0x6,%eax
801016e9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801016ed:	66 83 39 00          	cmpw   $0x0,(%ecx)
801016f1:	75 bd                	jne    801016b0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016f3:	83 ec 04             	sub    $0x4,%esp
801016f6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016f9:	6a 40                	push   $0x40
801016fb:	6a 00                	push   $0x0
801016fd:	51                   	push   %ecx
801016fe:	e8 5d 3b 00 00       	call   80105260 <memset>
      dip->type = type;
80101703:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101707:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010170a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010170d:	89 1c 24             	mov    %ebx,(%esp)
80101710:	e8 9b 18 00 00       	call   80102fb0 <log_write>
      brelse(bp);
80101715:	89 1c 24             	mov    %ebx,(%esp)
80101718:	e8 d3 ea ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010171d:	83 c4 10             	add    $0x10,%esp
}
80101720:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101723:	89 fa                	mov    %edi,%edx
}
80101725:	5b                   	pop    %ebx
      return iget(dev, inum);
80101726:	89 f0                	mov    %esi,%eax
}
80101728:	5e                   	pop    %esi
80101729:	5f                   	pop    %edi
8010172a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010172b:	e9 90 fc ff ff       	jmp    801013c0 <iget>
  panic("ialloc: no inodes");
80101730:	83 ec 0c             	sub    $0xc,%esp
80101733:	68 e0 7e 10 80       	push   $0x80107ee0
80101738:	e8 43 ec ff ff       	call   80100380 <panic>
8010173d:	8d 76 00             	lea    0x0(%esi),%esi

80101740 <iupdate>:
{
80101740:	55                   	push   %ebp
80101741:	89 e5                	mov    %esp,%ebp
80101743:	56                   	push   %esi
80101744:	53                   	push   %ebx
80101745:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101748:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010174b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010174e:	83 ec 08             	sub    $0x8,%esp
80101751:	c1 e8 03             	shr    $0x3,%eax
80101754:	03 05 c8 25 11 80    	add    0x801125c8,%eax
8010175a:	50                   	push   %eax
8010175b:	ff 73 a4             	push   -0x5c(%ebx)
8010175e:	e8 6d e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101763:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101767:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010176a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010176c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010176f:	83 e0 07             	and    $0x7,%eax
80101772:	c1 e0 06             	shl    $0x6,%eax
80101775:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101779:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010177c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101780:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101783:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101787:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010178b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010178f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101793:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101797:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010179a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010179d:	6a 34                	push   $0x34
8010179f:	53                   	push   %ebx
801017a0:	50                   	push   %eax
801017a1:	e8 5a 3b 00 00       	call   80105300 <memmove>
  log_write(bp);
801017a6:	89 34 24             	mov    %esi,(%esp)
801017a9:	e8 02 18 00 00       	call   80102fb0 <log_write>
  brelse(bp);
801017ae:	89 75 08             	mov    %esi,0x8(%ebp)
801017b1:	83 c4 10             	add    $0x10,%esp
}
801017b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017b7:	5b                   	pop    %ebx
801017b8:	5e                   	pop    %esi
801017b9:	5d                   	pop    %ebp
  brelse(bp);
801017ba:	e9 31 ea ff ff       	jmp    801001f0 <brelse>
801017bf:	90                   	nop

801017c0 <idup>:
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	53                   	push   %ebx
801017c4:	83 ec 10             	sub    $0x10,%esp
801017c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801017ca:	68 60 09 11 80       	push   $0x80110960
801017cf:	e8 cc 39 00 00       	call   801051a0 <acquire>
  ip->ref++;
801017d4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017d8:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801017df:	e8 5c 39 00 00       	call   80105140 <release>
}
801017e4:	89 d8                	mov    %ebx,%eax
801017e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017e9:	c9                   	leave  
801017ea:	c3                   	ret    
801017eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801017ef:	90                   	nop

801017f0 <ilock>:
{
801017f0:	55                   	push   %ebp
801017f1:	89 e5                	mov    %esp,%ebp
801017f3:	56                   	push   %esi
801017f4:	53                   	push   %ebx
801017f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017f8:	85 db                	test   %ebx,%ebx
801017fa:	0f 84 b7 00 00 00    	je     801018b7 <ilock+0xc7>
80101800:	8b 53 08             	mov    0x8(%ebx),%edx
80101803:	85 d2                	test   %edx,%edx
80101805:	0f 8e ac 00 00 00    	jle    801018b7 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010180b:	83 ec 0c             	sub    $0xc,%esp
8010180e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101811:	50                   	push   %eax
80101812:	e8 c9 36 00 00       	call   80104ee0 <acquiresleep>
  if(ip->valid == 0){
80101817:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010181a:	83 c4 10             	add    $0x10,%esp
8010181d:	85 c0                	test   %eax,%eax
8010181f:	74 0f                	je     80101830 <ilock+0x40>
}
80101821:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101824:	5b                   	pop    %ebx
80101825:	5e                   	pop    %esi
80101826:	5d                   	pop    %ebp
80101827:	c3                   	ret    
80101828:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010182f:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101830:	8b 43 04             	mov    0x4(%ebx),%eax
80101833:	83 ec 08             	sub    $0x8,%esp
80101836:	c1 e8 03             	shr    $0x3,%eax
80101839:	03 05 c8 25 11 80    	add    0x801125c8,%eax
8010183f:	50                   	push   %eax
80101840:	ff 33                	push   (%ebx)
80101842:	e8 89 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101847:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010184a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010184c:	8b 43 04             	mov    0x4(%ebx),%eax
8010184f:	83 e0 07             	and    $0x7,%eax
80101852:	c1 e0 06             	shl    $0x6,%eax
80101855:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101859:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010185c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010185f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101863:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101867:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010186b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010186f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101873:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101877:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010187b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010187e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101881:	6a 34                	push   $0x34
80101883:	50                   	push   %eax
80101884:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101887:	50                   	push   %eax
80101888:	e8 73 3a 00 00       	call   80105300 <memmove>
    brelse(bp);
8010188d:	89 34 24             	mov    %esi,(%esp)
80101890:	e8 5b e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101895:	83 c4 10             	add    $0x10,%esp
80101898:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010189d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801018a4:	0f 85 77 ff ff ff    	jne    80101821 <ilock+0x31>
      panic("ilock: no type");
801018aa:	83 ec 0c             	sub    $0xc,%esp
801018ad:	68 f8 7e 10 80       	push   $0x80107ef8
801018b2:	e8 c9 ea ff ff       	call   80100380 <panic>
    panic("ilock");
801018b7:	83 ec 0c             	sub    $0xc,%esp
801018ba:	68 f2 7e 10 80       	push   $0x80107ef2
801018bf:	e8 bc ea ff ff       	call   80100380 <panic>
801018c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018cf:	90                   	nop

801018d0 <iunlock>:
{
801018d0:	55                   	push   %ebp
801018d1:	89 e5                	mov    %esp,%ebp
801018d3:	56                   	push   %esi
801018d4:	53                   	push   %ebx
801018d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801018d8:	85 db                	test   %ebx,%ebx
801018da:	74 28                	je     80101904 <iunlock+0x34>
801018dc:	83 ec 0c             	sub    $0xc,%esp
801018df:	8d 73 0c             	lea    0xc(%ebx),%esi
801018e2:	56                   	push   %esi
801018e3:	e8 98 36 00 00       	call   80104f80 <holdingsleep>
801018e8:	83 c4 10             	add    $0x10,%esp
801018eb:	85 c0                	test   %eax,%eax
801018ed:	74 15                	je     80101904 <iunlock+0x34>
801018ef:	8b 43 08             	mov    0x8(%ebx),%eax
801018f2:	85 c0                	test   %eax,%eax
801018f4:	7e 0e                	jle    80101904 <iunlock+0x34>
  releasesleep(&ip->lock);
801018f6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801018f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018fc:	5b                   	pop    %ebx
801018fd:	5e                   	pop    %esi
801018fe:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801018ff:	e9 3c 36 00 00       	jmp    80104f40 <releasesleep>
    panic("iunlock");
80101904:	83 ec 0c             	sub    $0xc,%esp
80101907:	68 07 7f 10 80       	push   $0x80107f07
8010190c:	e8 6f ea ff ff       	call   80100380 <panic>
80101911:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101918:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010191f:	90                   	nop

80101920 <iput>:
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	57                   	push   %edi
80101924:	56                   	push   %esi
80101925:	53                   	push   %ebx
80101926:	83 ec 28             	sub    $0x28,%esp
80101929:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010192c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010192f:	57                   	push   %edi
80101930:	e8 ab 35 00 00       	call   80104ee0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101935:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101938:	83 c4 10             	add    $0x10,%esp
8010193b:	85 d2                	test   %edx,%edx
8010193d:	74 07                	je     80101946 <iput+0x26>
8010193f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101944:	74 32                	je     80101978 <iput+0x58>
  releasesleep(&ip->lock);
80101946:	83 ec 0c             	sub    $0xc,%esp
80101949:	57                   	push   %edi
8010194a:	e8 f1 35 00 00       	call   80104f40 <releasesleep>
  acquire(&icache.lock);
8010194f:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101956:	e8 45 38 00 00       	call   801051a0 <acquire>
  ip->ref--;
8010195b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010195f:	83 c4 10             	add    $0x10,%esp
80101962:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
80101969:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010196c:	5b                   	pop    %ebx
8010196d:	5e                   	pop    %esi
8010196e:	5f                   	pop    %edi
8010196f:	5d                   	pop    %ebp
  release(&icache.lock);
80101970:	e9 cb 37 00 00       	jmp    80105140 <release>
80101975:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101978:	83 ec 0c             	sub    $0xc,%esp
8010197b:	68 60 09 11 80       	push   $0x80110960
80101980:	e8 1b 38 00 00       	call   801051a0 <acquire>
    int r = ip->ref;
80101985:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101988:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010198f:	e8 ac 37 00 00       	call   80105140 <release>
    if(r == 1){
80101994:	83 c4 10             	add    $0x10,%esp
80101997:	83 fe 01             	cmp    $0x1,%esi
8010199a:	75 aa                	jne    80101946 <iput+0x26>
8010199c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801019a2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801019a5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801019a8:	89 cf                	mov    %ecx,%edi
801019aa:	eb 0b                	jmp    801019b7 <iput+0x97>
801019ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801019b0:	83 c6 04             	add    $0x4,%esi
801019b3:	39 fe                	cmp    %edi,%esi
801019b5:	74 19                	je     801019d0 <iput+0xb0>
    if(ip->addrs[i]){
801019b7:	8b 16                	mov    (%esi),%edx
801019b9:	85 d2                	test   %edx,%edx
801019bb:	74 f3                	je     801019b0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801019bd:	8b 03                	mov    (%ebx),%eax
801019bf:	e8 6c f8 ff ff       	call   80101230 <bfree>
      ip->addrs[i] = 0;
801019c4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801019ca:	eb e4                	jmp    801019b0 <iput+0x90>
801019cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801019d0:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801019d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019d9:	85 c0                	test   %eax,%eax
801019db:	75 2d                	jne    80101a0a <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801019dd:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801019e0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801019e7:	53                   	push   %ebx
801019e8:	e8 53 fd ff ff       	call   80101740 <iupdate>
      ip->type = 0;
801019ed:	31 c0                	xor    %eax,%eax
801019ef:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801019f3:	89 1c 24             	mov    %ebx,(%esp)
801019f6:	e8 45 fd ff ff       	call   80101740 <iupdate>
      ip->valid = 0;
801019fb:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101a02:	83 c4 10             	add    $0x10,%esp
80101a05:	e9 3c ff ff ff       	jmp    80101946 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101a0a:	83 ec 08             	sub    $0x8,%esp
80101a0d:	50                   	push   %eax
80101a0e:	ff 33                	push   (%ebx)
80101a10:	e8 bb e6 ff ff       	call   801000d0 <bread>
80101a15:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a18:	83 c4 10             	add    $0x10,%esp
80101a1b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101a21:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101a24:	8d 70 5c             	lea    0x5c(%eax),%esi
80101a27:	89 cf                	mov    %ecx,%edi
80101a29:	eb 0c                	jmp    80101a37 <iput+0x117>
80101a2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a2f:	90                   	nop
80101a30:	83 c6 04             	add    $0x4,%esi
80101a33:	39 f7                	cmp    %esi,%edi
80101a35:	74 0f                	je     80101a46 <iput+0x126>
      if(a[j])
80101a37:	8b 16                	mov    (%esi),%edx
80101a39:	85 d2                	test   %edx,%edx
80101a3b:	74 f3                	je     80101a30 <iput+0x110>
        bfree(ip->dev, a[j]);
80101a3d:	8b 03                	mov    (%ebx),%eax
80101a3f:	e8 ec f7 ff ff       	call   80101230 <bfree>
80101a44:	eb ea                	jmp    80101a30 <iput+0x110>
    brelse(bp);
80101a46:	83 ec 0c             	sub    $0xc,%esp
80101a49:	ff 75 e4             	push   -0x1c(%ebp)
80101a4c:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a4f:	e8 9c e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a54:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a5a:	8b 03                	mov    (%ebx),%eax
80101a5c:	e8 cf f7 ff ff       	call   80101230 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a61:	83 c4 10             	add    $0x10,%esp
80101a64:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a6b:	00 00 00 
80101a6e:	e9 6a ff ff ff       	jmp    801019dd <iput+0xbd>
80101a73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a80 <iunlockput>:
{
80101a80:	55                   	push   %ebp
80101a81:	89 e5                	mov    %esp,%ebp
80101a83:	56                   	push   %esi
80101a84:	53                   	push   %ebx
80101a85:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a88:	85 db                	test   %ebx,%ebx
80101a8a:	74 34                	je     80101ac0 <iunlockput+0x40>
80101a8c:	83 ec 0c             	sub    $0xc,%esp
80101a8f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a92:	56                   	push   %esi
80101a93:	e8 e8 34 00 00       	call   80104f80 <holdingsleep>
80101a98:	83 c4 10             	add    $0x10,%esp
80101a9b:	85 c0                	test   %eax,%eax
80101a9d:	74 21                	je     80101ac0 <iunlockput+0x40>
80101a9f:	8b 43 08             	mov    0x8(%ebx),%eax
80101aa2:	85 c0                	test   %eax,%eax
80101aa4:	7e 1a                	jle    80101ac0 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101aa6:	83 ec 0c             	sub    $0xc,%esp
80101aa9:	56                   	push   %esi
80101aaa:	e8 91 34 00 00       	call   80104f40 <releasesleep>
  iput(ip);
80101aaf:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101ab2:	83 c4 10             	add    $0x10,%esp
}
80101ab5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101ab8:	5b                   	pop    %ebx
80101ab9:	5e                   	pop    %esi
80101aba:	5d                   	pop    %ebp
  iput(ip);
80101abb:	e9 60 fe ff ff       	jmp    80101920 <iput>
    panic("iunlock");
80101ac0:	83 ec 0c             	sub    $0xc,%esp
80101ac3:	68 07 7f 10 80       	push   $0x80107f07
80101ac8:	e8 b3 e8 ff ff       	call   80100380 <panic>
80101acd:	8d 76 00             	lea    0x0(%esi),%esi

80101ad0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101ad0:	55                   	push   %ebp
80101ad1:	89 e5                	mov    %esp,%ebp
80101ad3:	8b 55 08             	mov    0x8(%ebp),%edx
80101ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101ad9:	8b 0a                	mov    (%edx),%ecx
80101adb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101ade:	8b 4a 04             	mov    0x4(%edx),%ecx
80101ae1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101ae4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101ae8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101aeb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101aef:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101af3:	8b 52 58             	mov    0x58(%edx),%edx
80101af6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101af9:	5d                   	pop    %ebp
80101afa:	c3                   	ret    
80101afb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aff:	90                   	nop

80101b00 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101b00:	55                   	push   %ebp
80101b01:	89 e5                	mov    %esp,%ebp
80101b03:	57                   	push   %edi
80101b04:	56                   	push   %esi
80101b05:	53                   	push   %ebx
80101b06:	83 ec 1c             	sub    $0x1c,%esp
80101b09:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101b0c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0f:	8b 75 10             	mov    0x10(%ebp),%esi
80101b12:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101b15:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b18:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b1d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b20:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101b23:	0f 84 a7 00 00 00    	je     80101bd0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101b29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b2c:	8b 40 58             	mov    0x58(%eax),%eax
80101b2f:	39 c6                	cmp    %eax,%esi
80101b31:	0f 87 ba 00 00 00    	ja     80101bf1 <readi+0xf1>
80101b37:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b3a:	31 c9                	xor    %ecx,%ecx
80101b3c:	89 da                	mov    %ebx,%edx
80101b3e:	01 f2                	add    %esi,%edx
80101b40:	0f 92 c1             	setb   %cl
80101b43:	89 cf                	mov    %ecx,%edi
80101b45:	0f 82 a6 00 00 00    	jb     80101bf1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101b4b:	89 c1                	mov    %eax,%ecx
80101b4d:	29 f1                	sub    %esi,%ecx
80101b4f:	39 d0                	cmp    %edx,%eax
80101b51:	0f 43 cb             	cmovae %ebx,%ecx
80101b54:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b57:	85 c9                	test   %ecx,%ecx
80101b59:	74 67                	je     80101bc2 <readi+0xc2>
80101b5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b5f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b60:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b63:	89 f2                	mov    %esi,%edx
80101b65:	c1 ea 09             	shr    $0x9,%edx
80101b68:	89 d8                	mov    %ebx,%eax
80101b6a:	e8 51 f9 ff ff       	call   801014c0 <bmap>
80101b6f:	83 ec 08             	sub    $0x8,%esp
80101b72:	50                   	push   %eax
80101b73:	ff 33                	push   (%ebx)
80101b75:	e8 56 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b7a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b7d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b82:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b84:	89 f0                	mov    %esi,%eax
80101b86:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b8b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b8d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b90:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b92:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b96:	39 d9                	cmp    %ebx,%ecx
80101b98:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b9b:	83 c4 0c             	add    $0xc,%esp
80101b9e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b9f:	01 df                	add    %ebx,%edi
80101ba1:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101ba3:	50                   	push   %eax
80101ba4:	ff 75 e0             	push   -0x20(%ebp)
80101ba7:	e8 54 37 00 00       	call   80105300 <memmove>
    brelse(bp);
80101bac:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101baf:	89 14 24             	mov    %edx,(%esp)
80101bb2:	e8 39 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bb7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101bba:	83 c4 10             	add    $0x10,%esp
80101bbd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101bc0:	77 9e                	ja     80101b60 <readi+0x60>
  }
  return n;
80101bc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101bc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bc8:	5b                   	pop    %ebx
80101bc9:	5e                   	pop    %esi
80101bca:	5f                   	pop    %edi
80101bcb:	5d                   	pop    %ebp
80101bcc:	c3                   	ret    
80101bcd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101bd0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101bd4:	66 83 f8 09          	cmp    $0x9,%ax
80101bd8:	77 17                	ja     80101bf1 <readi+0xf1>
80101bda:	8b 04 c5 00 09 11 80 	mov    -0x7feef700(,%eax,8),%eax
80101be1:	85 c0                	test   %eax,%eax
80101be3:	74 0c                	je     80101bf1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101be5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101be8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101beb:	5b                   	pop    %ebx
80101bec:	5e                   	pop    %esi
80101bed:	5f                   	pop    %edi
80101bee:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101bef:	ff e0                	jmp    *%eax
      return -1;
80101bf1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101bf6:	eb cd                	jmp    80101bc5 <readi+0xc5>
80101bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bff:	90                   	nop

80101c00 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101c00:	55                   	push   %ebp
80101c01:	89 e5                	mov    %esp,%ebp
80101c03:	57                   	push   %edi
80101c04:	56                   	push   %esi
80101c05:	53                   	push   %ebx
80101c06:	83 ec 1c             	sub    $0x1c,%esp
80101c09:	8b 45 08             	mov    0x8(%ebp),%eax
80101c0c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101c0f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c12:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101c17:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101c1a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c1d:	8b 75 10             	mov    0x10(%ebp),%esi
80101c20:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101c23:	0f 84 b7 00 00 00    	je     80101ce0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101c29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c2c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c2f:	0f 87 e7 00 00 00    	ja     80101d1c <writei+0x11c>
80101c35:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101c38:	31 d2                	xor    %edx,%edx
80101c3a:	89 f8                	mov    %edi,%eax
80101c3c:	01 f0                	add    %esi,%eax
80101c3e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101c41:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101c46:	0f 87 d0 00 00 00    	ja     80101d1c <writei+0x11c>
80101c4c:	85 d2                	test   %edx,%edx
80101c4e:	0f 85 c8 00 00 00    	jne    80101d1c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c54:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101c5b:	85 ff                	test   %edi,%edi
80101c5d:	74 72                	je     80101cd1 <writei+0xd1>
80101c5f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c60:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101c63:	89 f2                	mov    %esi,%edx
80101c65:	c1 ea 09             	shr    $0x9,%edx
80101c68:	89 f8                	mov    %edi,%eax
80101c6a:	e8 51 f8 ff ff       	call   801014c0 <bmap>
80101c6f:	83 ec 08             	sub    $0x8,%esp
80101c72:	50                   	push   %eax
80101c73:	ff 37                	push   (%edi)
80101c75:	e8 56 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c7a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c7f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c82:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c85:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c87:	89 f0                	mov    %esi,%eax
80101c89:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c8e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c90:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c94:	39 d9                	cmp    %ebx,%ecx
80101c96:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c99:	83 c4 0c             	add    $0xc,%esp
80101c9c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c9d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c9f:	ff 75 dc             	push   -0x24(%ebp)
80101ca2:	50                   	push   %eax
80101ca3:	e8 58 36 00 00       	call   80105300 <memmove>
    log_write(bp);
80101ca8:	89 3c 24             	mov    %edi,(%esp)
80101cab:	e8 00 13 00 00       	call   80102fb0 <log_write>
    brelse(bp);
80101cb0:	89 3c 24             	mov    %edi,(%esp)
80101cb3:	e8 38 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cb8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101cbb:	83 c4 10             	add    $0x10,%esp
80101cbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101cc1:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101cc4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101cc7:	77 97                	ja     80101c60 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101cc9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101ccc:	3b 70 58             	cmp    0x58(%eax),%esi
80101ccf:	77 37                	ja     80101d08 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101cd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101cd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cd7:	5b                   	pop    %ebx
80101cd8:	5e                   	pop    %esi
80101cd9:	5f                   	pop    %edi
80101cda:	5d                   	pop    %ebp
80101cdb:	c3                   	ret    
80101cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101ce0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101ce4:	66 83 f8 09          	cmp    $0x9,%ax
80101ce8:	77 32                	ja     80101d1c <writei+0x11c>
80101cea:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101cf1:	85 c0                	test   %eax,%eax
80101cf3:	74 27                	je     80101d1c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101cf5:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101cf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cfb:	5b                   	pop    %ebx
80101cfc:	5e                   	pop    %esi
80101cfd:	5f                   	pop    %edi
80101cfe:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101cff:	ff e0                	jmp    *%eax
80101d01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101d08:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101d0b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101d0e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101d11:	50                   	push   %eax
80101d12:	e8 29 fa ff ff       	call   80101740 <iupdate>
80101d17:	83 c4 10             	add    $0x10,%esp
80101d1a:	eb b5                	jmp    80101cd1 <writei+0xd1>
      return -1;
80101d1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d21:	eb b1                	jmp    80101cd4 <writei+0xd4>
80101d23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101d30 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101d30:	55                   	push   %ebp
80101d31:	89 e5                	mov    %esp,%ebp
80101d33:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101d36:	6a 0e                	push   $0xe
80101d38:	ff 75 0c             	push   0xc(%ebp)
80101d3b:	ff 75 08             	push   0x8(%ebp)
80101d3e:	e8 2d 36 00 00       	call   80105370 <strncmp>
}
80101d43:	c9                   	leave  
80101d44:	c3                   	ret    
80101d45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101d50 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101d50:	55                   	push   %ebp
80101d51:	89 e5                	mov    %esp,%ebp
80101d53:	57                   	push   %edi
80101d54:	56                   	push   %esi
80101d55:	53                   	push   %ebx
80101d56:	83 ec 1c             	sub    $0x1c,%esp
80101d59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d5c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d61:	0f 85 85 00 00 00    	jne    80101dec <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d67:	8b 53 58             	mov    0x58(%ebx),%edx
80101d6a:	31 ff                	xor    %edi,%edi
80101d6c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d6f:	85 d2                	test   %edx,%edx
80101d71:	74 3e                	je     80101db1 <dirlookup+0x61>
80101d73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d77:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d78:	6a 10                	push   $0x10
80101d7a:	57                   	push   %edi
80101d7b:	56                   	push   %esi
80101d7c:	53                   	push   %ebx
80101d7d:	e8 7e fd ff ff       	call   80101b00 <readi>
80101d82:	83 c4 10             	add    $0x10,%esp
80101d85:	83 f8 10             	cmp    $0x10,%eax
80101d88:	75 55                	jne    80101ddf <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d8a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d8f:	74 18                	je     80101da9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d91:	83 ec 04             	sub    $0x4,%esp
80101d94:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d97:	6a 0e                	push   $0xe
80101d99:	50                   	push   %eax
80101d9a:	ff 75 0c             	push   0xc(%ebp)
80101d9d:	e8 ce 35 00 00       	call   80105370 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101da2:	83 c4 10             	add    $0x10,%esp
80101da5:	85 c0                	test   %eax,%eax
80101da7:	74 17                	je     80101dc0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101da9:	83 c7 10             	add    $0x10,%edi
80101dac:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101daf:	72 c7                	jb     80101d78 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101db1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101db4:	31 c0                	xor    %eax,%eax
}
80101db6:	5b                   	pop    %ebx
80101db7:	5e                   	pop    %esi
80101db8:	5f                   	pop    %edi
80101db9:	5d                   	pop    %ebp
80101dba:	c3                   	ret    
80101dbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101dbf:	90                   	nop
      if(poff)
80101dc0:	8b 45 10             	mov    0x10(%ebp),%eax
80101dc3:	85 c0                	test   %eax,%eax
80101dc5:	74 05                	je     80101dcc <dirlookup+0x7c>
        *poff = off;
80101dc7:	8b 45 10             	mov    0x10(%ebp),%eax
80101dca:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101dcc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101dd0:	8b 03                	mov    (%ebx),%eax
80101dd2:	e8 e9 f5 ff ff       	call   801013c0 <iget>
}
80101dd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dda:	5b                   	pop    %ebx
80101ddb:	5e                   	pop    %esi
80101ddc:	5f                   	pop    %edi
80101ddd:	5d                   	pop    %ebp
80101dde:	c3                   	ret    
      panic("dirlookup read");
80101ddf:	83 ec 0c             	sub    $0xc,%esp
80101de2:	68 21 7f 10 80       	push   $0x80107f21
80101de7:	e8 94 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101dec:	83 ec 0c             	sub    $0xc,%esp
80101def:	68 0f 7f 10 80       	push   $0x80107f0f
80101df4:	e8 87 e5 ff ff       	call   80100380 <panic>
80101df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e00 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101e00:	55                   	push   %ebp
80101e01:	89 e5                	mov    %esp,%ebp
80101e03:	57                   	push   %edi
80101e04:	56                   	push   %esi
80101e05:	53                   	push   %ebx
80101e06:	89 c3                	mov    %eax,%ebx
80101e08:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101e0b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101e0e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e11:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101e14:	0f 84 64 01 00 00    	je     80101f7e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101e1a:	e8 11 1c 00 00       	call   80103a30 <myproc>
  acquire(&icache.lock);
80101e1f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101e22:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101e25:	68 60 09 11 80       	push   $0x80110960
80101e2a:	e8 71 33 00 00       	call   801051a0 <acquire>
  ip->ref++;
80101e2f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101e33:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101e3a:	e8 01 33 00 00       	call   80105140 <release>
80101e3f:	83 c4 10             	add    $0x10,%esp
80101e42:	eb 07                	jmp    80101e4b <namex+0x4b>
80101e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e48:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e4b:	0f b6 03             	movzbl (%ebx),%eax
80101e4e:	3c 2f                	cmp    $0x2f,%al
80101e50:	74 f6                	je     80101e48 <namex+0x48>
  if(*path == 0)
80101e52:	84 c0                	test   %al,%al
80101e54:	0f 84 06 01 00 00    	je     80101f60 <namex+0x160>
  while(*path != '/' && *path != 0)
80101e5a:	0f b6 03             	movzbl (%ebx),%eax
80101e5d:	84 c0                	test   %al,%al
80101e5f:	0f 84 10 01 00 00    	je     80101f75 <namex+0x175>
80101e65:	89 df                	mov    %ebx,%edi
80101e67:	3c 2f                	cmp    $0x2f,%al
80101e69:	0f 84 06 01 00 00    	je     80101f75 <namex+0x175>
80101e6f:	90                   	nop
80101e70:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e74:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e77:	3c 2f                	cmp    $0x2f,%al
80101e79:	74 04                	je     80101e7f <namex+0x7f>
80101e7b:	84 c0                	test   %al,%al
80101e7d:	75 f1                	jne    80101e70 <namex+0x70>
  len = path - s;
80101e7f:	89 f8                	mov    %edi,%eax
80101e81:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e83:	83 f8 0d             	cmp    $0xd,%eax
80101e86:	0f 8e ac 00 00 00    	jle    80101f38 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e8c:	83 ec 04             	sub    $0x4,%esp
80101e8f:	6a 0e                	push   $0xe
80101e91:	53                   	push   %ebx
    path++;
80101e92:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e94:	ff 75 e4             	push   -0x1c(%ebp)
80101e97:	e8 64 34 00 00       	call   80105300 <memmove>
80101e9c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e9f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101ea2:	75 0c                	jne    80101eb0 <namex+0xb0>
80101ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101ea8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101eab:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101eae:	74 f8                	je     80101ea8 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101eb0:	83 ec 0c             	sub    $0xc,%esp
80101eb3:	56                   	push   %esi
80101eb4:	e8 37 f9 ff ff       	call   801017f0 <ilock>
    if(ip->type != T_DIR){
80101eb9:	83 c4 10             	add    $0x10,%esp
80101ebc:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101ec1:	0f 85 cd 00 00 00    	jne    80101f94 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101ec7:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101eca:	85 c0                	test   %eax,%eax
80101ecc:	74 09                	je     80101ed7 <namex+0xd7>
80101ece:	80 3b 00             	cmpb   $0x0,(%ebx)
80101ed1:	0f 84 22 01 00 00    	je     80101ff9 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101ed7:	83 ec 04             	sub    $0x4,%esp
80101eda:	6a 00                	push   $0x0
80101edc:	ff 75 e4             	push   -0x1c(%ebp)
80101edf:	56                   	push   %esi
80101ee0:	e8 6b fe ff ff       	call   80101d50 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ee5:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101ee8:	83 c4 10             	add    $0x10,%esp
80101eeb:	89 c7                	mov    %eax,%edi
80101eed:	85 c0                	test   %eax,%eax
80101eef:	0f 84 e1 00 00 00    	je     80101fd6 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ef5:	83 ec 0c             	sub    $0xc,%esp
80101ef8:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101efb:	52                   	push   %edx
80101efc:	e8 7f 30 00 00       	call   80104f80 <holdingsleep>
80101f01:	83 c4 10             	add    $0x10,%esp
80101f04:	85 c0                	test   %eax,%eax
80101f06:	0f 84 30 01 00 00    	je     8010203c <namex+0x23c>
80101f0c:	8b 56 08             	mov    0x8(%esi),%edx
80101f0f:	85 d2                	test   %edx,%edx
80101f11:	0f 8e 25 01 00 00    	jle    8010203c <namex+0x23c>
  releasesleep(&ip->lock);
80101f17:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101f1a:	83 ec 0c             	sub    $0xc,%esp
80101f1d:	52                   	push   %edx
80101f1e:	e8 1d 30 00 00       	call   80104f40 <releasesleep>
  iput(ip);
80101f23:	89 34 24             	mov    %esi,(%esp)
80101f26:	89 fe                	mov    %edi,%esi
80101f28:	e8 f3 f9 ff ff       	call   80101920 <iput>
80101f2d:	83 c4 10             	add    $0x10,%esp
80101f30:	e9 16 ff ff ff       	jmp    80101e4b <namex+0x4b>
80101f35:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101f38:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101f3b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101f3e:	83 ec 04             	sub    $0x4,%esp
80101f41:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101f44:	50                   	push   %eax
80101f45:	53                   	push   %ebx
    name[len] = 0;
80101f46:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101f48:	ff 75 e4             	push   -0x1c(%ebp)
80101f4b:	e8 b0 33 00 00       	call   80105300 <memmove>
    name[len] = 0;
80101f50:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101f53:	83 c4 10             	add    $0x10,%esp
80101f56:	c6 02 00             	movb   $0x0,(%edx)
80101f59:	e9 41 ff ff ff       	jmp    80101e9f <namex+0x9f>
80101f5e:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101f60:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f63:	85 c0                	test   %eax,%eax
80101f65:	0f 85 be 00 00 00    	jne    80102029 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f6e:	89 f0                	mov    %esi,%eax
80101f70:	5b                   	pop    %ebx
80101f71:	5e                   	pop    %esi
80101f72:	5f                   	pop    %edi
80101f73:	5d                   	pop    %ebp
80101f74:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101f75:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f78:	89 df                	mov    %ebx,%edi
80101f7a:	31 c0                	xor    %eax,%eax
80101f7c:	eb c0                	jmp    80101f3e <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f7e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f83:	b8 01 00 00 00       	mov    $0x1,%eax
80101f88:	e8 33 f4 ff ff       	call   801013c0 <iget>
80101f8d:	89 c6                	mov    %eax,%esi
80101f8f:	e9 b7 fe ff ff       	jmp    80101e4b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f94:	83 ec 0c             	sub    $0xc,%esp
80101f97:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f9a:	53                   	push   %ebx
80101f9b:	e8 e0 2f 00 00       	call   80104f80 <holdingsleep>
80101fa0:	83 c4 10             	add    $0x10,%esp
80101fa3:	85 c0                	test   %eax,%eax
80101fa5:	0f 84 91 00 00 00    	je     8010203c <namex+0x23c>
80101fab:	8b 46 08             	mov    0x8(%esi),%eax
80101fae:	85 c0                	test   %eax,%eax
80101fb0:	0f 8e 86 00 00 00    	jle    8010203c <namex+0x23c>
  releasesleep(&ip->lock);
80101fb6:	83 ec 0c             	sub    $0xc,%esp
80101fb9:	53                   	push   %ebx
80101fba:	e8 81 2f 00 00       	call   80104f40 <releasesleep>
  iput(ip);
80101fbf:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101fc2:	31 f6                	xor    %esi,%esi
  iput(ip);
80101fc4:	e8 57 f9 ff ff       	call   80101920 <iput>
      return 0;
80101fc9:	83 c4 10             	add    $0x10,%esp
}
80101fcc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fcf:	89 f0                	mov    %esi,%eax
80101fd1:	5b                   	pop    %ebx
80101fd2:	5e                   	pop    %esi
80101fd3:	5f                   	pop    %edi
80101fd4:	5d                   	pop    %ebp
80101fd5:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101fd6:	83 ec 0c             	sub    $0xc,%esp
80101fd9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101fdc:	52                   	push   %edx
80101fdd:	e8 9e 2f 00 00       	call   80104f80 <holdingsleep>
80101fe2:	83 c4 10             	add    $0x10,%esp
80101fe5:	85 c0                	test   %eax,%eax
80101fe7:	74 53                	je     8010203c <namex+0x23c>
80101fe9:	8b 4e 08             	mov    0x8(%esi),%ecx
80101fec:	85 c9                	test   %ecx,%ecx
80101fee:	7e 4c                	jle    8010203c <namex+0x23c>
  releasesleep(&ip->lock);
80101ff0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101ff3:	83 ec 0c             	sub    $0xc,%esp
80101ff6:	52                   	push   %edx
80101ff7:	eb c1                	jmp    80101fba <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ff9:	83 ec 0c             	sub    $0xc,%esp
80101ffc:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101fff:	53                   	push   %ebx
80102000:	e8 7b 2f 00 00       	call   80104f80 <holdingsleep>
80102005:	83 c4 10             	add    $0x10,%esp
80102008:	85 c0                	test   %eax,%eax
8010200a:	74 30                	je     8010203c <namex+0x23c>
8010200c:	8b 7e 08             	mov    0x8(%esi),%edi
8010200f:	85 ff                	test   %edi,%edi
80102011:	7e 29                	jle    8010203c <namex+0x23c>
  releasesleep(&ip->lock);
80102013:	83 ec 0c             	sub    $0xc,%esp
80102016:	53                   	push   %ebx
80102017:	e8 24 2f 00 00       	call   80104f40 <releasesleep>
}
8010201c:	83 c4 10             	add    $0x10,%esp
}
8010201f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102022:	89 f0                	mov    %esi,%eax
80102024:	5b                   	pop    %ebx
80102025:	5e                   	pop    %esi
80102026:	5f                   	pop    %edi
80102027:	5d                   	pop    %ebp
80102028:	c3                   	ret    
    iput(ip);
80102029:	83 ec 0c             	sub    $0xc,%esp
8010202c:	56                   	push   %esi
    return 0;
8010202d:	31 f6                	xor    %esi,%esi
    iput(ip);
8010202f:	e8 ec f8 ff ff       	call   80101920 <iput>
    return 0;
80102034:	83 c4 10             	add    $0x10,%esp
80102037:	e9 2f ff ff ff       	jmp    80101f6b <namex+0x16b>
    panic("iunlock");
8010203c:	83 ec 0c             	sub    $0xc,%esp
8010203f:	68 07 7f 10 80       	push   $0x80107f07
80102044:	e8 37 e3 ff ff       	call   80100380 <panic>
80102049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102050 <dirlink>:
{
80102050:	55                   	push   %ebp
80102051:	89 e5                	mov    %esp,%ebp
80102053:	57                   	push   %edi
80102054:	56                   	push   %esi
80102055:	53                   	push   %ebx
80102056:	83 ec 20             	sub    $0x20,%esp
80102059:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010205c:	6a 00                	push   $0x0
8010205e:	ff 75 0c             	push   0xc(%ebp)
80102061:	53                   	push   %ebx
80102062:	e8 e9 fc ff ff       	call   80101d50 <dirlookup>
80102067:	83 c4 10             	add    $0x10,%esp
8010206a:	85 c0                	test   %eax,%eax
8010206c:	75 67                	jne    801020d5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010206e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102071:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102074:	85 ff                	test   %edi,%edi
80102076:	74 29                	je     801020a1 <dirlink+0x51>
80102078:	31 ff                	xor    %edi,%edi
8010207a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010207d:	eb 09                	jmp    80102088 <dirlink+0x38>
8010207f:	90                   	nop
80102080:	83 c7 10             	add    $0x10,%edi
80102083:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102086:	73 19                	jae    801020a1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102088:	6a 10                	push   $0x10
8010208a:	57                   	push   %edi
8010208b:	56                   	push   %esi
8010208c:	53                   	push   %ebx
8010208d:	e8 6e fa ff ff       	call   80101b00 <readi>
80102092:	83 c4 10             	add    $0x10,%esp
80102095:	83 f8 10             	cmp    $0x10,%eax
80102098:	75 4e                	jne    801020e8 <dirlink+0x98>
    if(de.inum == 0)
8010209a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010209f:	75 df                	jne    80102080 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
801020a1:	83 ec 04             	sub    $0x4,%esp
801020a4:	8d 45 da             	lea    -0x26(%ebp),%eax
801020a7:	6a 0e                	push   $0xe
801020a9:	ff 75 0c             	push   0xc(%ebp)
801020ac:	50                   	push   %eax
801020ad:	e8 0e 33 00 00       	call   801053c0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020b2:	6a 10                	push   $0x10
  de.inum = inum;
801020b4:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020b7:	57                   	push   %edi
801020b8:	56                   	push   %esi
801020b9:	53                   	push   %ebx
  de.inum = inum;
801020ba:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020be:	e8 3d fb ff ff       	call   80101c00 <writei>
801020c3:	83 c4 20             	add    $0x20,%esp
801020c6:	83 f8 10             	cmp    $0x10,%eax
801020c9:	75 2a                	jne    801020f5 <dirlink+0xa5>
  return 0;
801020cb:	31 c0                	xor    %eax,%eax
}
801020cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020d0:	5b                   	pop    %ebx
801020d1:	5e                   	pop    %esi
801020d2:	5f                   	pop    %edi
801020d3:	5d                   	pop    %ebp
801020d4:	c3                   	ret    
    iput(ip);
801020d5:	83 ec 0c             	sub    $0xc,%esp
801020d8:	50                   	push   %eax
801020d9:	e8 42 f8 ff ff       	call   80101920 <iput>
    return -1;
801020de:	83 c4 10             	add    $0x10,%esp
801020e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020e6:	eb e5                	jmp    801020cd <dirlink+0x7d>
      panic("dirlink read");
801020e8:	83 ec 0c             	sub    $0xc,%esp
801020eb:	68 30 7f 10 80       	push   $0x80107f30
801020f0:	e8 8b e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
801020f5:	83 ec 0c             	sub    $0xc,%esp
801020f8:	68 0a 87 10 80       	push   $0x8010870a
801020fd:	e8 7e e2 ff ff       	call   80100380 <panic>
80102102:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102110 <namei>:

struct inode*
namei(char *path)
{
80102110:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102111:	31 d2                	xor    %edx,%edx
{
80102113:	89 e5                	mov    %esp,%ebp
80102115:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102118:	8b 45 08             	mov    0x8(%ebp),%eax
8010211b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010211e:	e8 dd fc ff ff       	call   80101e00 <namex>
}
80102123:	c9                   	leave  
80102124:	c3                   	ret    
80102125:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010212c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102130 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102130:	55                   	push   %ebp
  return namex(path, 1, name);
80102131:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102136:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102138:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010213b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010213e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010213f:	e9 bc fc ff ff       	jmp    80101e00 <namex>
80102144:	66 90                	xchg   %ax,%ax
80102146:	66 90                	xchg   %ax,%ax
80102148:	66 90                	xchg   %ax,%ax
8010214a:	66 90                	xchg   %ax,%ax
8010214c:	66 90                	xchg   %ax,%ax
8010214e:	66 90                	xchg   %ax,%ax

80102150 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102150:	55                   	push   %ebp
80102151:	89 e5                	mov    %esp,%ebp
80102153:	57                   	push   %edi
80102154:	56                   	push   %esi
80102155:	53                   	push   %ebx
80102156:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102159:	85 c0                	test   %eax,%eax
8010215b:	0f 84 b4 00 00 00    	je     80102215 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102161:	8b 70 08             	mov    0x8(%eax),%esi
80102164:	89 c3                	mov    %eax,%ebx
80102166:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010216c:	0f 87 96 00 00 00    	ja     80102208 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102172:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102177:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010217e:	66 90                	xchg   %ax,%ax
80102180:	89 ca                	mov    %ecx,%edx
80102182:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102183:	83 e0 c0             	and    $0xffffffc0,%eax
80102186:	3c 40                	cmp    $0x40,%al
80102188:	75 f6                	jne    80102180 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010218a:	31 ff                	xor    %edi,%edi
8010218c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102191:	89 f8                	mov    %edi,%eax
80102193:	ee                   	out    %al,(%dx)
80102194:	b8 01 00 00 00       	mov    $0x1,%eax
80102199:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010219e:	ee                   	out    %al,(%dx)
8010219f:	ba f3 01 00 00       	mov    $0x1f3,%edx
801021a4:	89 f0                	mov    %esi,%eax
801021a6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801021a7:	89 f0                	mov    %esi,%eax
801021a9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801021ae:	c1 f8 08             	sar    $0x8,%eax
801021b1:	ee                   	out    %al,(%dx)
801021b2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801021b7:	89 f8                	mov    %edi,%eax
801021b9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801021ba:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801021be:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021c3:	c1 e0 04             	shl    $0x4,%eax
801021c6:	83 e0 10             	and    $0x10,%eax
801021c9:	83 c8 e0             	or     $0xffffffe0,%eax
801021cc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801021cd:	f6 03 04             	testb  $0x4,(%ebx)
801021d0:	75 16                	jne    801021e8 <idestart+0x98>
801021d2:	b8 20 00 00 00       	mov    $0x20,%eax
801021d7:	89 ca                	mov    %ecx,%edx
801021d9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801021da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021dd:	5b                   	pop    %ebx
801021de:	5e                   	pop    %esi
801021df:	5f                   	pop    %edi
801021e0:	5d                   	pop    %ebp
801021e1:	c3                   	ret    
801021e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801021e8:	b8 30 00 00 00       	mov    $0x30,%eax
801021ed:	89 ca                	mov    %ecx,%edx
801021ef:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801021f0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801021f5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801021f8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021fd:	fc                   	cld    
801021fe:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102200:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102203:	5b                   	pop    %ebx
80102204:	5e                   	pop    %esi
80102205:	5f                   	pop    %edi
80102206:	5d                   	pop    %ebp
80102207:	c3                   	ret    
    panic("incorrect blockno");
80102208:	83 ec 0c             	sub    $0xc,%esp
8010220b:	68 9c 7f 10 80       	push   $0x80107f9c
80102210:	e8 6b e1 ff ff       	call   80100380 <panic>
    panic("idestart");
80102215:	83 ec 0c             	sub    $0xc,%esp
80102218:	68 93 7f 10 80       	push   $0x80107f93
8010221d:	e8 5e e1 ff ff       	call   80100380 <panic>
80102222:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102230 <ideinit>:
{
80102230:	55                   	push   %ebp
80102231:	89 e5                	mov    %esp,%ebp
80102233:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102236:	68 ae 7f 10 80       	push   $0x80107fae
8010223b:	68 00 26 11 80       	push   $0x80112600
80102240:	e8 8b 2d 00 00       	call   80104fd0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102245:	58                   	pop    %eax
80102246:	a1 84 27 11 80       	mov    0x80112784,%eax
8010224b:	5a                   	pop    %edx
8010224c:	83 e8 01             	sub    $0x1,%eax
8010224f:	50                   	push   %eax
80102250:	6a 0e                	push   $0xe
80102252:	e8 99 02 00 00       	call   801024f0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102257:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010225a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010225f:	90                   	nop
80102260:	ec                   	in     (%dx),%al
80102261:	83 e0 c0             	and    $0xffffffc0,%eax
80102264:	3c 40                	cmp    $0x40,%al
80102266:	75 f8                	jne    80102260 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102268:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010226d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102272:	ee                   	out    %al,(%dx)
80102273:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102278:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010227d:	eb 06                	jmp    80102285 <ideinit+0x55>
8010227f:	90                   	nop
  for(i=0; i<1000; i++){
80102280:	83 e9 01             	sub    $0x1,%ecx
80102283:	74 0f                	je     80102294 <ideinit+0x64>
80102285:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102286:	84 c0                	test   %al,%al
80102288:	74 f6                	je     80102280 <ideinit+0x50>
      havedisk1 = 1;
8010228a:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
80102291:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102294:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102299:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010229e:	ee                   	out    %al,(%dx)
}
8010229f:	c9                   	leave  
801022a0:	c3                   	ret    
801022a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022af:	90                   	nop

801022b0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801022b0:	55                   	push   %ebp
801022b1:	89 e5                	mov    %esp,%ebp
801022b3:	57                   	push   %edi
801022b4:	56                   	push   %esi
801022b5:	53                   	push   %ebx
801022b6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801022b9:	68 00 26 11 80       	push   $0x80112600
801022be:	e8 dd 2e 00 00       	call   801051a0 <acquire>

  if((b = idequeue) == 0){
801022c3:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
801022c9:	83 c4 10             	add    $0x10,%esp
801022cc:	85 db                	test   %ebx,%ebx
801022ce:	74 63                	je     80102333 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801022d0:	8b 43 58             	mov    0x58(%ebx),%eax
801022d3:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801022d8:	8b 33                	mov    (%ebx),%esi
801022da:	f7 c6 04 00 00 00    	test   $0x4,%esi
801022e0:	75 2f                	jne    80102311 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022e2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022ee:	66 90                	xchg   %ax,%ax
801022f0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022f1:	89 c1                	mov    %eax,%ecx
801022f3:	83 e1 c0             	and    $0xffffffc0,%ecx
801022f6:	80 f9 40             	cmp    $0x40,%cl
801022f9:	75 f5                	jne    801022f0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801022fb:	a8 21                	test   $0x21,%al
801022fd:	75 12                	jne    80102311 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801022ff:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102302:	b9 80 00 00 00       	mov    $0x80,%ecx
80102307:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010230c:	fc                   	cld    
8010230d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010230f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102311:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102314:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102317:	83 ce 02             	or     $0x2,%esi
8010231a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010231c:	53                   	push   %ebx
8010231d:	e8 7e 21 00 00       	call   801044a0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102322:	a1 e4 25 11 80       	mov    0x801125e4,%eax
80102327:	83 c4 10             	add    $0x10,%esp
8010232a:	85 c0                	test   %eax,%eax
8010232c:	74 05                	je     80102333 <ideintr+0x83>
    idestart(idequeue);
8010232e:	e8 1d fe ff ff       	call   80102150 <idestart>
    release(&idelock);
80102333:	83 ec 0c             	sub    $0xc,%esp
80102336:	68 00 26 11 80       	push   $0x80112600
8010233b:	e8 00 2e 00 00       	call   80105140 <release>

  release(&idelock);
}
80102340:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102343:	5b                   	pop    %ebx
80102344:	5e                   	pop    %esi
80102345:	5f                   	pop    %edi
80102346:	5d                   	pop    %ebp
80102347:	c3                   	ret    
80102348:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010234f:	90                   	nop

80102350 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102350:	55                   	push   %ebp
80102351:	89 e5                	mov    %esp,%ebp
80102353:	53                   	push   %ebx
80102354:	83 ec 10             	sub    $0x10,%esp
80102357:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010235a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010235d:	50                   	push   %eax
8010235e:	e8 1d 2c 00 00       	call   80104f80 <holdingsleep>
80102363:	83 c4 10             	add    $0x10,%esp
80102366:	85 c0                	test   %eax,%eax
80102368:	0f 84 c3 00 00 00    	je     80102431 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010236e:	8b 03                	mov    (%ebx),%eax
80102370:	83 e0 06             	and    $0x6,%eax
80102373:	83 f8 02             	cmp    $0x2,%eax
80102376:	0f 84 a8 00 00 00    	je     80102424 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010237c:	8b 53 04             	mov    0x4(%ebx),%edx
8010237f:	85 d2                	test   %edx,%edx
80102381:	74 0d                	je     80102390 <iderw+0x40>
80102383:	a1 e0 25 11 80       	mov    0x801125e0,%eax
80102388:	85 c0                	test   %eax,%eax
8010238a:	0f 84 87 00 00 00    	je     80102417 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102390:	83 ec 0c             	sub    $0xc,%esp
80102393:	68 00 26 11 80       	push   $0x80112600
80102398:	e8 03 2e 00 00       	call   801051a0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010239d:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
801023a2:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023a9:	83 c4 10             	add    $0x10,%esp
801023ac:	85 c0                	test   %eax,%eax
801023ae:	74 60                	je     80102410 <iderw+0xc0>
801023b0:	89 c2                	mov    %eax,%edx
801023b2:	8b 40 58             	mov    0x58(%eax),%eax
801023b5:	85 c0                	test   %eax,%eax
801023b7:	75 f7                	jne    801023b0 <iderw+0x60>
801023b9:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801023bc:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801023be:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
801023c4:	74 3a                	je     80102400 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023c6:	8b 03                	mov    (%ebx),%eax
801023c8:	83 e0 06             	and    $0x6,%eax
801023cb:	83 f8 02             	cmp    $0x2,%eax
801023ce:	74 1b                	je     801023eb <iderw+0x9b>
    sleep(b, &idelock);
801023d0:	83 ec 08             	sub    $0x8,%esp
801023d3:	68 00 26 11 80       	push   $0x80112600
801023d8:	53                   	push   %ebx
801023d9:	e8 02 20 00 00       	call   801043e0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023de:	8b 03                	mov    (%ebx),%eax
801023e0:	83 c4 10             	add    $0x10,%esp
801023e3:	83 e0 06             	and    $0x6,%eax
801023e6:	83 f8 02             	cmp    $0x2,%eax
801023e9:	75 e5                	jne    801023d0 <iderw+0x80>
  }


  release(&idelock);
801023eb:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
801023f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023f5:	c9                   	leave  
  release(&idelock);
801023f6:	e9 45 2d 00 00       	jmp    80105140 <release>
801023fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023ff:	90                   	nop
    idestart(b);
80102400:	89 d8                	mov    %ebx,%eax
80102402:	e8 49 fd ff ff       	call   80102150 <idestart>
80102407:	eb bd                	jmp    801023c6 <iderw+0x76>
80102409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102410:	ba e4 25 11 80       	mov    $0x801125e4,%edx
80102415:	eb a5                	jmp    801023bc <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102417:	83 ec 0c             	sub    $0xc,%esp
8010241a:	68 dd 7f 10 80       	push   $0x80107fdd
8010241f:	e8 5c df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
80102424:	83 ec 0c             	sub    $0xc,%esp
80102427:	68 c8 7f 10 80       	push   $0x80107fc8
8010242c:	e8 4f df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
80102431:	83 ec 0c             	sub    $0xc,%esp
80102434:	68 b2 7f 10 80       	push   $0x80107fb2
80102439:	e8 42 df ff ff       	call   80100380 <panic>
8010243e:	66 90                	xchg   %ax,%ax

80102440 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102440:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102441:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
80102448:	00 c0 fe 
{
8010244b:	89 e5                	mov    %esp,%ebp
8010244d:	56                   	push   %esi
8010244e:	53                   	push   %ebx
  ioapic->reg = reg;
8010244f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102456:	00 00 00 
  return ioapic->data;
80102459:	8b 15 34 26 11 80    	mov    0x80112634,%edx
8010245f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102462:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102468:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010246e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102475:	c1 ee 10             	shr    $0x10,%esi
80102478:	89 f0                	mov    %esi,%eax
8010247a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010247d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102480:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102483:	39 c2                	cmp    %eax,%edx
80102485:	74 16                	je     8010249d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102487:	83 ec 0c             	sub    $0xc,%esp
8010248a:	68 fc 7f 10 80       	push   $0x80107ffc
8010248f:	e8 0c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102494:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010249a:	83 c4 10             	add    $0x10,%esp
8010249d:	83 c6 21             	add    $0x21,%esi
{
801024a0:	ba 10 00 00 00       	mov    $0x10,%edx
801024a5:	b8 20 00 00 00       	mov    $0x20,%eax
801024aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
801024b0:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801024b2:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
801024b4:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
801024ba:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801024bd:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
801024c3:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
801024c6:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
801024c9:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
801024cc:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
801024ce:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801024d4:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801024db:	39 f0                	cmp    %esi,%eax
801024dd:	75 d1                	jne    801024b0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801024df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024e2:	5b                   	pop    %ebx
801024e3:	5e                   	pop    %esi
801024e4:	5d                   	pop    %ebp
801024e5:	c3                   	ret    
801024e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024ed:	8d 76 00             	lea    0x0(%esi),%esi

801024f0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801024f0:	55                   	push   %ebp
  ioapic->reg = reg;
801024f1:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
801024f7:	89 e5                	mov    %esp,%ebp
801024f9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801024fc:	8d 50 20             	lea    0x20(%eax),%edx
801024ff:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102503:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102505:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010250b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010250e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102511:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102514:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102516:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010251b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010251e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102521:	5d                   	pop    %ebp
80102522:	c3                   	ret    
80102523:	66 90                	xchg   %ax,%ax
80102525:	66 90                	xchg   %ax,%ax
80102527:	66 90                	xchg   %ax,%ax
80102529:	66 90                	xchg   %ax,%ax
8010252b:	66 90                	xchg   %ax,%ax
8010252d:	66 90                	xchg   %ax,%ax
8010252f:	90                   	nop

80102530 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102530:	55                   	push   %ebp
80102531:	89 e5                	mov    %esp,%ebp
80102533:	53                   	push   %ebx
80102534:	83 ec 04             	sub    $0x4,%esp
80102537:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010253a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102540:	75 76                	jne    801025b8 <kfree+0x88>
80102542:	81 fb f0 73 11 80    	cmp    $0x801173f0,%ebx
80102548:	72 6e                	jb     801025b8 <kfree+0x88>
8010254a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102550:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102555:	77 61                	ja     801025b8 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102557:	83 ec 04             	sub    $0x4,%esp
8010255a:	68 00 10 00 00       	push   $0x1000
8010255f:	6a 01                	push   $0x1
80102561:	53                   	push   %ebx
80102562:	e8 f9 2c 00 00       	call   80105260 <memset>

  if(kmem.use_lock)
80102567:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010256d:	83 c4 10             	add    $0x10,%esp
80102570:	85 d2                	test   %edx,%edx
80102572:	75 1c                	jne    80102590 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102574:	a1 78 26 11 80       	mov    0x80112678,%eax
80102579:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010257b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102580:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102586:	85 c0                	test   %eax,%eax
80102588:	75 1e                	jne    801025a8 <kfree+0x78>
    release(&kmem.lock);
}
8010258a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010258d:	c9                   	leave  
8010258e:	c3                   	ret    
8010258f:	90                   	nop
    acquire(&kmem.lock);
80102590:	83 ec 0c             	sub    $0xc,%esp
80102593:	68 40 26 11 80       	push   $0x80112640
80102598:	e8 03 2c 00 00       	call   801051a0 <acquire>
8010259d:	83 c4 10             	add    $0x10,%esp
801025a0:	eb d2                	jmp    80102574 <kfree+0x44>
801025a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801025a8:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
801025af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025b2:	c9                   	leave  
    release(&kmem.lock);
801025b3:	e9 88 2b 00 00       	jmp    80105140 <release>
    panic("kfree");
801025b8:	83 ec 0c             	sub    $0xc,%esp
801025bb:	68 2e 80 10 80       	push   $0x8010802e
801025c0:	e8 bb dd ff ff       	call   80100380 <panic>
801025c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801025d0 <freerange>:
{
801025d0:	55                   	push   %ebp
801025d1:	89 e5                	mov    %esp,%ebp
801025d3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025d4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025d7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025da:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025db:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025e1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025e7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025ed:	39 de                	cmp    %ebx,%esi
801025ef:	72 23                	jb     80102614 <freerange+0x44>
801025f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025f8:	83 ec 0c             	sub    $0xc,%esp
801025fb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102601:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102607:	50                   	push   %eax
80102608:	e8 23 ff ff ff       	call   80102530 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010260d:	83 c4 10             	add    $0x10,%esp
80102610:	39 f3                	cmp    %esi,%ebx
80102612:	76 e4                	jbe    801025f8 <freerange+0x28>
}
80102614:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102617:	5b                   	pop    %ebx
80102618:	5e                   	pop    %esi
80102619:	5d                   	pop    %ebp
8010261a:	c3                   	ret    
8010261b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010261f:	90                   	nop

80102620 <kinit2>:
{
80102620:	55                   	push   %ebp
80102621:	89 e5                	mov    %esp,%ebp
80102623:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102624:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102627:	8b 75 0c             	mov    0xc(%ebp),%esi
8010262a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010262b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102631:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102637:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010263d:	39 de                	cmp    %ebx,%esi
8010263f:	72 23                	jb     80102664 <kinit2+0x44>
80102641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102648:	83 ec 0c             	sub    $0xc,%esp
8010264b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102651:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102657:	50                   	push   %eax
80102658:	e8 d3 fe ff ff       	call   80102530 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010265d:	83 c4 10             	add    $0x10,%esp
80102660:	39 de                	cmp    %ebx,%esi
80102662:	73 e4                	jae    80102648 <kinit2+0x28>
  kmem.use_lock = 1;
80102664:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010266b:	00 00 00 
}
8010266e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102671:	5b                   	pop    %ebx
80102672:	5e                   	pop    %esi
80102673:	5d                   	pop    %ebp
80102674:	c3                   	ret    
80102675:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010267c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102680 <kinit1>:
{
80102680:	55                   	push   %ebp
80102681:	89 e5                	mov    %esp,%ebp
80102683:	56                   	push   %esi
80102684:	53                   	push   %ebx
80102685:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102688:	83 ec 08             	sub    $0x8,%esp
8010268b:	68 34 80 10 80       	push   $0x80108034
80102690:	68 40 26 11 80       	push   $0x80112640
80102695:	e8 36 29 00 00       	call   80104fd0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010269a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010269d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801026a0:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801026a7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801026aa:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026b0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026b6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026bc:	39 de                	cmp    %ebx,%esi
801026be:	72 1c                	jb     801026dc <kinit1+0x5c>
    kfree(p);
801026c0:	83 ec 0c             	sub    $0xc,%esp
801026c3:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026c9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026cf:	50                   	push   %eax
801026d0:	e8 5b fe ff ff       	call   80102530 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026d5:	83 c4 10             	add    $0x10,%esp
801026d8:	39 de                	cmp    %ebx,%esi
801026da:	73 e4                	jae    801026c0 <kinit1+0x40>
}
801026dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026df:	5b                   	pop    %ebx
801026e0:	5e                   	pop    %esi
801026e1:	5d                   	pop    %ebp
801026e2:	c3                   	ret    
801026e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801026f0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801026f0:	a1 74 26 11 80       	mov    0x80112674,%eax
801026f5:	85 c0                	test   %eax,%eax
801026f7:	75 1f                	jne    80102718 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801026f9:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
801026fe:	85 c0                	test   %eax,%eax
80102700:	74 0e                	je     80102710 <kalloc+0x20>
    kmem.freelist = r->next;
80102702:	8b 10                	mov    (%eax),%edx
80102704:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
8010270a:	c3                   	ret    
8010270b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010270f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102710:	c3                   	ret    
80102711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102718:	55                   	push   %ebp
80102719:	89 e5                	mov    %esp,%ebp
8010271b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010271e:	68 40 26 11 80       	push   $0x80112640
80102723:	e8 78 2a 00 00       	call   801051a0 <acquire>
  r = kmem.freelist;
80102728:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(kmem.use_lock)
8010272d:	8b 15 74 26 11 80    	mov    0x80112674,%edx
  if(r)
80102733:	83 c4 10             	add    $0x10,%esp
80102736:	85 c0                	test   %eax,%eax
80102738:	74 08                	je     80102742 <kalloc+0x52>
    kmem.freelist = r->next;
8010273a:	8b 08                	mov    (%eax),%ecx
8010273c:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
80102742:	85 d2                	test   %edx,%edx
80102744:	74 16                	je     8010275c <kalloc+0x6c>
    release(&kmem.lock);
80102746:	83 ec 0c             	sub    $0xc,%esp
80102749:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010274c:	68 40 26 11 80       	push   $0x80112640
80102751:	e8 ea 29 00 00       	call   80105140 <release>
  return (char*)r;
80102756:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102759:	83 c4 10             	add    $0x10,%esp
}
8010275c:	c9                   	leave  
8010275d:	c3                   	ret    
8010275e:	66 90                	xchg   %ax,%ax

80102760 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102760:	ba 64 00 00 00       	mov    $0x64,%edx
80102765:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102766:	a8 01                	test   $0x1,%al
80102768:	0f 84 c2 00 00 00    	je     80102830 <kbdgetc+0xd0>
{
8010276e:	55                   	push   %ebp
8010276f:	ba 60 00 00 00       	mov    $0x60,%edx
80102774:	89 e5                	mov    %esp,%ebp
80102776:	53                   	push   %ebx
80102777:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102778:	8b 1d 7c 26 11 80    	mov    0x8011267c,%ebx
  data = inb(KBDATAP);
8010277e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102781:	3c e0                	cmp    $0xe0,%al
80102783:	74 5b                	je     801027e0 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102785:	89 da                	mov    %ebx,%edx
80102787:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010278a:	84 c0                	test   %al,%al
8010278c:	78 62                	js     801027f0 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010278e:	85 d2                	test   %edx,%edx
80102790:	74 09                	je     8010279b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102792:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102795:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102798:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010279b:	0f b6 91 60 81 10 80 	movzbl -0x7fef7ea0(%ecx),%edx
  shift ^= togglecode[data];
801027a2:	0f b6 81 60 80 10 80 	movzbl -0x7fef7fa0(%ecx),%eax
  shift |= shiftcode[data];
801027a9:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
801027ab:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801027ad:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
801027af:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  c = charcode[shift & (CTL | SHIFT)][data];
801027b5:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801027b8:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801027bb:	8b 04 85 40 80 10 80 	mov    -0x7fef7fc0(,%eax,4),%eax
801027c2:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801027c6:	74 0b                	je     801027d3 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
801027c8:	8d 50 9f             	lea    -0x61(%eax),%edx
801027cb:	83 fa 19             	cmp    $0x19,%edx
801027ce:	77 48                	ja     80102818 <kbdgetc+0xb8>
      c += 'A' - 'a';
801027d0:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801027d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027d6:	c9                   	leave  
801027d7:	c3                   	ret    
801027d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027df:	90                   	nop
    shift |= E0ESC;
801027e0:	83 cb 40             	or     $0x40,%ebx
    return 0;
801027e3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801027e5:	89 1d 7c 26 11 80    	mov    %ebx,0x8011267c
}
801027eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027ee:	c9                   	leave  
801027ef:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
801027f0:	83 e0 7f             	and    $0x7f,%eax
801027f3:	85 d2                	test   %edx,%edx
801027f5:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
801027f8:	0f b6 81 60 81 10 80 	movzbl -0x7fef7ea0(%ecx),%eax
801027ff:	83 c8 40             	or     $0x40,%eax
80102802:	0f b6 c0             	movzbl %al,%eax
80102805:	f7 d0                	not    %eax
80102807:	21 d8                	and    %ebx,%eax
}
80102809:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
8010280c:	a3 7c 26 11 80       	mov    %eax,0x8011267c
    return 0;
80102811:	31 c0                	xor    %eax,%eax
}
80102813:	c9                   	leave  
80102814:	c3                   	ret    
80102815:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102818:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010281b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010281e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102821:	c9                   	leave  
      c += 'a' - 'A';
80102822:	83 f9 1a             	cmp    $0x1a,%ecx
80102825:	0f 42 c2             	cmovb  %edx,%eax
}
80102828:	c3                   	ret    
80102829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102830:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102835:	c3                   	ret    
80102836:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010283d:	8d 76 00             	lea    0x0(%esi),%esi

80102840 <kbdintr>:

void
kbdintr(void)
{
80102840:	55                   	push   %ebp
80102841:	89 e5                	mov    %esp,%ebp
80102843:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102846:	68 60 27 10 80       	push   $0x80102760
8010284b:	e8 30 e0 ff ff       	call   80100880 <consoleintr>
}
80102850:	83 c4 10             	add    $0x10,%esp
80102853:	c9                   	leave  
80102854:	c3                   	ret    
80102855:	66 90                	xchg   %ax,%ax
80102857:	66 90                	xchg   %ax,%ax
80102859:	66 90                	xchg   %ax,%ax
8010285b:	66 90                	xchg   %ax,%ax
8010285d:	66 90                	xchg   %ax,%ax
8010285f:	90                   	nop

80102860 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102860:	a1 80 26 11 80       	mov    0x80112680,%eax
80102865:	85 c0                	test   %eax,%eax
80102867:	0f 84 cb 00 00 00    	je     80102938 <lapicinit+0xd8>
  lapic[index] = value;
8010286d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102874:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102877:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010287a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102881:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102884:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102887:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010288e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102891:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102894:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010289b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010289e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028a1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801028a8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028ab:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ae:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801028b5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028b8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801028bb:	8b 50 30             	mov    0x30(%eax),%edx
801028be:	c1 ea 10             	shr    $0x10,%edx
801028c1:	81 e2 fc 00 00 00    	and    $0xfc,%edx
801028c7:	75 77                	jne    80102940 <lapicinit+0xe0>
  lapic[index] = value;
801028c9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801028d0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028d3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028d6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028dd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028e0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028e3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028ea:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028ed:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028f0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028f7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028fa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028fd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102904:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102907:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010290a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102911:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102914:	8b 50 20             	mov    0x20(%eax),%edx
80102917:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010291e:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102920:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102926:	80 e6 10             	and    $0x10,%dh
80102929:	75 f5                	jne    80102920 <lapicinit+0xc0>
  lapic[index] = value;
8010292b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102932:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102935:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102938:	c3                   	ret    
80102939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102940:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102947:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010294a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010294d:	e9 77 ff ff ff       	jmp    801028c9 <lapicinit+0x69>
80102952:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102960 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102960:	a1 80 26 11 80       	mov    0x80112680,%eax
80102965:	85 c0                	test   %eax,%eax
80102967:	74 07                	je     80102970 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102969:	8b 40 20             	mov    0x20(%eax),%eax
8010296c:	c1 e8 18             	shr    $0x18,%eax
8010296f:	c3                   	ret    
    return 0;
80102970:	31 c0                	xor    %eax,%eax
}
80102972:	c3                   	ret    
80102973:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010297a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102980 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102980:	a1 80 26 11 80       	mov    0x80112680,%eax
80102985:	85 c0                	test   %eax,%eax
80102987:	74 0d                	je     80102996 <lapiceoi+0x16>
  lapic[index] = value;
80102989:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102990:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102993:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102996:	c3                   	ret    
80102997:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010299e:	66 90                	xchg   %ax,%ax

801029a0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
801029a0:	c3                   	ret    
801029a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029af:	90                   	nop

801029b0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801029b0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029b1:	b8 0f 00 00 00       	mov    $0xf,%eax
801029b6:	ba 70 00 00 00       	mov    $0x70,%edx
801029bb:	89 e5                	mov    %esp,%ebp
801029bd:	53                   	push   %ebx
801029be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801029c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801029c4:	ee                   	out    %al,(%dx)
801029c5:	b8 0a 00 00 00       	mov    $0xa,%eax
801029ca:	ba 71 00 00 00       	mov    $0x71,%edx
801029cf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801029d0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801029d2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801029d5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801029db:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801029dd:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
801029e0:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
801029e2:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
801029e5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801029e8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801029ee:	a1 80 26 11 80       	mov    0x80112680,%eax
801029f3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029f9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029fc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102a03:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a06:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a09:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102a10:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a13:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a16:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a1c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a1f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a25:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a28:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a2e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a31:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a37:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102a3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a3d:	c9                   	leave  
80102a3e:	c3                   	ret    
80102a3f:	90                   	nop

80102a40 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102a40:	55                   	push   %ebp
80102a41:	b8 0b 00 00 00       	mov    $0xb,%eax
80102a46:	ba 70 00 00 00       	mov    $0x70,%edx
80102a4b:	89 e5                	mov    %esp,%ebp
80102a4d:	57                   	push   %edi
80102a4e:	56                   	push   %esi
80102a4f:	53                   	push   %ebx
80102a50:	83 ec 4c             	sub    $0x4c,%esp
80102a53:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a54:	ba 71 00 00 00       	mov    $0x71,%edx
80102a59:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102a5a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a5d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102a62:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a65:	8d 76 00             	lea    0x0(%esi),%esi
80102a68:	31 c0                	xor    %eax,%eax
80102a6a:	89 da                	mov    %ebx,%edx
80102a6c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a6d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a72:	89 ca                	mov    %ecx,%edx
80102a74:	ec                   	in     (%dx),%al
80102a75:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a78:	89 da                	mov    %ebx,%edx
80102a7a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a7f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a80:	89 ca                	mov    %ecx,%edx
80102a82:	ec                   	in     (%dx),%al
80102a83:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a86:	89 da                	mov    %ebx,%edx
80102a88:	b8 04 00 00 00       	mov    $0x4,%eax
80102a8d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8e:	89 ca                	mov    %ecx,%edx
80102a90:	ec                   	in     (%dx),%al
80102a91:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a94:	89 da                	mov    %ebx,%edx
80102a96:	b8 07 00 00 00       	mov    $0x7,%eax
80102a9b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9c:	89 ca                	mov    %ecx,%edx
80102a9e:	ec                   	in     (%dx),%al
80102a9f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa2:	89 da                	mov    %ebx,%edx
80102aa4:	b8 08 00 00 00       	mov    $0x8,%eax
80102aa9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aaa:	89 ca                	mov    %ecx,%edx
80102aac:	ec                   	in     (%dx),%al
80102aad:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aaf:	89 da                	mov    %ebx,%edx
80102ab1:	b8 09 00 00 00       	mov    $0x9,%eax
80102ab6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ab7:	89 ca                	mov    %ecx,%edx
80102ab9:	ec                   	in     (%dx),%al
80102aba:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102abc:	89 da                	mov    %ebx,%edx
80102abe:	b8 0a 00 00 00       	mov    $0xa,%eax
80102ac3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ac4:	89 ca                	mov    %ecx,%edx
80102ac6:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102ac7:	84 c0                	test   %al,%al
80102ac9:	78 9d                	js     80102a68 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102acb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102acf:	89 fa                	mov    %edi,%edx
80102ad1:	0f b6 fa             	movzbl %dl,%edi
80102ad4:	89 f2                	mov    %esi,%edx
80102ad6:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102ad9:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102add:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ae0:	89 da                	mov    %ebx,%edx
80102ae2:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102ae5:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102ae8:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102aec:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102aef:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102af2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102af6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102af9:	31 c0                	xor    %eax,%eax
80102afb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102afc:	89 ca                	mov    %ecx,%edx
80102afe:	ec                   	in     (%dx),%al
80102aff:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b02:	89 da                	mov    %ebx,%edx
80102b04:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102b07:	b8 02 00 00 00       	mov    $0x2,%eax
80102b0c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b0d:	89 ca                	mov    %ecx,%edx
80102b0f:	ec                   	in     (%dx),%al
80102b10:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b13:	89 da                	mov    %ebx,%edx
80102b15:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102b18:	b8 04 00 00 00       	mov    $0x4,%eax
80102b1d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b1e:	89 ca                	mov    %ecx,%edx
80102b20:	ec                   	in     (%dx),%al
80102b21:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b24:	89 da                	mov    %ebx,%edx
80102b26:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102b29:	b8 07 00 00 00       	mov    $0x7,%eax
80102b2e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b2f:	89 ca                	mov    %ecx,%edx
80102b31:	ec                   	in     (%dx),%al
80102b32:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b35:	89 da                	mov    %ebx,%edx
80102b37:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102b3a:	b8 08 00 00 00       	mov    $0x8,%eax
80102b3f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b40:	89 ca                	mov    %ecx,%edx
80102b42:	ec                   	in     (%dx),%al
80102b43:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b46:	89 da                	mov    %ebx,%edx
80102b48:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102b4b:	b8 09 00 00 00       	mov    $0x9,%eax
80102b50:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b51:	89 ca                	mov    %ecx,%edx
80102b53:	ec                   	in     (%dx),%al
80102b54:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b57:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102b5a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b5d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b60:	6a 18                	push   $0x18
80102b62:	50                   	push   %eax
80102b63:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b66:	50                   	push   %eax
80102b67:	e8 44 27 00 00       	call   801052b0 <memcmp>
80102b6c:	83 c4 10             	add    $0x10,%esp
80102b6f:	85 c0                	test   %eax,%eax
80102b71:	0f 85 f1 fe ff ff    	jne    80102a68 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b77:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b7b:	75 78                	jne    80102bf5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b7d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b80:	89 c2                	mov    %eax,%edx
80102b82:	83 e0 0f             	and    $0xf,%eax
80102b85:	c1 ea 04             	shr    $0x4,%edx
80102b88:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b8b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b8e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b91:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b94:	89 c2                	mov    %eax,%edx
80102b96:	83 e0 0f             	and    $0xf,%eax
80102b99:	c1 ea 04             	shr    $0x4,%edx
80102b9c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b9f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ba2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102ba5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ba8:	89 c2                	mov    %eax,%edx
80102baa:	83 e0 0f             	and    $0xf,%eax
80102bad:	c1 ea 04             	shr    $0x4,%edx
80102bb0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bb3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bb6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102bb9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bbc:	89 c2                	mov    %eax,%edx
80102bbe:	83 e0 0f             	and    $0xf,%eax
80102bc1:	c1 ea 04             	shr    $0x4,%edx
80102bc4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bc7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bca:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102bcd:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bd0:	89 c2                	mov    %eax,%edx
80102bd2:	83 e0 0f             	and    $0xf,%eax
80102bd5:	c1 ea 04             	shr    $0x4,%edx
80102bd8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bdb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bde:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102be1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102be4:	89 c2                	mov    %eax,%edx
80102be6:	83 e0 0f             	and    $0xf,%eax
80102be9:	c1 ea 04             	shr    $0x4,%edx
80102bec:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bef:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bf2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102bf5:	8b 75 08             	mov    0x8(%ebp),%esi
80102bf8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102bfb:	89 06                	mov    %eax,(%esi)
80102bfd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c00:	89 46 04             	mov    %eax,0x4(%esi)
80102c03:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c06:	89 46 08             	mov    %eax,0x8(%esi)
80102c09:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c0c:	89 46 0c             	mov    %eax,0xc(%esi)
80102c0f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c12:	89 46 10             	mov    %eax,0x10(%esi)
80102c15:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c18:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102c1b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102c22:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c25:	5b                   	pop    %ebx
80102c26:	5e                   	pop    %esi
80102c27:	5f                   	pop    %edi
80102c28:	5d                   	pop    %ebp
80102c29:	c3                   	ret    
80102c2a:	66 90                	xchg   %ax,%ax
80102c2c:	66 90                	xchg   %ax,%ax
80102c2e:	66 90                	xchg   %ax,%ax

80102c30 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c30:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102c36:	85 c9                	test   %ecx,%ecx
80102c38:	0f 8e 8a 00 00 00    	jle    80102cc8 <install_trans+0x98>
{
80102c3e:	55                   	push   %ebp
80102c3f:	89 e5                	mov    %esp,%ebp
80102c41:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102c42:	31 ff                	xor    %edi,%edi
{
80102c44:	56                   	push   %esi
80102c45:	53                   	push   %ebx
80102c46:	83 ec 0c             	sub    $0xc,%esp
80102c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c50:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102c55:	83 ec 08             	sub    $0x8,%esp
80102c58:	01 f8                	add    %edi,%eax
80102c5a:	83 c0 01             	add    $0x1,%eax
80102c5d:	50                   	push   %eax
80102c5e:	ff 35 e4 26 11 80    	push   0x801126e4
80102c64:	e8 67 d4 ff ff       	call   801000d0 <bread>
80102c69:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c6b:	58                   	pop    %eax
80102c6c:	5a                   	pop    %edx
80102c6d:	ff 34 bd ec 26 11 80 	push   -0x7feed914(,%edi,4)
80102c74:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c7a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c7d:	e8 4e d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c82:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c85:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c87:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c8a:	68 00 02 00 00       	push   $0x200
80102c8f:	50                   	push   %eax
80102c90:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c93:	50                   	push   %eax
80102c94:	e8 67 26 00 00       	call   80105300 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c99:	89 1c 24             	mov    %ebx,(%esp)
80102c9c:	e8 0f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102ca1:	89 34 24             	mov    %esi,(%esp)
80102ca4:	e8 47 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102ca9:	89 1c 24             	mov    %ebx,(%esp)
80102cac:	e8 3f d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102cb1:	83 c4 10             	add    $0x10,%esp
80102cb4:	39 3d e8 26 11 80    	cmp    %edi,0x801126e8
80102cba:	7f 94                	jg     80102c50 <install_trans+0x20>
  }
}
80102cbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102cbf:	5b                   	pop    %ebx
80102cc0:	5e                   	pop    %esi
80102cc1:	5f                   	pop    %edi
80102cc2:	5d                   	pop    %ebp
80102cc3:	c3                   	ret    
80102cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cc8:	c3                   	ret    
80102cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102cd0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102cd0:	55                   	push   %ebp
80102cd1:	89 e5                	mov    %esp,%ebp
80102cd3:	53                   	push   %ebx
80102cd4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102cd7:	ff 35 d4 26 11 80    	push   0x801126d4
80102cdd:	ff 35 e4 26 11 80    	push   0x801126e4
80102ce3:	e8 e8 d3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102ce8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ceb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102ced:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102cf2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102cf5:	85 c0                	test   %eax,%eax
80102cf7:	7e 19                	jle    80102d12 <write_head+0x42>
80102cf9:	31 d2                	xor    %edx,%edx
80102cfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cff:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102d00:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102d07:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d0b:	83 c2 01             	add    $0x1,%edx
80102d0e:	39 d0                	cmp    %edx,%eax
80102d10:	75 ee                	jne    80102d00 <write_head+0x30>
  }
  bwrite(buf);
80102d12:	83 ec 0c             	sub    $0xc,%esp
80102d15:	53                   	push   %ebx
80102d16:	e8 95 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102d1b:	89 1c 24             	mov    %ebx,(%esp)
80102d1e:	e8 cd d4 ff ff       	call   801001f0 <brelse>
}
80102d23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d26:	83 c4 10             	add    $0x10,%esp
80102d29:	c9                   	leave  
80102d2a:	c3                   	ret    
80102d2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d2f:	90                   	nop

80102d30 <initlog>:
{
80102d30:	55                   	push   %ebp
80102d31:	89 e5                	mov    %esp,%ebp
80102d33:	53                   	push   %ebx
80102d34:	83 ec 2c             	sub    $0x2c,%esp
80102d37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102d3a:	68 60 82 10 80       	push   $0x80108260
80102d3f:	68 a0 26 11 80       	push   $0x801126a0
80102d44:	e8 87 22 00 00       	call   80104fd0 <initlock>
  readsb(dev, &sb);
80102d49:	58                   	pop    %eax
80102d4a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102d4d:	5a                   	pop    %edx
80102d4e:	50                   	push   %eax
80102d4f:	53                   	push   %ebx
80102d50:	e8 3b e8 ff ff       	call   80101590 <readsb>
  log.start = sb.logstart;
80102d55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102d58:	59                   	pop    %ecx
  log.dev = dev;
80102d59:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  log.size = sb.nlog;
80102d5f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d62:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  log.size = sb.nlog;
80102d67:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  struct buf *buf = bread(log.dev, log.start);
80102d6d:	5a                   	pop    %edx
80102d6e:	50                   	push   %eax
80102d6f:	53                   	push   %ebx
80102d70:	e8 5b d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d75:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d78:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d7b:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102d81:	85 db                	test   %ebx,%ebx
80102d83:	7e 1d                	jle    80102da2 <initlog+0x72>
80102d85:	31 d2                	xor    %edx,%edx
80102d87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d8e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102d90:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d94:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d9b:	83 c2 01             	add    $0x1,%edx
80102d9e:	39 d3                	cmp    %edx,%ebx
80102da0:	75 ee                	jne    80102d90 <initlog+0x60>
  brelse(buf);
80102da2:	83 ec 0c             	sub    $0xc,%esp
80102da5:	50                   	push   %eax
80102da6:	e8 45 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102dab:	e8 80 fe ff ff       	call   80102c30 <install_trans>
  log.lh.n = 0;
80102db0:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102db7:	00 00 00 
  write_head(); // clear the log
80102dba:	e8 11 ff ff ff       	call   80102cd0 <write_head>
}
80102dbf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dc2:	83 c4 10             	add    $0x10,%esp
80102dc5:	c9                   	leave  
80102dc6:	c3                   	ret    
80102dc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dce:	66 90                	xchg   %ax,%ax

80102dd0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
80102dd3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102dd6:	68 a0 26 11 80       	push   $0x801126a0
80102ddb:	e8 c0 23 00 00       	call   801051a0 <acquire>
80102de0:	83 c4 10             	add    $0x10,%esp
80102de3:	eb 18                	jmp    80102dfd <begin_op+0x2d>
80102de5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102de8:	83 ec 08             	sub    $0x8,%esp
80102deb:	68 a0 26 11 80       	push   $0x801126a0
80102df0:	68 a0 26 11 80       	push   $0x801126a0
80102df5:	e8 e6 15 00 00       	call   801043e0 <sleep>
80102dfa:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102dfd:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102e02:	85 c0                	test   %eax,%eax
80102e04:	75 e2                	jne    80102de8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102e06:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102e0b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102e11:	83 c0 01             	add    $0x1,%eax
80102e14:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102e17:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102e1a:	83 fa 1e             	cmp    $0x1e,%edx
80102e1d:	7f c9                	jg     80102de8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102e1f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102e22:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102e27:	68 a0 26 11 80       	push   $0x801126a0
80102e2c:	e8 0f 23 00 00       	call   80105140 <release>
      break;
    }
  }
}
80102e31:	83 c4 10             	add    $0x10,%esp
80102e34:	c9                   	leave  
80102e35:	c3                   	ret    
80102e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e3d:	8d 76 00             	lea    0x0(%esi),%esi

80102e40 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	57                   	push   %edi
80102e44:	56                   	push   %esi
80102e45:	53                   	push   %ebx
80102e46:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102e49:	68 a0 26 11 80       	push   $0x801126a0
80102e4e:	e8 4d 23 00 00       	call   801051a0 <acquire>
  log.outstanding -= 1;
80102e53:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102e58:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
80102e5e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e61:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102e64:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
80102e6a:	85 f6                	test   %esi,%esi
80102e6c:	0f 85 22 01 00 00    	jne    80102f94 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e72:	85 db                	test   %ebx,%ebx
80102e74:	0f 85 f6 00 00 00    	jne    80102f70 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e7a:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102e81:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e84:	83 ec 0c             	sub    $0xc,%esp
80102e87:	68 a0 26 11 80       	push   $0x801126a0
80102e8c:	e8 af 22 00 00       	call   80105140 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e91:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102e97:	83 c4 10             	add    $0x10,%esp
80102e9a:	85 c9                	test   %ecx,%ecx
80102e9c:	7f 42                	jg     80102ee0 <end_op+0xa0>
    acquire(&log.lock);
80102e9e:	83 ec 0c             	sub    $0xc,%esp
80102ea1:	68 a0 26 11 80       	push   $0x801126a0
80102ea6:	e8 f5 22 00 00       	call   801051a0 <acquire>
    wakeup(&log);
80102eab:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
    log.committing = 0;
80102eb2:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102eb9:	00 00 00 
    wakeup(&log);
80102ebc:	e8 df 15 00 00       	call   801044a0 <wakeup>
    release(&log.lock);
80102ec1:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102ec8:	e8 73 22 00 00       	call   80105140 <release>
80102ecd:	83 c4 10             	add    $0x10,%esp
}
80102ed0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ed3:	5b                   	pop    %ebx
80102ed4:	5e                   	pop    %esi
80102ed5:	5f                   	pop    %edi
80102ed6:	5d                   	pop    %ebp
80102ed7:	c3                   	ret    
80102ed8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102edf:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102ee0:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102ee5:	83 ec 08             	sub    $0x8,%esp
80102ee8:	01 d8                	add    %ebx,%eax
80102eea:	83 c0 01             	add    $0x1,%eax
80102eed:	50                   	push   %eax
80102eee:	ff 35 e4 26 11 80    	push   0x801126e4
80102ef4:	e8 d7 d1 ff ff       	call   801000d0 <bread>
80102ef9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102efb:	58                   	pop    %eax
80102efc:	5a                   	pop    %edx
80102efd:	ff 34 9d ec 26 11 80 	push   -0x7feed914(,%ebx,4)
80102f04:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102f0a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f0d:	e8 be d1 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102f12:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f15:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102f17:	8d 40 5c             	lea    0x5c(%eax),%eax
80102f1a:	68 00 02 00 00       	push   $0x200
80102f1f:	50                   	push   %eax
80102f20:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f23:	50                   	push   %eax
80102f24:	e8 d7 23 00 00       	call   80105300 <memmove>
    bwrite(to);  // write the log
80102f29:	89 34 24             	mov    %esi,(%esp)
80102f2c:	e8 7f d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102f31:	89 3c 24             	mov    %edi,(%esp)
80102f34:	e8 b7 d2 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102f39:	89 34 24             	mov    %esi,(%esp)
80102f3c:	e8 af d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f41:	83 c4 10             	add    $0x10,%esp
80102f44:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102f4a:	7c 94                	jl     80102ee0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102f4c:	e8 7f fd ff ff       	call   80102cd0 <write_head>
    install_trans(); // Now install writes to home locations
80102f51:	e8 da fc ff ff       	call   80102c30 <install_trans>
    log.lh.n = 0;
80102f56:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102f5d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f60:	e8 6b fd ff ff       	call   80102cd0 <write_head>
80102f65:	e9 34 ff ff ff       	jmp    80102e9e <end_op+0x5e>
80102f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f70:	83 ec 0c             	sub    $0xc,%esp
80102f73:	68 a0 26 11 80       	push   $0x801126a0
80102f78:	e8 23 15 00 00       	call   801044a0 <wakeup>
  release(&log.lock);
80102f7d:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102f84:	e8 b7 21 00 00       	call   80105140 <release>
80102f89:	83 c4 10             	add    $0x10,%esp
}
80102f8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f8f:	5b                   	pop    %ebx
80102f90:	5e                   	pop    %esi
80102f91:	5f                   	pop    %edi
80102f92:	5d                   	pop    %ebp
80102f93:	c3                   	ret    
    panic("log.committing");
80102f94:	83 ec 0c             	sub    $0xc,%esp
80102f97:	68 64 82 10 80       	push   $0x80108264
80102f9c:	e8 df d3 ff ff       	call   80100380 <panic>
80102fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102faf:	90                   	nop

80102fb0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102fb0:	55                   	push   %ebp
80102fb1:	89 e5                	mov    %esp,%ebp
80102fb3:	53                   	push   %ebx
80102fb4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102fb7:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
{
80102fbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102fc0:	83 fa 1d             	cmp    $0x1d,%edx
80102fc3:	0f 8f 85 00 00 00    	jg     8010304e <log_write+0x9e>
80102fc9:	a1 d8 26 11 80       	mov    0x801126d8,%eax
80102fce:	83 e8 01             	sub    $0x1,%eax
80102fd1:	39 c2                	cmp    %eax,%edx
80102fd3:	7d 79                	jge    8010304e <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102fd5:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102fda:	85 c0                	test   %eax,%eax
80102fdc:	7e 7d                	jle    8010305b <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102fde:	83 ec 0c             	sub    $0xc,%esp
80102fe1:	68 a0 26 11 80       	push   $0x801126a0
80102fe6:	e8 b5 21 00 00       	call   801051a0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102feb:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102ff1:	83 c4 10             	add    $0x10,%esp
80102ff4:	85 d2                	test   %edx,%edx
80102ff6:	7e 4a                	jle    80103042 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102ff8:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102ffb:	31 c0                	xor    %eax,%eax
80102ffd:	eb 08                	jmp    80103007 <log_write+0x57>
80102fff:	90                   	nop
80103000:	83 c0 01             	add    $0x1,%eax
80103003:	39 c2                	cmp    %eax,%edx
80103005:	74 29                	je     80103030 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103007:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
8010300e:	75 f0                	jne    80103000 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103010:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103017:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010301a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010301d:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80103024:	c9                   	leave  
  release(&log.lock);
80103025:	e9 16 21 00 00       	jmp    80105140 <release>
8010302a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103030:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
    log.lh.n++;
80103037:	83 c2 01             	add    $0x1,%edx
8010303a:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
80103040:	eb d5                	jmp    80103017 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80103042:	8b 43 08             	mov    0x8(%ebx),%eax
80103045:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
8010304a:	75 cb                	jne    80103017 <log_write+0x67>
8010304c:	eb e9                	jmp    80103037 <log_write+0x87>
    panic("too big a transaction");
8010304e:	83 ec 0c             	sub    $0xc,%esp
80103051:	68 73 82 10 80       	push   $0x80108273
80103056:	e8 25 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010305b:	83 ec 0c             	sub    $0xc,%esp
8010305e:	68 89 82 10 80       	push   $0x80108289
80103063:	e8 18 d3 ff ff       	call   80100380 <panic>
80103068:	66 90                	xchg   %ax,%ax
8010306a:	66 90                	xchg   %ax,%ax
8010306c:	66 90                	xchg   %ax,%ax
8010306e:	66 90                	xchg   %ax,%ax

80103070 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103070:	55                   	push   %ebp
80103071:	89 e5                	mov    %esp,%ebp
80103073:	53                   	push   %ebx
80103074:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103077:	e8 94 09 00 00       	call   80103a10 <cpuid>
8010307c:	89 c3                	mov    %eax,%ebx
8010307e:	e8 8d 09 00 00       	call   80103a10 <cpuid>
80103083:	83 ec 04             	sub    $0x4,%esp
80103086:	53                   	push   %ebx
80103087:	50                   	push   %eax
80103088:	68 a4 82 10 80       	push   $0x801082a4
8010308d:	e8 0e d6 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103092:	e8 69 34 00 00       	call   80106500 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103097:	e8 14 09 00 00       	call   801039b0 <mycpu>
8010309c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010309e:	b8 01 00 00 00       	mov    $0x1,%eax
801030a3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801030aa:	e8 f1 0c 00 00       	call   80103da0 <scheduler>
801030af:	90                   	nop

801030b0 <mpenter>:
{
801030b0:	55                   	push   %ebp
801030b1:	89 e5                	mov    %esp,%ebp
801030b3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801030b6:	e8 35 45 00 00       	call   801075f0 <switchkvm>
  seginit();
801030bb:	e8 a0 44 00 00       	call   80107560 <seginit>
  lapicinit();
801030c0:	e8 9b f7 ff ff       	call   80102860 <lapicinit>
  mpmain();
801030c5:	e8 a6 ff ff ff       	call   80103070 <mpmain>
801030ca:	66 90                	xchg   %ax,%ax
801030cc:	66 90                	xchg   %ax,%ax
801030ce:	66 90                	xchg   %ax,%ax

801030d0 <main>:
{
801030d0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801030d4:	83 e4 f0             	and    $0xfffffff0,%esp
801030d7:	ff 71 fc             	push   -0x4(%ecx)
801030da:	55                   	push   %ebp
801030db:	89 e5                	mov    %esp,%ebp
801030dd:	53                   	push   %ebx
801030de:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801030df:	83 ec 08             	sub    $0x8,%esp
801030e2:	68 00 00 40 80       	push   $0x80400000
801030e7:	68 f0 73 11 80       	push   $0x801173f0
801030ec:	e8 8f f5 ff ff       	call   80102680 <kinit1>
  kvmalloc();      // kernel page table
801030f1:	e8 ea 49 00 00       	call   80107ae0 <kvmalloc>
  mpinit();        // detect other processors
801030f6:	e8 85 01 00 00       	call   80103280 <mpinit>
  lapicinit();     // interrupt controller
801030fb:	e8 60 f7 ff ff       	call   80102860 <lapicinit>
  seginit();       // segment descriptors
80103100:	e8 5b 44 00 00       	call   80107560 <seginit>
  picinit();       // disable pic
80103105:	e8 76 03 00 00       	call   80103480 <picinit>
  ioapicinit();    // another interrupt controller
8010310a:	e8 31 f3 ff ff       	call   80102440 <ioapicinit>
  consoleinit();   // console hardware
8010310f:	e8 4c d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
80103114:	e8 d7 36 00 00       	call   801067f0 <uartinit>
  pinit();         // process table
80103119:	e8 72 08 00 00       	call   80103990 <pinit>
  tvinit();        // trap vectors
8010311e:	e8 5d 33 00 00       	call   80106480 <tvinit>
  binit();         // buffer cache
80103123:	e8 18 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103128:	e8 53 dd ff ff       	call   80100e80 <fileinit>
  ideinit();       // disk 
8010312d:	e8 fe f0 ff ff       	call   80102230 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103132:	83 c4 0c             	add    $0xc,%esp
80103135:	68 8a 00 00 00       	push   $0x8a
8010313a:	68 8c b4 10 80       	push   $0x8010b48c
8010313f:	68 00 70 00 80       	push   $0x80007000
80103144:	e8 b7 21 00 00       	call   80105300 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103149:	83 c4 10             	add    $0x10,%esp
8010314c:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80103153:	00 00 00 
80103156:	05 a0 27 11 80       	add    $0x801127a0,%eax
8010315b:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
80103160:	76 7e                	jbe    801031e0 <main+0x110>
80103162:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
80103167:	eb 20                	jmp    80103189 <main+0xb9>
80103169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103170:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80103177:	00 00 00 
8010317a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103180:	05 a0 27 11 80       	add    $0x801127a0,%eax
80103185:	39 c3                	cmp    %eax,%ebx
80103187:	73 57                	jae    801031e0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103189:	e8 22 08 00 00       	call   801039b0 <mycpu>
8010318e:	39 c3                	cmp    %eax,%ebx
80103190:	74 de                	je     80103170 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103192:	e8 59 f5 ff ff       	call   801026f0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103197:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010319a:	c7 05 f8 6f 00 80 b0 	movl   $0x801030b0,0x80006ff8
801031a1:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801031a4:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801031ab:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801031ae:	05 00 10 00 00       	add    $0x1000,%eax
801031b3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801031b8:	0f b6 03             	movzbl (%ebx),%eax
801031bb:	68 00 70 00 00       	push   $0x7000
801031c0:	50                   	push   %eax
801031c1:	e8 ea f7 ff ff       	call   801029b0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801031c6:	83 c4 10             	add    $0x10,%esp
801031c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031d0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801031d6:	85 c0                	test   %eax,%eax
801031d8:	74 f6                	je     801031d0 <main+0x100>
801031da:	eb 94                	jmp    80103170 <main+0xa0>
801031dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801031e0:	83 ec 08             	sub    $0x8,%esp
801031e3:	68 00 00 00 8e       	push   $0x8e000000
801031e8:	68 00 00 40 80       	push   $0x80400000
801031ed:	e8 2e f4 ff ff       	call   80102620 <kinit2>
  userinit();      // first user process
801031f2:	e8 69 08 00 00       	call   80103a60 <userinit>
  mpmain();        // finish this processor's setup
801031f7:	e8 74 fe ff ff       	call   80103070 <mpmain>
801031fc:	66 90                	xchg   %ax,%ax
801031fe:	66 90                	xchg   %ax,%ax

80103200 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103200:	55                   	push   %ebp
80103201:	89 e5                	mov    %esp,%ebp
80103203:	57                   	push   %edi
80103204:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103205:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010320b:	53                   	push   %ebx
  e = addr+len;
8010320c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010320f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103212:	39 de                	cmp    %ebx,%esi
80103214:	72 10                	jb     80103226 <mpsearch1+0x26>
80103216:	eb 50                	jmp    80103268 <mpsearch1+0x68>
80103218:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010321f:	90                   	nop
80103220:	89 fe                	mov    %edi,%esi
80103222:	39 fb                	cmp    %edi,%ebx
80103224:	76 42                	jbe    80103268 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103226:	83 ec 04             	sub    $0x4,%esp
80103229:	8d 7e 10             	lea    0x10(%esi),%edi
8010322c:	6a 04                	push   $0x4
8010322e:	68 b8 82 10 80       	push   $0x801082b8
80103233:	56                   	push   %esi
80103234:	e8 77 20 00 00       	call   801052b0 <memcmp>
80103239:	83 c4 10             	add    $0x10,%esp
8010323c:	85 c0                	test   %eax,%eax
8010323e:	75 e0                	jne    80103220 <mpsearch1+0x20>
80103240:	89 f2                	mov    %esi,%edx
80103242:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103248:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010324b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010324e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103250:	39 fa                	cmp    %edi,%edx
80103252:	75 f4                	jne    80103248 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103254:	84 c0                	test   %al,%al
80103256:	75 c8                	jne    80103220 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103258:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010325b:	89 f0                	mov    %esi,%eax
8010325d:	5b                   	pop    %ebx
8010325e:	5e                   	pop    %esi
8010325f:	5f                   	pop    %edi
80103260:	5d                   	pop    %ebp
80103261:	c3                   	ret    
80103262:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103268:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010326b:	31 f6                	xor    %esi,%esi
}
8010326d:	5b                   	pop    %ebx
8010326e:	89 f0                	mov    %esi,%eax
80103270:	5e                   	pop    %esi
80103271:	5f                   	pop    %edi
80103272:	5d                   	pop    %ebp
80103273:	c3                   	ret    
80103274:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010327b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010327f:	90                   	nop

80103280 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103280:	55                   	push   %ebp
80103281:	89 e5                	mov    %esp,%ebp
80103283:	57                   	push   %edi
80103284:	56                   	push   %esi
80103285:	53                   	push   %ebx
80103286:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103289:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103290:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103297:	c1 e0 08             	shl    $0x8,%eax
8010329a:	09 d0                	or     %edx,%eax
8010329c:	c1 e0 04             	shl    $0x4,%eax
8010329f:	75 1b                	jne    801032bc <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801032a1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801032a8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801032af:	c1 e0 08             	shl    $0x8,%eax
801032b2:	09 d0                	or     %edx,%eax
801032b4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801032b7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801032bc:	ba 00 04 00 00       	mov    $0x400,%edx
801032c1:	e8 3a ff ff ff       	call   80103200 <mpsearch1>
801032c6:	89 c3                	mov    %eax,%ebx
801032c8:	85 c0                	test   %eax,%eax
801032ca:	0f 84 40 01 00 00    	je     80103410 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032d0:	8b 73 04             	mov    0x4(%ebx),%esi
801032d3:	85 f6                	test   %esi,%esi
801032d5:	0f 84 25 01 00 00    	je     80103400 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
801032db:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032de:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801032e4:	6a 04                	push   $0x4
801032e6:	68 bd 82 10 80       	push   $0x801082bd
801032eb:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801032ef:	e8 bc 1f 00 00       	call   801052b0 <memcmp>
801032f4:	83 c4 10             	add    $0x10,%esp
801032f7:	85 c0                	test   %eax,%eax
801032f9:	0f 85 01 01 00 00    	jne    80103400 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
801032ff:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103306:	3c 01                	cmp    $0x1,%al
80103308:	74 08                	je     80103312 <mpinit+0x92>
8010330a:	3c 04                	cmp    $0x4,%al
8010330c:	0f 85 ee 00 00 00    	jne    80103400 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
80103312:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103319:	66 85 d2             	test   %dx,%dx
8010331c:	74 22                	je     80103340 <mpinit+0xc0>
8010331e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103321:	89 f0                	mov    %esi,%eax
  sum = 0;
80103323:	31 d2                	xor    %edx,%edx
80103325:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103328:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010332f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103332:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103334:	39 c7                	cmp    %eax,%edi
80103336:	75 f0                	jne    80103328 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103338:	84 d2                	test   %dl,%dl
8010333a:	0f 85 c0 00 00 00    	jne    80103400 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103340:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103346:	a3 80 26 11 80       	mov    %eax,0x80112680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010334b:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103352:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
80103358:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010335d:	03 55 e4             	add    -0x1c(%ebp),%edx
80103360:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103363:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103367:	90                   	nop
80103368:	39 d0                	cmp    %edx,%eax
8010336a:	73 15                	jae    80103381 <mpinit+0x101>
    switch(*p){
8010336c:	0f b6 08             	movzbl (%eax),%ecx
8010336f:	80 f9 02             	cmp    $0x2,%cl
80103372:	74 4c                	je     801033c0 <mpinit+0x140>
80103374:	77 3a                	ja     801033b0 <mpinit+0x130>
80103376:	84 c9                	test   %cl,%cl
80103378:	74 56                	je     801033d0 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010337a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010337d:	39 d0                	cmp    %edx,%eax
8010337f:	72 eb                	jb     8010336c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103381:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103384:	85 f6                	test   %esi,%esi
80103386:	0f 84 d9 00 00 00    	je     80103465 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010338c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103390:	74 15                	je     801033a7 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103392:	b8 70 00 00 00       	mov    $0x70,%eax
80103397:	ba 22 00 00 00       	mov    $0x22,%edx
8010339c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010339d:	ba 23 00 00 00       	mov    $0x23,%edx
801033a2:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801033a3:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033a6:	ee                   	out    %al,(%dx)
  }
}
801033a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033aa:	5b                   	pop    %ebx
801033ab:	5e                   	pop    %esi
801033ac:	5f                   	pop    %edi
801033ad:	5d                   	pop    %ebp
801033ae:	c3                   	ret    
801033af:	90                   	nop
    switch(*p){
801033b0:	83 e9 03             	sub    $0x3,%ecx
801033b3:	80 f9 01             	cmp    $0x1,%cl
801033b6:	76 c2                	jbe    8010337a <mpinit+0xfa>
801033b8:	31 f6                	xor    %esi,%esi
801033ba:	eb ac                	jmp    80103368 <mpinit+0xe8>
801033bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801033c0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801033c4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801033c7:	88 0d 80 27 11 80    	mov    %cl,0x80112780
      continue;
801033cd:	eb 99                	jmp    80103368 <mpinit+0xe8>
801033cf:	90                   	nop
      if(ncpu < NCPU) {
801033d0:	8b 0d 84 27 11 80    	mov    0x80112784,%ecx
801033d6:	83 f9 07             	cmp    $0x7,%ecx
801033d9:	7f 19                	jg     801033f4 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033db:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801033e1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801033e5:	83 c1 01             	add    $0x1,%ecx
801033e8:	89 0d 84 27 11 80    	mov    %ecx,0x80112784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033ee:	88 9f a0 27 11 80    	mov    %bl,-0x7feed860(%edi)
      p += sizeof(struct mpproc);
801033f4:	83 c0 14             	add    $0x14,%eax
      continue;
801033f7:	e9 6c ff ff ff       	jmp    80103368 <mpinit+0xe8>
801033fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103400:	83 ec 0c             	sub    $0xc,%esp
80103403:	68 c2 82 10 80       	push   $0x801082c2
80103408:	e8 73 cf ff ff       	call   80100380 <panic>
8010340d:	8d 76 00             	lea    0x0(%esi),%esi
{
80103410:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80103415:	eb 13                	jmp    8010342a <mpinit+0x1aa>
80103417:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010341e:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
80103420:	89 f3                	mov    %esi,%ebx
80103422:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103428:	74 d6                	je     80103400 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010342a:	83 ec 04             	sub    $0x4,%esp
8010342d:	8d 73 10             	lea    0x10(%ebx),%esi
80103430:	6a 04                	push   $0x4
80103432:	68 b8 82 10 80       	push   $0x801082b8
80103437:	53                   	push   %ebx
80103438:	e8 73 1e 00 00       	call   801052b0 <memcmp>
8010343d:	83 c4 10             	add    $0x10,%esp
80103440:	85 c0                	test   %eax,%eax
80103442:	75 dc                	jne    80103420 <mpinit+0x1a0>
80103444:	89 da                	mov    %ebx,%edx
80103446:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010344d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103450:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103453:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103456:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103458:	39 d6                	cmp    %edx,%esi
8010345a:	75 f4                	jne    80103450 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010345c:	84 c0                	test   %al,%al
8010345e:	75 c0                	jne    80103420 <mpinit+0x1a0>
80103460:	e9 6b fe ff ff       	jmp    801032d0 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103465:	83 ec 0c             	sub    $0xc,%esp
80103468:	68 dc 82 10 80       	push   $0x801082dc
8010346d:	e8 0e cf ff ff       	call   80100380 <panic>
80103472:	66 90                	xchg   %ax,%ax
80103474:	66 90                	xchg   %ax,%ax
80103476:	66 90                	xchg   %ax,%ax
80103478:	66 90                	xchg   %ax,%ax
8010347a:	66 90                	xchg   %ax,%ax
8010347c:	66 90                	xchg   %ax,%ax
8010347e:	66 90                	xchg   %ax,%ax

80103480 <picinit>:
80103480:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103485:	ba 21 00 00 00       	mov    $0x21,%edx
8010348a:	ee                   	out    %al,(%dx)
8010348b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103490:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103491:	c3                   	ret    
80103492:	66 90                	xchg   %ax,%ax
80103494:	66 90                	xchg   %ax,%ax
80103496:	66 90                	xchg   %ax,%ax
80103498:	66 90                	xchg   %ax,%ax
8010349a:	66 90                	xchg   %ax,%ax
8010349c:	66 90                	xchg   %ax,%ax
8010349e:	66 90                	xchg   %ax,%ax

801034a0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801034a0:	55                   	push   %ebp
801034a1:	89 e5                	mov    %esp,%ebp
801034a3:	57                   	push   %edi
801034a4:	56                   	push   %esi
801034a5:	53                   	push   %ebx
801034a6:	83 ec 0c             	sub    $0xc,%esp
801034a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801034ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801034af:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801034b5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801034bb:	e8 e0 d9 ff ff       	call   80100ea0 <filealloc>
801034c0:	89 03                	mov    %eax,(%ebx)
801034c2:	85 c0                	test   %eax,%eax
801034c4:	0f 84 a8 00 00 00    	je     80103572 <pipealloc+0xd2>
801034ca:	e8 d1 d9 ff ff       	call   80100ea0 <filealloc>
801034cf:	89 06                	mov    %eax,(%esi)
801034d1:	85 c0                	test   %eax,%eax
801034d3:	0f 84 87 00 00 00    	je     80103560 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801034d9:	e8 12 f2 ff ff       	call   801026f0 <kalloc>
801034de:	89 c7                	mov    %eax,%edi
801034e0:	85 c0                	test   %eax,%eax
801034e2:	0f 84 b0 00 00 00    	je     80103598 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
801034e8:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801034ef:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801034f2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801034f5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801034fc:	00 00 00 
  p->nwrite = 0;
801034ff:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103506:	00 00 00 
  p->nread = 0;
80103509:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103510:	00 00 00 
  initlock(&p->lock, "pipe");
80103513:	68 fb 82 10 80       	push   $0x801082fb
80103518:	50                   	push   %eax
80103519:	e8 b2 1a 00 00       	call   80104fd0 <initlock>
  (*f0)->type = FD_PIPE;
8010351e:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103520:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103523:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103529:	8b 03                	mov    (%ebx),%eax
8010352b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010352f:	8b 03                	mov    (%ebx),%eax
80103531:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103535:	8b 03                	mov    (%ebx),%eax
80103537:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010353a:	8b 06                	mov    (%esi),%eax
8010353c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103542:	8b 06                	mov    (%esi),%eax
80103544:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103548:	8b 06                	mov    (%esi),%eax
8010354a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010354e:	8b 06                	mov    (%esi),%eax
80103550:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103553:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103556:	31 c0                	xor    %eax,%eax
}
80103558:	5b                   	pop    %ebx
80103559:	5e                   	pop    %esi
8010355a:	5f                   	pop    %edi
8010355b:	5d                   	pop    %ebp
8010355c:	c3                   	ret    
8010355d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103560:	8b 03                	mov    (%ebx),%eax
80103562:	85 c0                	test   %eax,%eax
80103564:	74 1e                	je     80103584 <pipealloc+0xe4>
    fileclose(*f0);
80103566:	83 ec 0c             	sub    $0xc,%esp
80103569:	50                   	push   %eax
8010356a:	e8 f1 d9 ff ff       	call   80100f60 <fileclose>
8010356f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103572:	8b 06                	mov    (%esi),%eax
80103574:	85 c0                	test   %eax,%eax
80103576:	74 0c                	je     80103584 <pipealloc+0xe4>
    fileclose(*f1);
80103578:	83 ec 0c             	sub    $0xc,%esp
8010357b:	50                   	push   %eax
8010357c:	e8 df d9 ff ff       	call   80100f60 <fileclose>
80103581:	83 c4 10             	add    $0x10,%esp
}
80103584:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103587:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010358c:	5b                   	pop    %ebx
8010358d:	5e                   	pop    %esi
8010358e:	5f                   	pop    %edi
8010358f:	5d                   	pop    %ebp
80103590:	c3                   	ret    
80103591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103598:	8b 03                	mov    (%ebx),%eax
8010359a:	85 c0                	test   %eax,%eax
8010359c:	75 c8                	jne    80103566 <pipealloc+0xc6>
8010359e:	eb d2                	jmp    80103572 <pipealloc+0xd2>

801035a0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801035a0:	55                   	push   %ebp
801035a1:	89 e5                	mov    %esp,%ebp
801035a3:	56                   	push   %esi
801035a4:	53                   	push   %ebx
801035a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801035a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801035ab:	83 ec 0c             	sub    $0xc,%esp
801035ae:	53                   	push   %ebx
801035af:	e8 ec 1b 00 00       	call   801051a0 <acquire>
  if(writable){
801035b4:	83 c4 10             	add    $0x10,%esp
801035b7:	85 f6                	test   %esi,%esi
801035b9:	74 65                	je     80103620 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
801035bb:	83 ec 0c             	sub    $0xc,%esp
801035be:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801035c4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801035cb:	00 00 00 
    wakeup(&p->nread);
801035ce:	50                   	push   %eax
801035cf:	e8 cc 0e 00 00       	call   801044a0 <wakeup>
801035d4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801035d7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801035dd:	85 d2                	test   %edx,%edx
801035df:	75 0a                	jne    801035eb <pipeclose+0x4b>
801035e1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801035e7:	85 c0                	test   %eax,%eax
801035e9:	74 15                	je     80103600 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801035eb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801035ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035f1:	5b                   	pop    %ebx
801035f2:	5e                   	pop    %esi
801035f3:	5d                   	pop    %ebp
    release(&p->lock);
801035f4:	e9 47 1b 00 00       	jmp    80105140 <release>
801035f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103600:	83 ec 0c             	sub    $0xc,%esp
80103603:	53                   	push   %ebx
80103604:	e8 37 1b 00 00       	call   80105140 <release>
    kfree((char*)p);
80103609:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010360c:	83 c4 10             	add    $0x10,%esp
}
8010360f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103612:	5b                   	pop    %ebx
80103613:	5e                   	pop    %esi
80103614:	5d                   	pop    %ebp
    kfree((char*)p);
80103615:	e9 16 ef ff ff       	jmp    80102530 <kfree>
8010361a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103620:	83 ec 0c             	sub    $0xc,%esp
80103623:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103629:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103630:	00 00 00 
    wakeup(&p->nwrite);
80103633:	50                   	push   %eax
80103634:	e8 67 0e 00 00       	call   801044a0 <wakeup>
80103639:	83 c4 10             	add    $0x10,%esp
8010363c:	eb 99                	jmp    801035d7 <pipeclose+0x37>
8010363e:	66 90                	xchg   %ax,%ax

80103640 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103640:	55                   	push   %ebp
80103641:	89 e5                	mov    %esp,%ebp
80103643:	57                   	push   %edi
80103644:	56                   	push   %esi
80103645:	53                   	push   %ebx
80103646:	83 ec 28             	sub    $0x28,%esp
80103649:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010364c:	53                   	push   %ebx
8010364d:	e8 4e 1b 00 00       	call   801051a0 <acquire>
  for(i = 0; i < n; i++){
80103652:	8b 45 10             	mov    0x10(%ebp),%eax
80103655:	83 c4 10             	add    $0x10,%esp
80103658:	85 c0                	test   %eax,%eax
8010365a:	0f 8e c0 00 00 00    	jle    80103720 <pipewrite+0xe0>
80103660:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103663:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103669:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010366f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103672:	03 45 10             	add    0x10(%ebp),%eax
80103675:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103678:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010367e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103684:	89 ca                	mov    %ecx,%edx
80103686:	05 00 02 00 00       	add    $0x200,%eax
8010368b:	39 c1                	cmp    %eax,%ecx
8010368d:	74 3f                	je     801036ce <pipewrite+0x8e>
8010368f:	eb 67                	jmp    801036f8 <pipewrite+0xb8>
80103691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103698:	e8 93 03 00 00       	call   80103a30 <myproc>
8010369d:	8b 48 24             	mov    0x24(%eax),%ecx
801036a0:	85 c9                	test   %ecx,%ecx
801036a2:	75 34                	jne    801036d8 <pipewrite+0x98>
      wakeup(&p->nread);
801036a4:	83 ec 0c             	sub    $0xc,%esp
801036a7:	57                   	push   %edi
801036a8:	e8 f3 0d 00 00       	call   801044a0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801036ad:	58                   	pop    %eax
801036ae:	5a                   	pop    %edx
801036af:	53                   	push   %ebx
801036b0:	56                   	push   %esi
801036b1:	e8 2a 0d 00 00       	call   801043e0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036b6:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801036bc:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801036c2:	83 c4 10             	add    $0x10,%esp
801036c5:	05 00 02 00 00       	add    $0x200,%eax
801036ca:	39 c2                	cmp    %eax,%edx
801036cc:	75 2a                	jne    801036f8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
801036ce:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801036d4:	85 c0                	test   %eax,%eax
801036d6:	75 c0                	jne    80103698 <pipewrite+0x58>
        release(&p->lock);
801036d8:	83 ec 0c             	sub    $0xc,%esp
801036db:	53                   	push   %ebx
801036dc:	e8 5f 1a 00 00       	call   80105140 <release>
        return -1;
801036e1:	83 c4 10             	add    $0x10,%esp
801036e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801036e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036ec:	5b                   	pop    %ebx
801036ed:	5e                   	pop    %esi
801036ee:	5f                   	pop    %edi
801036ef:	5d                   	pop    %ebp
801036f0:	c3                   	ret    
801036f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036f8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801036fb:	8d 4a 01             	lea    0x1(%edx),%ecx
801036fe:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103704:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010370a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
8010370d:	83 c6 01             	add    $0x1,%esi
80103710:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103713:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103717:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010371a:	0f 85 58 ff ff ff    	jne    80103678 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103720:	83 ec 0c             	sub    $0xc,%esp
80103723:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103729:	50                   	push   %eax
8010372a:	e8 71 0d 00 00       	call   801044a0 <wakeup>
  release(&p->lock);
8010372f:	89 1c 24             	mov    %ebx,(%esp)
80103732:	e8 09 1a 00 00       	call   80105140 <release>
  return n;
80103737:	8b 45 10             	mov    0x10(%ebp),%eax
8010373a:	83 c4 10             	add    $0x10,%esp
8010373d:	eb aa                	jmp    801036e9 <pipewrite+0xa9>
8010373f:	90                   	nop

80103740 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103740:	55                   	push   %ebp
80103741:	89 e5                	mov    %esp,%ebp
80103743:	57                   	push   %edi
80103744:	56                   	push   %esi
80103745:	53                   	push   %ebx
80103746:	83 ec 18             	sub    $0x18,%esp
80103749:	8b 75 08             	mov    0x8(%ebp),%esi
8010374c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010374f:	56                   	push   %esi
80103750:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103756:	e8 45 1a 00 00       	call   801051a0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010375b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103761:	83 c4 10             	add    $0x10,%esp
80103764:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010376a:	74 2f                	je     8010379b <piperead+0x5b>
8010376c:	eb 37                	jmp    801037a5 <piperead+0x65>
8010376e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103770:	e8 bb 02 00 00       	call   80103a30 <myproc>
80103775:	8b 48 24             	mov    0x24(%eax),%ecx
80103778:	85 c9                	test   %ecx,%ecx
8010377a:	0f 85 80 00 00 00    	jne    80103800 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103780:	83 ec 08             	sub    $0x8,%esp
80103783:	56                   	push   %esi
80103784:	53                   	push   %ebx
80103785:	e8 56 0c 00 00       	call   801043e0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010378a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103790:	83 c4 10             	add    $0x10,%esp
80103793:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103799:	75 0a                	jne    801037a5 <piperead+0x65>
8010379b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
801037a1:	85 c0                	test   %eax,%eax
801037a3:	75 cb                	jne    80103770 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037a5:	8b 55 10             	mov    0x10(%ebp),%edx
801037a8:	31 db                	xor    %ebx,%ebx
801037aa:	85 d2                	test   %edx,%edx
801037ac:	7f 20                	jg     801037ce <piperead+0x8e>
801037ae:	eb 2c                	jmp    801037dc <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801037b0:	8d 48 01             	lea    0x1(%eax),%ecx
801037b3:	25 ff 01 00 00       	and    $0x1ff,%eax
801037b8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801037be:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801037c3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037c6:	83 c3 01             	add    $0x1,%ebx
801037c9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801037cc:	74 0e                	je     801037dc <piperead+0x9c>
    if(p->nread == p->nwrite)
801037ce:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801037d4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801037da:	75 d4                	jne    801037b0 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801037dc:	83 ec 0c             	sub    $0xc,%esp
801037df:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801037e5:	50                   	push   %eax
801037e6:	e8 b5 0c 00 00       	call   801044a0 <wakeup>
  release(&p->lock);
801037eb:	89 34 24             	mov    %esi,(%esp)
801037ee:	e8 4d 19 00 00       	call   80105140 <release>
  return i;
801037f3:	83 c4 10             	add    $0x10,%esp
}
801037f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037f9:	89 d8                	mov    %ebx,%eax
801037fb:	5b                   	pop    %ebx
801037fc:	5e                   	pop    %esi
801037fd:	5f                   	pop    %edi
801037fe:	5d                   	pop    %ebp
801037ff:	c3                   	ret    
      release(&p->lock);
80103800:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103803:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103808:	56                   	push   %esi
80103809:	e8 32 19 00 00       	call   80105140 <release>
      return -1;
8010380e:	83 c4 10             	add    $0x10,%esp
}
80103811:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103814:	89 d8                	mov    %ebx,%eax
80103816:	5b                   	pop    %ebx
80103817:	5e                   	pop    %esi
80103818:	5f                   	pop    %edi
80103819:	5d                   	pop    %ebp
8010381a:	c3                   	ret    
8010381b:	66 90                	xchg   %ax,%ax
8010381d:	66 90                	xchg   %ax,%ax
8010381f:	90                   	nop

80103820 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103824:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
80103829:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010382c:	68 20 2d 11 80       	push   $0x80112d20
80103831:	e8 6a 19 00 00       	call   801051a0 <acquire>
80103836:	83 c4 10             	add    $0x10,%esp
80103839:	eb 13                	jmp    8010384e <allocproc+0x2e>
8010383b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010383f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103840:	81 c3 b8 00 00 00    	add    $0xb8,%ebx
80103846:	81 fb 54 5b 11 80    	cmp    $0x80115b54,%ebx
8010384c:	74 7a                	je     801038c8 <allocproc+0xa8>
    if(p->state == UNUSED)
8010384e:	8b 43 0c             	mov    0xc(%ebx),%eax
80103851:	85 c0                	test   %eax,%eax
80103853:	75 eb                	jne    80103840 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103855:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
8010385a:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010385d:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103864:	89 43 10             	mov    %eax,0x10(%ebx)
80103867:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
8010386a:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
8010386f:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103875:	e8 c6 18 00 00       	call   80105140 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010387a:	e8 71 ee ff ff       	call   801026f0 <kalloc>
8010387f:	83 c4 10             	add    $0x10,%esp
80103882:	89 43 08             	mov    %eax,0x8(%ebx)
80103885:	85 c0                	test   %eax,%eax
80103887:	74 58                	je     801038e1 <allocproc+0xc1>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103889:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010388f:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103892:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103897:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
8010389a:	c7 40 14 67 64 10 80 	movl   $0x80106467,0x14(%eax)
  p->context = (struct context*)sp;
801038a1:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801038a4:	6a 14                	push   $0x14
801038a6:	6a 00                	push   $0x0
801038a8:	50                   	push   %eax
801038a9:	e8 b2 19 00 00       	call   80105260 <memset>
  p->context->eip = (uint)forkret;
801038ae:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801038b1:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801038b4:	c7 40 10 00 39 10 80 	movl   $0x80103900,0x10(%eax)
}
801038bb:	89 d8                	mov    %ebx,%eax
801038bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038c0:	c9                   	leave  
801038c1:	c3                   	ret    
801038c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801038c8:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801038cb:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801038cd:	68 20 2d 11 80       	push   $0x80112d20
801038d2:	e8 69 18 00 00       	call   80105140 <release>
}
801038d7:	89 d8                	mov    %ebx,%eax
  return 0;
801038d9:	83 c4 10             	add    $0x10,%esp
}
801038dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038df:	c9                   	leave  
801038e0:	c3                   	ret    
    p->state = UNUSED;
801038e1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801038e8:	31 db                	xor    %ebx,%ebx
}
801038ea:	89 d8                	mov    %ebx,%eax
801038ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038ef:	c9                   	leave  
801038f0:	c3                   	ret    
801038f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038ff:	90                   	nop

80103900 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103906:	68 20 2d 11 80       	push   $0x80112d20
8010390b:	e8 30 18 00 00       	call   80105140 <release>

  if (first) {
80103910:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103915:	83 c4 10             	add    $0x10,%esp
80103918:	85 c0                	test   %eax,%eax
8010391a:	75 04                	jne    80103920 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010391c:	c9                   	leave  
8010391d:	c3                   	ret    
8010391e:	66 90                	xchg   %ax,%ax
    first = 0;
80103920:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103927:	00 00 00 
    iinit(ROOTDEV);
8010392a:	83 ec 0c             	sub    $0xc,%esp
8010392d:	6a 01                	push   $0x1
8010392f:	e8 9c dc ff ff       	call   801015d0 <iinit>
    initlog(ROOTDEV);
80103934:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010393b:	e8 f0 f3 ff ff       	call   80102d30 <initlog>
}
80103940:	83 c4 10             	add    $0x10,%esp
80103943:	c9                   	leave  
80103944:	c3                   	ret    
80103945:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010394c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103950 <change_num>:
change_num(struct proc* p, int inc_or_dec){
80103950:	55                   	push   %ebp
80103951:	89 e5                	mov    %esp,%ebp
  if(p->queue==CLASS1){
80103953:	8b 45 08             	mov    0x8(%ebp),%eax
change_num(struct proc* p, int inc_or_dec){
80103956:	8b 55 0c             	mov    0xc(%ebp),%edx
  if(p->queue==CLASS1){
80103959:	8b 40 7c             	mov    0x7c(%eax),%eax
8010395c:	85 c0                	test   %eax,%eax
8010395e:	75 10                	jne    80103970 <change_num+0x20>
    ptable.class1_num = ptable.class1_num + inc_or_dec;
80103960:	01 15 54 5b 11 80    	add    %edx,0x80115b54
}
80103966:	5d                   	pop    %ebp
80103967:	c3                   	ret    
80103968:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010396f:	90                   	nop
    if(p->queue==CLASS2_RR){
80103970:	83 f8 01             	cmp    $0x1,%eax
80103973:	74 0b                	je     80103980 <change_num+0x30>
      ptable.fcfs_num = ptable.fcfs_num + inc_or_dec;
80103975:	01 15 5c 5b 11 80    	add    %edx,0x80115b5c
}
8010397b:	5d                   	pop    %ebp
8010397c:	c3                   	ret    
8010397d:	8d 76 00             	lea    0x0(%esi),%esi
      ptable.rr_num = ptable.rr_num + inc_or_dec;
80103980:	01 15 58 5b 11 80    	add    %edx,0x80115b58
}
80103986:	5d                   	pop    %ebp
80103987:	c3                   	ret    
80103988:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010398f:	90                   	nop

80103990 <pinit>:
{
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103996:	68 00 83 10 80       	push   $0x80108300
8010399b:	68 20 2d 11 80       	push   $0x80112d20
801039a0:	e8 2b 16 00 00       	call   80104fd0 <initlock>
}
801039a5:	83 c4 10             	add    $0x10,%esp
801039a8:	c9                   	leave  
801039a9:	c3                   	ret    
801039aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801039b0 <mycpu>:
{
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	56                   	push   %esi
801039b4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801039b5:	9c                   	pushf  
801039b6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801039b7:	f6 c4 02             	test   $0x2,%ah
801039ba:	75 46                	jne    80103a02 <mycpu+0x52>
  apicid = lapicid();
801039bc:	e8 9f ef ff ff       	call   80102960 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801039c1:	8b 35 84 27 11 80    	mov    0x80112784,%esi
801039c7:	85 f6                	test   %esi,%esi
801039c9:	7e 2a                	jle    801039f5 <mycpu+0x45>
801039cb:	31 d2                	xor    %edx,%edx
801039cd:	eb 08                	jmp    801039d7 <mycpu+0x27>
801039cf:	90                   	nop
801039d0:	83 c2 01             	add    $0x1,%edx
801039d3:	39 f2                	cmp    %esi,%edx
801039d5:	74 1e                	je     801039f5 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
801039d7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801039dd:	0f b6 99 a0 27 11 80 	movzbl -0x7feed860(%ecx),%ebx
801039e4:	39 c3                	cmp    %eax,%ebx
801039e6:	75 e8                	jne    801039d0 <mycpu+0x20>
}
801039e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
801039eb:	8d 81 a0 27 11 80    	lea    -0x7feed860(%ecx),%eax
}
801039f1:	5b                   	pop    %ebx
801039f2:	5e                   	pop    %esi
801039f3:	5d                   	pop    %ebp
801039f4:	c3                   	ret    
  panic("unknown apicid\n");
801039f5:	83 ec 0c             	sub    $0xc,%esp
801039f8:	68 07 83 10 80       	push   $0x80108307
801039fd:	e8 7e c9 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103a02:	83 ec 0c             	sub    $0xc,%esp
80103a05:	68 74 84 10 80       	push   $0x80108474
80103a0a:	e8 71 c9 ff ff       	call   80100380 <panic>
80103a0f:	90                   	nop

80103a10 <cpuid>:
cpuid() {
80103a10:	55                   	push   %ebp
80103a11:	89 e5                	mov    %esp,%ebp
80103a13:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103a16:	e8 95 ff ff ff       	call   801039b0 <mycpu>
}
80103a1b:	c9                   	leave  
  return mycpu()-cpus;
80103a1c:	2d a0 27 11 80       	sub    $0x801127a0,%eax
80103a21:	c1 f8 04             	sar    $0x4,%eax
80103a24:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103a2a:	c3                   	ret    
80103a2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a2f:	90                   	nop

80103a30 <myproc>:
myproc(void) {
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	53                   	push   %ebx
80103a34:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103a37:	e8 14 16 00 00       	call   80105050 <pushcli>
  c = mycpu();
80103a3c:	e8 6f ff ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80103a41:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a47:	e8 54 16 00 00       	call   801050a0 <popcli>
}
80103a4c:	89 d8                	mov    %ebx,%eax
80103a4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a51:	c9                   	leave  
80103a52:	c3                   	ret    
80103a53:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a60 <userinit>:
{
80103a60:	55                   	push   %ebp
80103a61:	89 e5                	mov    %esp,%ebp
80103a63:	53                   	push   %ebx
80103a64:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103a67:	e8 b4 fd ff ff       	call   80103820 <allocproc>
80103a6c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103a6e:	a3 60 5b 11 80       	mov    %eax,0x80115b60
  if((p->pgdir = setupkvm()) == 0)
80103a73:	e8 e8 3f 00 00       	call   80107a60 <setupkvm>
80103a78:	89 43 04             	mov    %eax,0x4(%ebx)
80103a7b:	85 c0                	test   %eax,%eax
80103a7d:	0f 84 ea 00 00 00    	je     80103b6d <userinit+0x10d>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a83:	83 ec 04             	sub    $0x4,%esp
80103a86:	68 2c 00 00 00       	push   $0x2c
80103a8b:	68 60 b4 10 80       	push   $0x8010b460
80103a90:	50                   	push   %eax
80103a91:	e8 7a 3c 00 00       	call   80107710 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a96:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a99:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a9f:	6a 4c                	push   $0x4c
80103aa1:	6a 00                	push   $0x0
80103aa3:	ff 73 18             	push   0x18(%ebx)
80103aa6:	e8 b5 17 00 00       	call   80105260 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103aab:	8b 43 18             	mov    0x18(%ebx),%eax
80103aae:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103ab3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ab6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103abb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103abf:	8b 43 18             	mov    0x18(%ebx),%eax
80103ac2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103ac6:	8b 43 18             	mov    0x18(%ebx),%eax
80103ac9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103acd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103ad1:	8b 43 18             	mov    0x18(%ebx),%eax
80103ad4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ad8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103adc:	8b 43 18             	mov    0x18(%ebx),%eax
80103adf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103ae6:	8b 43 18             	mov    0x18(%ebx),%eax
80103ae9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103af0:	8b 43 18             	mov    0x18(%ebx),%eax
80103af3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103afa:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103afd:	6a 10                	push   $0x10
80103aff:	68 30 83 10 80       	push   $0x80108330
80103b04:	50                   	push   %eax
80103b05:	e8 16 19 00 00       	call   80105420 <safestrcpy>
  p->cwd = namei("/");
80103b0a:	c7 04 24 39 83 10 80 	movl   $0x80108339,(%esp)
80103b11:	e8 fa e5 ff ff       	call   80102110 <namei>
80103b16:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103b19:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b20:	e8 7b 16 00 00       	call   801051a0 <acquire>
  p->arrival_time = ticks;
80103b25:	a1 80 5b 11 80       	mov    0x80115b80,%eax
  p->state = RUNNABLE;
80103b2a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  p->deadline = 0;
80103b31:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103b38:	00 00 00 
  p->arrival_time = ticks;
80103b3b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
  p->queue = CLASS2_RR;
80103b41:	c7 43 7c 01 00 00 00 	movl   $0x1,0x7c(%ebx)
  p->age = 0;
80103b48:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103b4f:	00 00 00 
  release(&ptable.lock);
80103b52:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
      ptable.rr_num = ptable.rr_num + inc_or_dec;
80103b59:	83 05 58 5b 11 80 01 	addl   $0x1,0x80115b58
  release(&ptable.lock);
80103b60:	e8 db 15 00 00       	call   80105140 <release>
}
80103b65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b68:	83 c4 10             	add    $0x10,%esp
80103b6b:	c9                   	leave  
80103b6c:	c3                   	ret    
    panic("userinit: out of memory?");
80103b6d:	83 ec 0c             	sub    $0xc,%esp
80103b70:	68 17 83 10 80       	push   $0x80108317
80103b75:	e8 06 c8 ff ff       	call   80100380 <panic>
80103b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b80 <growproc>:
{
80103b80:	55                   	push   %ebp
80103b81:	89 e5                	mov    %esp,%ebp
80103b83:	56                   	push   %esi
80103b84:	53                   	push   %ebx
80103b85:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103b88:	e8 c3 14 00 00       	call   80105050 <pushcli>
  c = mycpu();
80103b8d:	e8 1e fe ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80103b92:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b98:	e8 03 15 00 00       	call   801050a0 <popcli>
  sz = curproc->sz;
80103b9d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103b9f:	85 f6                	test   %esi,%esi
80103ba1:	7f 1d                	jg     80103bc0 <growproc+0x40>
  } else if(n < 0){
80103ba3:	75 3b                	jne    80103be0 <growproc+0x60>
  switchuvm(curproc);
80103ba5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103ba8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103baa:	53                   	push   %ebx
80103bab:	e8 50 3a 00 00       	call   80107600 <switchuvm>
  return 0;
80103bb0:	83 c4 10             	add    $0x10,%esp
80103bb3:	31 c0                	xor    %eax,%eax
}
80103bb5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bb8:	5b                   	pop    %ebx
80103bb9:	5e                   	pop    %esi
80103bba:	5d                   	pop    %ebp
80103bbb:	c3                   	ret    
80103bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103bc0:	83 ec 04             	sub    $0x4,%esp
80103bc3:	01 c6                	add    %eax,%esi
80103bc5:	56                   	push   %esi
80103bc6:	50                   	push   %eax
80103bc7:	ff 73 04             	push   0x4(%ebx)
80103bca:	e8 b1 3c 00 00       	call   80107880 <allocuvm>
80103bcf:	83 c4 10             	add    $0x10,%esp
80103bd2:	85 c0                	test   %eax,%eax
80103bd4:	75 cf                	jne    80103ba5 <growproc+0x25>
      return -1;
80103bd6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103bdb:	eb d8                	jmp    80103bb5 <growproc+0x35>
80103bdd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103be0:	83 ec 04             	sub    $0x4,%esp
80103be3:	01 c6                	add    %eax,%esi
80103be5:	56                   	push   %esi
80103be6:	50                   	push   %eax
80103be7:	ff 73 04             	push   0x4(%ebx)
80103bea:	e8 c1 3d 00 00       	call   801079b0 <deallocuvm>
80103bef:	83 c4 10             	add    $0x10,%esp
80103bf2:	85 c0                	test   %eax,%eax
80103bf4:	75 af                	jne    80103ba5 <growproc+0x25>
80103bf6:	eb de                	jmp    80103bd6 <growproc+0x56>
80103bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bff:	90                   	nop

80103c00 <fork>:
{
80103c00:	55                   	push   %ebp
80103c01:	89 e5                	mov    %esp,%ebp
80103c03:	57                   	push   %edi
80103c04:	56                   	push   %esi
80103c05:	53                   	push   %ebx
80103c06:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103c09:	e8 42 14 00 00       	call   80105050 <pushcli>
  c = mycpu();
80103c0e:	e8 9d fd ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80103c13:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80103c19:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  popcli();
80103c1c:	e8 7f 14 00 00       	call   801050a0 <popcli>
  if((np = allocproc()) == 0){
80103c21:	e8 fa fb ff ff       	call   80103820 <allocproc>
80103c26:	85 c0                	test   %eax,%eax
80103c28:	0f 84 3f 01 00 00    	je     80103d6d <fork+0x16d>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103c2e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103c31:	83 ec 08             	sub    $0x8,%esp
80103c34:	89 c3                	mov    %eax,%ebx
80103c36:	ff 32                	push   (%edx)
80103c38:	ff 72 04             	push   0x4(%edx)
80103c3b:	e8 10 3f 00 00       	call   80107b50 <copyuvm>
80103c40:	83 c4 10             	add    $0x10,%esp
80103c43:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103c46:	85 c0                	test   %eax,%eax
80103c48:	89 43 04             	mov    %eax,0x4(%ebx)
80103c4b:	0f 84 23 01 00 00    	je     80103d74 <fork+0x174>
  np->sz = curproc->sz;
80103c51:	8b 02                	mov    (%edx),%eax
  *np->tf = *curproc->tf;
80103c53:	8b 7b 18             	mov    0x18(%ebx),%edi
  np->parent = curproc;
80103c56:	89 53 14             	mov    %edx,0x14(%ebx)
  *np->tf = *curproc->tf;
80103c59:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
80103c5e:	89 03                	mov    %eax,(%ebx)
  *np->tf = *curproc->tf;
80103c60:	8b 72 18             	mov    0x18(%edx),%esi
80103c63:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103c65:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103c67:	8b 43 18             	mov    0x18(%ebx),%eax
80103c6a:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103c71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103c78:	8b 44 b2 28          	mov    0x28(%edx,%esi,4),%eax
80103c7c:	85 c0                	test   %eax,%eax
80103c7e:	74 16                	je     80103c96 <fork+0x96>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103c80:	83 ec 0c             	sub    $0xc,%esp
80103c83:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103c86:	50                   	push   %eax
80103c87:	e8 84 d2 ff ff       	call   80100f10 <filedup>
80103c8c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103c8f:	83 c4 10             	add    $0x10,%esp
80103c92:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103c96:	83 c6 01             	add    $0x1,%esi
80103c99:	83 fe 10             	cmp    $0x10,%esi
80103c9c:	75 da                	jne    80103c78 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80103c9e:	83 ec 0c             	sub    $0xc,%esp
80103ca1:	ff 72 68             	push   0x68(%edx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ca4:	8d 73 6c             	lea    0x6c(%ebx),%esi
  np->cwd = idup(curproc->cwd);
80103ca7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103caa:	e8 11 db ff ff       	call   801017c0 <idup>
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103caf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103cb2:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103cb5:	89 43 68             	mov    %eax,0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103cb8:	83 c2 6c             	add    $0x6c,%edx
80103cbb:	6a 10                	push   $0x10
80103cbd:	52                   	push   %edx
80103cbe:	56                   	push   %esi
80103cbf:	e8 5c 17 00 00       	call   80105420 <safestrcpy>
  pid = np->pid;
80103cc4:	8b 7b 10             	mov    0x10(%ebx),%edi
  acquire(&ptable.lock);
80103cc7:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103cce:	e8 cd 14 00 00       	call   801051a0 <acquire>
  np->arrival_time = ticks;
80103cd3:	a1 80 5b 11 80       	mov    0x80115b80,%eax
  if (strncmp(np->name,"sh",3)||strncmp(np->parent->name,"sh",3)){
80103cd8:	83 c4 0c             	add    $0xc,%esp
  np->state = RUNNABLE;
80103cdb:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  np->deadline = 0;
80103ce2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103ce9:	00 00 00 
  np->arrival_time = ticks;
80103cec:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
  np->age=0;
80103cf2:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103cf9:	00 00 00 
  np->queue = CLASS2_FCFS;
80103cfc:	c7 43 7c 02 00 00 00 	movl   $0x2,0x7c(%ebx)
  if (strncmp(np->name,"sh",3)||strncmp(np->parent->name,"sh",3)){
80103d03:	6a 03                	push   $0x3
80103d05:	68 4d 7e 10 80       	push   $0x80107e4d
80103d0a:	56                   	push   %esi
80103d0b:	e8 60 16 00 00       	call   80105370 <strncmp>
80103d10:	83 c4 10             	add    $0x10,%esp
80103d13:	85 c0                	test   %eax,%eax
80103d15:	74 29                	je     80103d40 <fork+0x140>
80103d17:	c7 43 7c 01 00 00 00 	movl   $0x1,0x7c(%ebx)
      ptable.rr_num = ptable.rr_num + inc_or_dec;
80103d1e:	83 05 58 5b 11 80 01 	addl   $0x1,0x80115b58
  release(&ptable.lock);
80103d25:	83 ec 0c             	sub    $0xc,%esp
80103d28:	68 20 2d 11 80       	push   $0x80112d20
80103d2d:	e8 0e 14 00 00       	call   80105140 <release>
  return pid;
80103d32:	83 c4 10             	add    $0x10,%esp
}
80103d35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d38:	89 f8                	mov    %edi,%eax
80103d3a:	5b                   	pop    %ebx
80103d3b:	5e                   	pop    %esi
80103d3c:	5f                   	pop    %edi
80103d3d:	5d                   	pop    %ebp
80103d3e:	c3                   	ret    
80103d3f:	90                   	nop
  if (strncmp(np->name,"sh",3)||strncmp(np->parent->name,"sh",3)){
80103d40:	83 ec 04             	sub    $0x4,%esp
80103d43:	6a 03                	push   $0x3
80103d45:	68 4d 7e 10 80       	push   $0x80107e4d
80103d4a:	8b 43 14             	mov    0x14(%ebx),%eax
80103d4d:	83 c0 6c             	add    $0x6c,%eax
80103d50:	50                   	push   %eax
80103d51:	e8 1a 16 00 00       	call   80105370 <strncmp>
80103d56:	83 c4 10             	add    $0x10,%esp
80103d59:	85 c0                	test   %eax,%eax
80103d5b:	75 ba                	jne    80103d17 <fork+0x117>
80103d5d:	c7 43 7c 02 00 00 00 	movl   $0x2,0x7c(%ebx)
      ptable.fcfs_num = ptable.fcfs_num + inc_or_dec;
80103d64:	83 05 5c 5b 11 80 01 	addl   $0x1,0x80115b5c
80103d6b:	eb b8                	jmp    80103d25 <fork+0x125>
    return -1;
80103d6d:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80103d72:	eb c1                	jmp    80103d35 <fork+0x135>
    kfree(np->kstack);
80103d74:	83 ec 0c             	sub    $0xc,%esp
80103d77:	ff 73 08             	push   0x8(%ebx)
    return -1;
80103d7a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
    kfree(np->kstack);
80103d7f:	e8 ac e7 ff ff       	call   80102530 <kfree>
    np->kstack = 0;
80103d84:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103d8b:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103d8e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103d95:	eb 9e                	jmp    80103d35 <fork+0x135>
80103d97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d9e:	66 90                	xchg   %ax,%ax

80103da0 <scheduler>:
{
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	57                   	push   %edi
80103da4:	56                   	push   %esi
80103da5:	53                   	push   %ebx
80103da6:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103da9:	e8 02 fc ff ff       	call   801039b0 <mycpu>
  c->proc = 0;
80103dae:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103db5:	00 00 00 
  struct cpu *c = mycpu();
80103db8:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103dba:	8d 40 04             	lea    0x4(%eax),%eax
80103dbd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  asm volatile("sti");
80103dc0:	fb                   	sti    
    acquire(&ptable.lock);
80103dc1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dc4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103dc9:	68 20 2d 11 80       	push   $0x80112d20
80103dce:	e8 cd 13 00 00       	call   801051a0 <acquire>
80103dd3:	83 c4 10             	add    $0x10,%esp
80103dd6:	eb 16                	jmp    80103dee <scheduler+0x4e>
80103dd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ddf:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103de0:	81 c3 b8 00 00 00    	add    $0xb8,%ebx
80103de6:	81 fb 54 5b 11 80    	cmp    $0x80115b54,%ebx
80103dec:	74 5a                	je     80103e48 <scheduler+0xa8>
        if(p->state==RUNNABLE && p->queue==CLASS2_FCFS){
80103dee:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103df2:	75 ec                	jne    80103de0 <scheduler+0x40>
80103df4:	83 7b 7c 02          	cmpl   $0x2,0x7c(%ebx)
80103df8:	75 e6                	jne    80103de0 <scheduler+0x40>
          p->age++;    
80103dfa:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
80103e00:	83 c0 01             	add    $0x1,%eax
80103e03:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
          if(p->age>=800){
80103e09:	3d 1f 03 00 00       	cmp    $0x31f,%eax
80103e0e:	76 d0                	jbe    80103de0 <scheduler+0x40>
            cprintf("PID %d: got increased priority to RR due to growing old!\n",p->pid);
80103e10:	83 ec 08             	sub    $0x8,%esp
            p->queue = CLASS2_RR ;
80103e13:	c7 43 7c 01 00 00 00 	movl   $0x1,0x7c(%ebx)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e1a:	81 c3 b8 00 00 00    	add    $0xb8,%ebx
            p->age = 0;
80103e20:	c7 43 d0 00 00 00 00 	movl   $0x0,-0x30(%ebx)
            cprintf("PID %d: got increased priority to RR due to growing old!\n",p->pid);
80103e27:	ff b3 58 ff ff ff    	push   -0xa8(%ebx)
80103e2d:	68 9c 84 10 80       	push   $0x8010849c
80103e32:	e8 69 c8 ff ff       	call   801006a0 <cprintf>
80103e37:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e3a:	81 fb 54 5b 11 80    	cmp    $0x80115b54,%ebx
80103e40:	75 ac                	jne    80103dee <scheduler+0x4e>
80103e42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ptable.class1_num>0){
80103e48:	8b 0d 54 5b 11 80    	mov    0x80115b54,%ecx
80103e4e:	85 c9                	test   %ecx,%ecx
80103e50:	7f 33                	jg     80103e85 <scheduler+0xe5>
      if(!runable_p && ptable.rr_num>0){
80103e52:	8b 1d 58 5b 11 80    	mov    0x80115b58,%ebx
80103e58:	85 db                	test   %ebx,%ebx
80103e5a:	0f 8f e7 00 00 00    	jg     80103f47 <scheduler+0x1a7>
      if(!runable_p && ptable.fcfs_num>0){
80103e60:	8b 0d 5c 5b 11 80    	mov    0x80115b5c,%ecx
80103e66:	85 c9                	test   %ecx,%ecx
80103e68:	0f 8f 11 01 00 00    	jg     80103f7f <scheduler+0x1df>
80103e6e:	66 90                	xchg   %ax,%ax
    release(&ptable.lock);
80103e70:	83 ec 0c             	sub    $0xc,%esp
80103e73:	68 20 2d 11 80       	push   $0x80112d20
80103e78:	e8 c3 12 00 00       	call   80105140 <release>
  for(;;){
80103e7d:	83 c4 10             	add    $0x10,%esp
80103e80:	e9 3b ff ff ff       	jmp    80103dc0 <scheduler+0x20>
          int argMin = ticks - p->deadline ;
80103e85:	8b 3d 80 5b 11 80    	mov    0x80115b80,%edi
      int min_dead = 1000000;
80103e8b:	b9 40 42 0f 00       	mov    $0xf4240,%ecx
      struct proc *runable_p = 0;
80103e90:	31 db                	xor    %ebx,%ebx
      for(p=ptable.proc; p <&ptable.proc[NPROC]; p++){
80103e92:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e97:	eb 13                	jmp    80103eac <scheduler+0x10c>
80103e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ea0:	05 b8 00 00 00       	add    $0xb8,%eax
80103ea5:	3d 54 5b 11 80       	cmp    $0x80115b54,%eax
80103eaa:	74 2d                	je     80103ed9 <scheduler+0x139>
        if(p->state==RUNNABLE && p->queue==CLASS1){
80103eac:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103eb0:	75 ee                	jne    80103ea0 <scheduler+0x100>
80103eb2:	8b 50 7c             	mov    0x7c(%eax),%edx
80103eb5:	85 d2                	test   %edx,%edx
80103eb7:	75 e7                	jne    80103ea0 <scheduler+0x100>
          int argMin = ticks - p->deadline ;
80103eb9:	89 fa                	mov    %edi,%edx
80103ebb:	2b 90 84 00 00 00    	sub    0x84(%eax),%edx
          if(!runable_p || argMin<min_dead){
80103ec1:	85 db                	test   %ebx,%ebx
80103ec3:	74 04                	je     80103ec9 <scheduler+0x129>
80103ec5:	39 ca                	cmp    %ecx,%edx
80103ec7:	7d d7                	jge    80103ea0 <scheduler+0x100>
80103ec9:	89 c3                	mov    %eax,%ebx
      for(p=ptable.proc; p <&ptable.proc[NPROC]; p++){
80103ecb:	05 b8 00 00 00       	add    $0xb8,%eax
          int argMin = ticks - p->deadline ;
80103ed0:	89 d1                	mov    %edx,%ecx
      for(p=ptable.proc; p <&ptable.proc[NPROC]; p++){
80103ed2:	3d 54 5b 11 80       	cmp    $0x80115b54,%eax
80103ed7:	75 d3                	jne    80103eac <scheduler+0x10c>
      if(!runable_p && ptable.rr_num>0){
80103ed9:	85 db                	test   %ebx,%ebx
80103edb:	0f 84 71 ff ff ff    	je     80103e52 <scheduler+0xb2>
        c->proc = runable_p;
80103ee1:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
  if(p->queue==CLASS1){
80103ee7:	8b 43 7c             	mov    0x7c(%ebx),%eax
80103eea:	85 c0                	test   %eax,%eax
80103eec:	75 4b                	jne    80103f39 <scheduler+0x199>
    ptable.class1_num = ptable.class1_num + inc_or_dec;
80103eee:	83 2d 54 5b 11 80 01 	subl   $0x1,0x80115b54
        if(runable_p->queue==CLASS2_FCFS){
80103ef5:	83 7b 7c 02          	cmpl   $0x2,0x7c(%ebx)
80103ef9:	75 0a                	jne    80103f05 <scheduler+0x165>
          runable_p->age = 0;
80103efb:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103f02:	00 00 00 
        switchuvm(runable_p);
80103f05:	83 ec 0c             	sub    $0xc,%esp
80103f08:	53                   	push   %ebx
80103f09:	e8 f2 36 00 00       	call   80107600 <switchuvm>
        runable_p->state = RUNNING;
80103f0e:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
        swtch(&(c->scheduler),runable_p->context);
80103f15:	58                   	pop    %eax
80103f16:	5a                   	pop    %edx
80103f17:	ff 73 1c             	push   0x1c(%ebx)
80103f1a:	ff 75 e4             	push   -0x1c(%ebp)
80103f1d:	e8 59 15 00 00       	call   8010547b <swtch>
      switchkvm();
80103f22:	e8 c9 36 00 00       	call   801075f0 <switchkvm>
      c->proc = 0;
80103f27:	83 c4 10             	add    $0x10,%esp
80103f2a:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103f31:	00 00 00 
80103f34:	e9 37 ff ff ff       	jmp    80103e70 <scheduler+0xd0>
    if(p->queue==CLASS2_RR){
80103f39:	83 f8 01             	cmp    $0x1,%eax
80103f3c:	74 35                	je     80103f73 <scheduler+0x1d3>
      ptable.fcfs_num = ptable.fcfs_num + inc_or_dec;
80103f3e:	83 2d 5c 5b 11 80 01 	subl   $0x1,0x80115b5c
80103f45:	eb ae                	jmp    80103ef5 <scheduler+0x155>
        for(p=ptable.proc; p <&ptable.proc[NPROC]; p++){
80103f47:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103f4c:	eb 14                	jmp    80103f62 <scheduler+0x1c2>
80103f4e:	66 90                	xchg   %ax,%ax
80103f50:	81 c3 b8 00 00 00    	add    $0xb8,%ebx
80103f56:	81 fb 54 5b 11 80    	cmp    $0x80115b54,%ebx
80103f5c:	0f 84 fe fe ff ff    	je     80103e60 <scheduler+0xc0>
          if(p->state==RUNNABLE && p->queue==CLASS2_RR){
80103f62:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103f66:	75 e8                	jne    80103f50 <scheduler+0x1b0>
80103f68:	83 7b 7c 01          	cmpl   $0x1,0x7c(%ebx)
80103f6c:	75 e2                	jne    80103f50 <scheduler+0x1b0>
80103f6e:	e9 6e ff ff ff       	jmp    80103ee1 <scheduler+0x141>
      ptable.rr_num = ptable.rr_num + inc_or_dec;
80103f73:	83 2d 58 5b 11 80 01 	subl   $0x1,0x80115b58
80103f7a:	e9 76 ff ff ff       	jmp    80103ef5 <scheduler+0x155>
80103f7f:	31 db                	xor    %ebx,%ebx
        for(p=ptable.proc; p <&ptable.proc[NPROC]; p++){
80103f81:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103f86:	eb 14                	jmp    80103f9c <scheduler+0x1fc>
80103f88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f8f:	90                   	nop
80103f90:	05 b8 00 00 00       	add    $0xb8,%eax
80103f95:	3d 54 5b 11 80       	cmp    $0x80115b54,%eax
80103f9a:	74 2b                	je     80103fc7 <scheduler+0x227>
          if(p->state==RUNNABLE && p->queue==CLASS2_FCFS){
80103f9c:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103fa0:	75 ee                	jne    80103f90 <scheduler+0x1f0>
80103fa2:	83 78 7c 02          	cmpl   $0x2,0x7c(%eax)
80103fa6:	75 e8                	jne    80103f90 <scheduler+0x1f0>
            if(!runable_p || p->arrival_time < runable_p->arrival_time){
80103fa8:	85 db                	test   %ebx,%ebx
80103faa:	74 28                	je     80103fd4 <scheduler+0x234>
80103fac:	8b bb 80 00 00 00    	mov    0x80(%ebx),%edi
80103fb2:	39 b8 80 00 00 00    	cmp    %edi,0x80(%eax)
80103fb8:	0f 42 d8             	cmovb  %eax,%ebx
        for(p=ptable.proc; p <&ptable.proc[NPROC]; p++){
80103fbb:	05 b8 00 00 00       	add    $0xb8,%eax
80103fc0:	3d 54 5b 11 80       	cmp    $0x80115b54,%eax
80103fc5:	75 d5                	jne    80103f9c <scheduler+0x1fc>
      if(runable_p){
80103fc7:	85 db                	test   %ebx,%ebx
80103fc9:	0f 85 12 ff ff ff    	jne    80103ee1 <scheduler+0x141>
80103fcf:	e9 9c fe ff ff       	jmp    80103e70 <scheduler+0xd0>
80103fd4:	89 c3                	mov    %eax,%ebx
80103fd6:	eb b8                	jmp    80103f90 <scheduler+0x1f0>
80103fd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fdf:	90                   	nop

80103fe0 <sched>:
{
80103fe0:	55                   	push   %ebp
80103fe1:	89 e5                	mov    %esp,%ebp
80103fe3:	56                   	push   %esi
80103fe4:	53                   	push   %ebx
  pushcli();
80103fe5:	e8 66 10 00 00       	call   80105050 <pushcli>
  c = mycpu();
80103fea:	e8 c1 f9 ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80103fef:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ff5:	e8 a6 10 00 00       	call   801050a0 <popcli>
  if(!holding(&ptable.lock))
80103ffa:	83 ec 0c             	sub    $0xc,%esp
80103ffd:	68 20 2d 11 80       	push   $0x80112d20
80104002:	e8 f9 10 00 00       	call   80105100 <holding>
80104007:	83 c4 10             	add    $0x10,%esp
8010400a:	85 c0                	test   %eax,%eax
8010400c:	74 4f                	je     8010405d <sched+0x7d>
  if(mycpu()->ncli != 1)
8010400e:	e8 9d f9 ff ff       	call   801039b0 <mycpu>
80104013:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010401a:	75 68                	jne    80104084 <sched+0xa4>
  if(p->state == RUNNING)
8010401c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104020:	74 55                	je     80104077 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104022:	9c                   	pushf  
80104023:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104024:	f6 c4 02             	test   $0x2,%ah
80104027:	75 41                	jne    8010406a <sched+0x8a>
  intena = mycpu()->intena;
80104029:	e8 82 f9 ff ff       	call   801039b0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010402e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104031:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104037:	e8 74 f9 ff ff       	call   801039b0 <mycpu>
8010403c:	83 ec 08             	sub    $0x8,%esp
8010403f:	ff 70 04             	push   0x4(%eax)
80104042:	53                   	push   %ebx
80104043:	e8 33 14 00 00       	call   8010547b <swtch>
  mycpu()->intena = intena;
80104048:	e8 63 f9 ff ff       	call   801039b0 <mycpu>
}
8010404d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104050:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104056:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104059:	5b                   	pop    %ebx
8010405a:	5e                   	pop    %esi
8010405b:	5d                   	pop    %ebp
8010405c:	c3                   	ret    
    panic("sched ptable.lock");
8010405d:	83 ec 0c             	sub    $0xc,%esp
80104060:	68 3b 83 10 80       	push   $0x8010833b
80104065:	e8 16 c3 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
8010406a:	83 ec 0c             	sub    $0xc,%esp
8010406d:	68 67 83 10 80       	push   $0x80108367
80104072:	e8 09 c3 ff ff       	call   80100380 <panic>
    panic("sched running");
80104077:	83 ec 0c             	sub    $0xc,%esp
8010407a:	68 59 83 10 80       	push   $0x80108359
8010407f:	e8 fc c2 ff ff       	call   80100380 <panic>
    panic("sched locks");
80104084:	83 ec 0c             	sub    $0xc,%esp
80104087:	68 4d 83 10 80       	push   $0x8010834d
8010408c:	e8 ef c2 ff ff       	call   80100380 <panic>
80104091:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104098:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010409f:	90                   	nop

801040a0 <exit>:
{
801040a0:	55                   	push   %ebp
801040a1:	89 e5                	mov    %esp,%ebp
801040a3:	57                   	push   %edi
801040a4:	56                   	push   %esi
801040a5:	53                   	push   %ebx
801040a6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
801040a9:	e8 82 f9 ff ff       	call   80103a30 <myproc>
  if(curproc == initproc)
801040ae:	39 05 60 5b 11 80    	cmp    %eax,0x80115b60
801040b4:	0f 84 52 01 00 00    	je     8010420c <exit+0x16c>
801040ba:	89 c3                	mov    %eax,%ebx
801040bc:	8d 70 28             	lea    0x28(%eax),%esi
801040bf:	8d 78 68             	lea    0x68(%eax),%edi
801040c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
801040c8:	8b 06                	mov    (%esi),%eax
801040ca:	85 c0                	test   %eax,%eax
801040cc:	74 12                	je     801040e0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
801040ce:	83 ec 0c             	sub    $0xc,%esp
801040d1:	50                   	push   %eax
801040d2:	e8 89 ce ff ff       	call   80100f60 <fileclose>
      curproc->ofile[fd] = 0;
801040d7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801040dd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801040e0:	83 c6 04             	add    $0x4,%esi
801040e3:	39 f7                	cmp    %esi,%edi
801040e5:	75 e1                	jne    801040c8 <exit+0x28>
  begin_op();
801040e7:	e8 e4 ec ff ff       	call   80102dd0 <begin_op>
  iput(curproc->cwd);
801040ec:	83 ec 0c             	sub    $0xc,%esp
801040ef:	ff 73 68             	push   0x68(%ebx)
801040f2:	e8 29 d8 ff ff       	call   80101920 <iput>
  end_op();
801040f7:	e8 44 ed ff ff       	call   80102e40 <end_op>
  curproc->cwd = 0;
801040fc:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80104103:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010410a:	e8 91 10 00 00       	call   801051a0 <acquire>
  wakeup1(curproc->parent);
8010410f:	8b 53 14             	mov    0x14(%ebx),%edx
80104112:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104115:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010411a:	eb 10                	jmp    8010412c <exit+0x8c>
8010411c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104120:	05 b8 00 00 00       	add    $0xb8,%eax
80104125:	3d 54 5b 11 80       	cmp    $0x80115b54,%eax
8010412a:	74 2c                	je     80104158 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan){
8010412c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104130:	75 ee                	jne    80104120 <exit+0x80>
80104132:	3b 50 20             	cmp    0x20(%eax),%edx
80104135:	75 e9                	jne    80104120 <exit+0x80>
  if(p->queue==CLASS1){
80104137:	8b 48 7c             	mov    0x7c(%eax),%ecx
      p->state = RUNNABLE;
8010413a:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  if(p->queue==CLASS1){
80104141:	85 c9                	test   %ecx,%ecx
80104143:	75 79                	jne    801041be <exit+0x11e>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104145:	05 b8 00 00 00       	add    $0xb8,%eax
    ptable.class1_num = ptable.class1_num + inc_or_dec;
8010414a:	83 05 54 5b 11 80 01 	addl   $0x1,0x80115b54
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104151:	3d 54 5b 11 80       	cmp    $0x80115b54,%eax
80104156:	75 d4                	jne    8010412c <exit+0x8c>
      p->parent = initproc;
80104158:	8b 0d 60 5b 11 80    	mov    0x80115b60,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010415e:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80104163:	eb 11                	jmp    80104176 <exit+0xd6>
80104165:	8d 76 00             	lea    0x0(%esi),%esi
80104168:	81 c2 b8 00 00 00    	add    $0xb8,%edx
8010416e:	81 fa 54 5b 11 80    	cmp    $0x80115b54,%edx
80104174:	74 71                	je     801041e7 <exit+0x147>
    if(p->parent == curproc){
80104176:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104179:	75 ed                	jne    80104168 <exit+0xc8>
      if(p->state == ZOMBIE)
8010417b:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
8010417f:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80104182:	75 e4                	jne    80104168 <exit+0xc8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104184:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104189:	eb 11                	jmp    8010419c <exit+0xfc>
8010418b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010418f:	90                   	nop
80104190:	05 b8 00 00 00       	add    $0xb8,%eax
80104195:	3d 54 5b 11 80       	cmp    $0x80115b54,%eax
8010419a:	74 cc                	je     80104168 <exit+0xc8>
    if(p->state == SLEEPING && p->chan == chan){
8010419c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801041a0:	75 ee                	jne    80104190 <exit+0xf0>
801041a2:	3b 48 20             	cmp    0x20(%eax),%ecx
801041a5:	75 e9                	jne    80104190 <exit+0xf0>
  if(p->queue==CLASS1){
801041a7:	8b 70 7c             	mov    0x7c(%eax),%esi
      p->state = RUNNABLE;
801041aa:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  if(p->queue==CLASS1){
801041b1:	85 f6                	test   %esi,%esi
801041b3:	75 1b                	jne    801041d0 <exit+0x130>
    ptable.class1_num = ptable.class1_num + inc_or_dec;
801041b5:	83 05 54 5b 11 80 01 	addl   $0x1,0x80115b54
801041bc:	eb d2                	jmp    80104190 <exit+0xf0>
    if(p->queue==CLASS2_RR){
801041be:	83 f9 01             	cmp    $0x1,%ecx
801041c1:	74 3d                	je     80104200 <exit+0x160>
      ptable.fcfs_num = ptable.fcfs_num + inc_or_dec;
801041c3:	83 05 5c 5b 11 80 01 	addl   $0x1,0x80115b5c
801041ca:	e9 51 ff ff ff       	jmp    80104120 <exit+0x80>
801041cf:	90                   	nop
    if(p->queue==CLASS2_RR){
801041d0:	83 fe 01             	cmp    $0x1,%esi
801041d3:	74 09                	je     801041de <exit+0x13e>
      ptable.fcfs_num = ptable.fcfs_num + inc_or_dec;
801041d5:	83 05 5c 5b 11 80 01 	addl   $0x1,0x80115b5c
801041dc:	eb b2                	jmp    80104190 <exit+0xf0>
      ptable.rr_num = ptable.rr_num + inc_or_dec;
801041de:	83 05 58 5b 11 80 01 	addl   $0x1,0x80115b58
801041e5:	eb a9                	jmp    80104190 <exit+0xf0>
  curproc->state = ZOMBIE;
801041e7:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
801041ee:	e8 ed fd ff ff       	call   80103fe0 <sched>
  panic("zombie exit");
801041f3:	83 ec 0c             	sub    $0xc,%esp
801041f6:	68 88 83 10 80       	push   $0x80108388
801041fb:	e8 80 c1 ff ff       	call   80100380 <panic>
      ptable.rr_num = ptable.rr_num + inc_or_dec;
80104200:	83 05 58 5b 11 80 01 	addl   $0x1,0x80115b58
80104207:	e9 14 ff ff ff       	jmp    80104120 <exit+0x80>
    panic("init exiting");
8010420c:	83 ec 0c             	sub    $0xc,%esp
8010420f:	68 7b 83 10 80       	push   $0x8010837b
80104214:	e8 67 c1 ff ff       	call   80100380 <panic>
80104219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104220 <wait>:
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	56                   	push   %esi
80104224:	53                   	push   %ebx
  pushcli();
80104225:	e8 26 0e 00 00       	call   80105050 <pushcli>
  c = mycpu();
8010422a:	e8 81 f7 ff ff       	call   801039b0 <mycpu>
  p = c->proc;
8010422f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104235:	e8 66 0e 00 00       	call   801050a0 <popcli>
  acquire(&ptable.lock);
8010423a:	83 ec 0c             	sub    $0xc,%esp
8010423d:	68 20 2d 11 80       	push   $0x80112d20
80104242:	e8 59 0f 00 00       	call   801051a0 <acquire>
80104247:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010424a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010424c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80104251:	eb 13                	jmp    80104266 <wait+0x46>
80104253:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104257:	90                   	nop
80104258:	81 c3 b8 00 00 00    	add    $0xb8,%ebx
8010425e:	81 fb 54 5b 11 80    	cmp    $0x80115b54,%ebx
80104264:	74 1e                	je     80104284 <wait+0x64>
      if(p->parent != curproc)
80104266:	39 73 14             	cmp    %esi,0x14(%ebx)
80104269:	75 ed                	jne    80104258 <wait+0x38>
      if(p->state == ZOMBIE){
8010426b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010426f:	74 5f                	je     801042d0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104271:	81 c3 b8 00 00 00    	add    $0xb8,%ebx
      havekids = 1;
80104277:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010427c:	81 fb 54 5b 11 80    	cmp    $0x80115b54,%ebx
80104282:	75 e2                	jne    80104266 <wait+0x46>
    if(!havekids || curproc->killed){
80104284:	85 c0                	test   %eax,%eax
80104286:	0f 84 9a 00 00 00    	je     80104326 <wait+0x106>
8010428c:	8b 46 24             	mov    0x24(%esi),%eax
8010428f:	85 c0                	test   %eax,%eax
80104291:	0f 85 8f 00 00 00    	jne    80104326 <wait+0x106>
  pushcli();
80104297:	e8 b4 0d 00 00       	call   80105050 <pushcli>
  c = mycpu();
8010429c:	e8 0f f7 ff ff       	call   801039b0 <mycpu>
  p = c->proc;
801042a1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042a7:	e8 f4 0d 00 00       	call   801050a0 <popcli>
  if(p == 0)
801042ac:	85 db                	test   %ebx,%ebx
801042ae:	0f 84 89 00 00 00    	je     8010433d <wait+0x11d>
  p->chan = chan;
801042b4:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
801042b7:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801042be:	e8 1d fd ff ff       	call   80103fe0 <sched>
  p->chan = 0;
801042c3:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801042ca:	e9 7b ff ff ff       	jmp    8010424a <wait+0x2a>
801042cf:	90                   	nop
        kfree(p->kstack);
801042d0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
801042d3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801042d6:	ff 73 08             	push   0x8(%ebx)
801042d9:	e8 52 e2 ff ff       	call   80102530 <kfree>
        p->kstack = 0;
801042de:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801042e5:	5a                   	pop    %edx
801042e6:	ff 73 04             	push   0x4(%ebx)
801042e9:	e8 f2 36 00 00       	call   801079e0 <freevm>
        p->pid = 0;
801042ee:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801042f5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801042fc:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104300:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104307:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010430e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104315:	e8 26 0e 00 00       	call   80105140 <release>
        return pid;
8010431a:	83 c4 10             	add    $0x10,%esp
}
8010431d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104320:	89 f0                	mov    %esi,%eax
80104322:	5b                   	pop    %ebx
80104323:	5e                   	pop    %esi
80104324:	5d                   	pop    %ebp
80104325:	c3                   	ret    
      release(&ptable.lock);
80104326:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104329:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010432e:	68 20 2d 11 80       	push   $0x80112d20
80104333:	e8 08 0e 00 00       	call   80105140 <release>
      return -1;
80104338:	83 c4 10             	add    $0x10,%esp
8010433b:	eb e0                	jmp    8010431d <wait+0xfd>
    panic("sleep");
8010433d:	83 ec 0c             	sub    $0xc,%esp
80104340:	68 94 83 10 80       	push   $0x80108394
80104345:	e8 36 c0 ff ff       	call   80100380 <panic>
8010434a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104350 <yield>:
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	53                   	push   %ebx
80104354:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104357:	68 20 2d 11 80       	push   $0x80112d20
8010435c:	e8 3f 0e 00 00       	call   801051a0 <acquire>
  pushcli();
80104361:	e8 ea 0c 00 00       	call   80105050 <pushcli>
  c = mycpu();
80104366:	e8 45 f6 ff ff       	call   801039b0 <mycpu>
  p = c->proc;
8010436b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104371:	e8 2a 0d 00 00       	call   801050a0 <popcli>
  myproc()->state = RUNNABLE;
80104376:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  pushcli();
8010437d:	e8 ce 0c 00 00       	call   80105050 <pushcli>
  c = mycpu();
80104382:	e8 29 f6 ff ff       	call   801039b0 <mycpu>
  p = c->proc;
80104387:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010438d:	e8 0e 0d 00 00       	call   801050a0 <popcli>
  if(p->queue==CLASS1){
80104392:	83 c4 10             	add    $0x10,%esp
80104395:	8b 43 7c             	mov    0x7c(%ebx),%eax
80104398:	85 c0                	test   %eax,%eax
8010439a:	75 24                	jne    801043c0 <yield+0x70>
    ptable.class1_num = ptable.class1_num + inc_or_dec;
8010439c:	83 05 54 5b 11 80 01 	addl   $0x1,0x80115b54
  sched();
801043a3:	e8 38 fc ff ff       	call   80103fe0 <sched>
  release(&ptable.lock);
801043a8:	83 ec 0c             	sub    $0xc,%esp
801043ab:	68 20 2d 11 80       	push   $0x80112d20
801043b0:	e8 8b 0d 00 00       	call   80105140 <release>
}
801043b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043b8:	83 c4 10             	add    $0x10,%esp
801043bb:	c9                   	leave  
801043bc:	c3                   	ret    
801043bd:	8d 76 00             	lea    0x0(%esi),%esi
    if(p->queue==CLASS2_RR){
801043c0:	83 f8 01             	cmp    $0x1,%eax
801043c3:	74 0b                	je     801043d0 <yield+0x80>
      ptable.fcfs_num = ptable.fcfs_num + inc_or_dec;
801043c5:	83 05 5c 5b 11 80 01 	addl   $0x1,0x80115b5c
801043cc:	eb d5                	jmp    801043a3 <yield+0x53>
801043ce:	66 90                	xchg   %ax,%ax
      ptable.rr_num = ptable.rr_num + inc_or_dec;
801043d0:	83 05 58 5b 11 80 01 	addl   $0x1,0x80115b58
801043d7:	eb ca                	jmp    801043a3 <yield+0x53>
801043d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801043e0 <sleep>:
{
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	57                   	push   %edi
801043e4:	56                   	push   %esi
801043e5:	53                   	push   %ebx
801043e6:	83 ec 0c             	sub    $0xc,%esp
801043e9:	8b 7d 08             	mov    0x8(%ebp),%edi
801043ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801043ef:	e8 5c 0c 00 00       	call   80105050 <pushcli>
  c = mycpu();
801043f4:	e8 b7 f5 ff ff       	call   801039b0 <mycpu>
  p = c->proc;
801043f9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043ff:	e8 9c 0c 00 00       	call   801050a0 <popcli>
  if(p == 0)
80104404:	85 db                	test   %ebx,%ebx
80104406:	0f 84 87 00 00 00    	je     80104493 <sleep+0xb3>
  if(lk == 0)
8010440c:	85 f6                	test   %esi,%esi
8010440e:	74 76                	je     80104486 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104410:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80104416:	74 50                	je     80104468 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104418:	83 ec 0c             	sub    $0xc,%esp
8010441b:	68 20 2d 11 80       	push   $0x80112d20
80104420:	e8 7b 0d 00 00       	call   801051a0 <acquire>
    release(lk);
80104425:	89 34 24             	mov    %esi,(%esp)
80104428:	e8 13 0d 00 00       	call   80105140 <release>
  p->chan = chan;
8010442d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104430:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104437:	e8 a4 fb ff ff       	call   80103fe0 <sched>
  p->chan = 0;
8010443c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104443:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010444a:	e8 f1 0c 00 00       	call   80105140 <release>
    acquire(lk);
8010444f:	89 75 08             	mov    %esi,0x8(%ebp)
80104452:	83 c4 10             	add    $0x10,%esp
}
80104455:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104458:	5b                   	pop    %ebx
80104459:	5e                   	pop    %esi
8010445a:	5f                   	pop    %edi
8010445b:	5d                   	pop    %ebp
    acquire(lk);
8010445c:	e9 3f 0d 00 00       	jmp    801051a0 <acquire>
80104461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104468:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010446b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104472:	e8 69 fb ff ff       	call   80103fe0 <sched>
  p->chan = 0;
80104477:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010447e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104481:	5b                   	pop    %ebx
80104482:	5e                   	pop    %esi
80104483:	5f                   	pop    %edi
80104484:	5d                   	pop    %ebp
80104485:	c3                   	ret    
    panic("sleep without lk");
80104486:	83 ec 0c             	sub    $0xc,%esp
80104489:	68 9a 83 10 80       	push   $0x8010839a
8010448e:	e8 ed be ff ff       	call   80100380 <panic>
    panic("sleep");
80104493:	83 ec 0c             	sub    $0xc,%esp
80104496:	68 94 83 10 80       	push   $0x80108394
8010449b:	e8 e0 be ff ff       	call   80100380 <panic>

801044a0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	53                   	push   %ebx
801044a4:	83 ec 10             	sub    $0x10,%esp
801044a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801044aa:	68 20 2d 11 80       	push   $0x80112d20
801044af:	e8 ec 0c 00 00       	call   801051a0 <acquire>
801044b4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044b7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801044bc:	eb 0e                	jmp    801044cc <wakeup+0x2c>
801044be:	66 90                	xchg   %ax,%ax
801044c0:	05 b8 00 00 00       	add    $0xb8,%eax
801044c5:	3d 54 5b 11 80       	cmp    $0x80115b54,%eax
801044ca:	74 2c                	je     801044f8 <wakeup+0x58>
    if(p->state == SLEEPING && p->chan == chan){
801044cc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801044d0:	75 ee                	jne    801044c0 <wakeup+0x20>
801044d2:	3b 58 20             	cmp    0x20(%eax),%ebx
801044d5:	75 e9                	jne    801044c0 <wakeup+0x20>
  if(p->queue==CLASS1){
801044d7:	8b 50 7c             	mov    0x7c(%eax),%edx
      p->state = RUNNABLE;
801044da:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  if(p->queue==CLASS1){
801044e1:	85 d2                	test   %edx,%edx
801044e3:	75 2b                	jne    80104510 <wakeup+0x70>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044e5:	05 b8 00 00 00       	add    $0xb8,%eax
    ptable.class1_num = ptable.class1_num + inc_or_dec;
801044ea:	83 05 54 5b 11 80 01 	addl   $0x1,0x80115b54
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044f1:	3d 54 5b 11 80       	cmp    $0x80115b54,%eax
801044f6:	75 d4                	jne    801044cc <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
801044f8:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
801044ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104502:	c9                   	leave  
  release(&ptable.lock);
80104503:	e9 38 0c 00 00       	jmp    80105140 <release>
80104508:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010450f:	90                   	nop
    if(p->queue==CLASS2_RR){
80104510:	83 fa 01             	cmp    $0x1,%edx
80104513:	74 09                	je     8010451e <wakeup+0x7e>
      ptable.fcfs_num = ptable.fcfs_num + inc_or_dec;
80104515:	83 05 5c 5b 11 80 01 	addl   $0x1,0x80115b5c
8010451c:	eb a2                	jmp    801044c0 <wakeup+0x20>
      ptable.rr_num = ptable.rr_num + inc_or_dec;
8010451e:	83 05 58 5b 11 80 01 	addl   $0x1,0x80115b58
80104525:	eb 99                	jmp    801044c0 <wakeup+0x20>
80104527:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010452e:	66 90                	xchg   %ax,%ax

80104530 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	53                   	push   %ebx
80104534:	83 ec 10             	sub    $0x10,%esp
80104537:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010453a:	68 20 2d 11 80       	push   $0x80112d20
8010453f:	e8 5c 0c 00 00       	call   801051a0 <acquire>
80104544:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104547:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010454c:	eb 0e                	jmp    8010455c <kill+0x2c>
8010454e:	66 90                	xchg   %ax,%ax
80104550:	05 b8 00 00 00       	add    $0xb8,%eax
80104555:	3d 54 5b 11 80       	cmp    $0x80115b54,%eax
8010455a:	74 2c                	je     80104588 <kill+0x58>
    if(p->pid == pid){
8010455c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010455f:	75 ef                	jne    80104550 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING){
80104561:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104565:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING){
8010456c:	74 3a                	je     801045a8 <kill+0x78>
        change_num(p, 1);
        p->state = RUNNABLE;
      }  
      release(&ptable.lock);
8010456e:	83 ec 0c             	sub    $0xc,%esp
80104571:	68 20 2d 11 80       	push   $0x80112d20
80104576:	e8 c5 0b 00 00       	call   80105140 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
8010457b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
8010457e:	83 c4 10             	add    $0x10,%esp
80104581:	31 c0                	xor    %eax,%eax
}
80104583:	c9                   	leave  
80104584:	c3                   	ret    
80104585:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104588:	83 ec 0c             	sub    $0xc,%esp
8010458b:	68 20 2d 11 80       	push   $0x80112d20
80104590:	e8 ab 0b 00 00       	call   80105140 <release>
}
80104595:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104598:	83 c4 10             	add    $0x10,%esp
8010459b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801045a0:	c9                   	leave  
801045a1:	c3                   	ret    
801045a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(p->queue==CLASS1){
801045a8:	8b 50 7c             	mov    0x7c(%eax),%edx
801045ab:	85 d2                	test   %edx,%edx
801045ad:	75 10                	jne    801045bf <kill+0x8f>
    ptable.class1_num = ptable.class1_num + inc_or_dec;
801045af:	83 05 54 5b 11 80 01 	addl   $0x1,0x80115b54
        p->state = RUNNABLE;
801045b6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801045bd:	eb af                	jmp    8010456e <kill+0x3e>
    if(p->queue==CLASS2_RR){
801045bf:	83 fa 01             	cmp    $0x1,%edx
801045c2:	74 09                	je     801045cd <kill+0x9d>
      ptable.fcfs_num = ptable.fcfs_num + inc_or_dec;
801045c4:	83 05 5c 5b 11 80 01 	addl   $0x1,0x80115b5c
801045cb:	eb e9                	jmp    801045b6 <kill+0x86>
      ptable.rr_num = ptable.rr_num + inc_or_dec;
801045cd:	83 05 58 5b 11 80 01 	addl   $0x1,0x80115b58
801045d4:	eb e0                	jmp    801045b6 <kill+0x86>
801045d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045dd:	8d 76 00             	lea    0x0(%esi),%esi

801045e0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	57                   	push   %edi
801045e4:	56                   	push   %esi
801045e5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801045e8:	53                   	push   %ebx
801045e9:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
801045ee:	83 ec 3c             	sub    $0x3c,%esp
801045f1:	eb 27                	jmp    8010461a <procdump+0x3a>
801045f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045f7:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801045f8:	83 ec 0c             	sub    $0xc,%esp
801045fb:	68 cc 83 10 80       	push   $0x801083cc
80104600:	e8 9b c0 ff ff       	call   801006a0 <cprintf>
80104605:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104608:	81 c3 b8 00 00 00    	add    $0xb8,%ebx
8010460e:	81 fb c0 5b 11 80    	cmp    $0x80115bc0,%ebx
80104614:	0f 84 7e 00 00 00    	je     80104698 <procdump+0xb8>
    if(p->state == UNUSED)
8010461a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010461d:	85 c0                	test   %eax,%eax
8010461f:	74 e7                	je     80104608 <procdump+0x28>
      state = "???";
80104621:	ba ab 83 10 80       	mov    $0x801083ab,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104626:	83 f8 05             	cmp    $0x5,%eax
80104629:	77 11                	ja     8010463c <procdump+0x5c>
8010462b:	8b 14 85 08 86 10 80 	mov    -0x7fef79f8(,%eax,4),%edx
      state = "???";
80104632:	b8 ab 83 10 80       	mov    $0x801083ab,%eax
80104637:	85 d2                	test   %edx,%edx
80104639:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010463c:	53                   	push   %ebx
8010463d:	52                   	push   %edx
8010463e:	ff 73 a4             	push   -0x5c(%ebx)
80104641:	68 af 83 10 80       	push   $0x801083af
80104646:	e8 55 c0 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
8010464b:	83 c4 10             	add    $0x10,%esp
8010464e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104652:	75 a4                	jne    801045f8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104654:	83 ec 08             	sub    $0x8,%esp
80104657:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010465a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010465d:	50                   	push   %eax
8010465e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104661:	8b 40 0c             	mov    0xc(%eax),%eax
80104664:	83 c0 08             	add    $0x8,%eax
80104667:	50                   	push   %eax
80104668:	e8 83 09 00 00       	call   80104ff0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010466d:	83 c4 10             	add    $0x10,%esp
80104670:	8b 17                	mov    (%edi),%edx
80104672:	85 d2                	test   %edx,%edx
80104674:	74 82                	je     801045f8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104676:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104679:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010467c:	52                   	push   %edx
8010467d:	68 01 7e 10 80       	push   $0x80107e01
80104682:	e8 19 c0 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104687:	83 c4 10             	add    $0x10,%esp
8010468a:	39 fe                	cmp    %edi,%esi
8010468c:	75 e2                	jne    80104670 <procdump+0x90>
8010468e:	e9 65 ff ff ff       	jmp    801045f8 <procdump+0x18>
80104693:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104697:	90                   	nop
  }

}
80104698:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010469b:	5b                   	pop    %ebx
8010469c:	5e                   	pop    %esi
8010469d:	5f                   	pop    %edi
8010469e:	5d                   	pop    %ebp
8010469f:	c3                   	ret    

801046a0 <sys_setlevel>:

int sys_setlevel(void){
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	56                   	push   %esi
801046a4:	53                   	push   %ebx
    int pid, new_level;
    struct proc *p;

  
    if(argint(0, &pid) < 0)
801046a5:	8d 45 f0             	lea    -0x10(%ebp),%eax
int sys_setlevel(void){
801046a8:	83 ec 18             	sub    $0x18,%esp
    if(argint(0, &pid) < 0)
801046ab:	50                   	push   %eax
801046ac:	6a 00                	push   $0x0
801046ae:	e8 6d 0e 00 00       	call   80105520 <argint>
801046b3:	83 c4 10             	add    $0x10,%esp
801046b6:	85 c0                	test   %eax,%eax
801046b8:	0f 88 a2 00 00 00    	js     80104760 <sys_setlevel+0xc0>
        return -1;
    if(argint(1, &new_level) < 0)
801046be:	83 ec 08             	sub    $0x8,%esp
801046c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
801046c4:	50                   	push   %eax
801046c5:	6a 01                	push   $0x1
801046c7:	e8 54 0e 00 00       	call   80105520 <argint>
801046cc:	83 c4 10             	add    $0x10,%esp
801046cf:	85 c0                	test   %eax,%eax
801046d1:	0f 88 89 00 00 00    	js     80104760 <sys_setlevel+0xc0>
        return -1;

 
    if(new_level != CLASS2_RR && new_level != CLASS2_FCFS)
801046d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046da:	83 e8 01             	sub    $0x1,%eax
801046dd:	83 f8 01             	cmp    $0x1,%eax
801046e0:	77 7e                	ja     80104760 <sys_setlevel+0xc0>
        return -1;

    acquire(&ptable.lock);
801046e2:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046e5:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
801046ea:	68 20 2d 11 80       	push   $0x80112d20
801046ef:	e8 ac 0a 00 00       	call   801051a0 <acquire>
        if(p->pid == pid){
801046f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
          if(p->queue == new_level){
801046f7:	8b 75 f4             	mov    -0xc(%ebp),%esi
801046fa:	83 c4 10             	add    $0x10,%esp
801046fd:	eb 0f                	jmp    8010470e <sys_setlevel+0x6e>
801046ff:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104700:	81 c3 b8 00 00 00    	add    $0xb8,%ebx
80104706:	81 fb 54 5b 11 80    	cmp    $0x80115b54,%ebx
8010470c:	74 42                	je     80104750 <sys_setlevel+0xb0>
        if(p->pid == pid){
8010470e:	39 53 10             	cmp    %edx,0x10(%ebx)
80104711:	75 ed                	jne    80104700 <sys_setlevel+0x60>
          if(p->queue == new_level){
80104713:	8b 43 7c             	mov    0x7c(%ebx),%eax
80104716:	39 f0                	cmp    %esi,%eax
80104718:	74 52                	je     8010476c <sys_setlevel+0xcc>
            release(&ptable.lock);
            cprintf("the process is in this level now, can't change level!\n");
            return -1;
          }
            if(p->queue == CLASS2_FCFS || p->queue == CLASS2_RR){
8010471a:	8d 48 ff             	lea    -0x1(%eax),%ecx
8010471d:	83 f9 01             	cmp    $0x1,%ecx
80104720:	76 72                	jbe    80104794 <sys_setlevel+0xf4>
               // p->age = 0;
                cprintf("\n",p->queue);
                release(&ptable.lock);
                cprintf("changing level done!\n");
                return 0; 
            } if(p->queue == CLASS1) {
80104722:	85 c0                	test   %eax,%eax
80104724:	75 da                	jne    80104700 <sys_setlevel+0x60>
                release(&ptable.lock);
80104726:	83 ec 0c             	sub    $0xc,%esp
80104729:	68 20 2d 11 80       	push   $0x80112d20
8010472e:	e8 0d 0a 00 00       	call   80105140 <release>
                cprintf("Not in class2, can't change level!\n");
80104733:	c7 04 24 10 85 10 80 	movl   $0x80108510,(%esp)
8010473a:	e8 61 bf ff ff       	call   801006a0 <cprintf>
                return -1; 
8010473f:	83 c4 10             	add    $0x10,%esp
            }
        }
    }
    release(&ptable.lock);
    return -1; // pid not found
}
80104742:	8d 65 f8             	lea    -0x8(%ebp),%esp
                return -1; 
80104745:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010474a:	5b                   	pop    %ebx
8010474b:	5e                   	pop    %esi
8010474c:	5d                   	pop    %ebp
8010474d:	c3                   	ret    
8010474e:	66 90                	xchg   %ax,%ax
    release(&ptable.lock);
80104750:	83 ec 0c             	sub    $0xc,%esp
80104753:	68 20 2d 11 80       	push   $0x80112d20
80104758:	e8 e3 09 00 00       	call   80105140 <release>
    return -1; // pid not found
8010475d:	83 c4 10             	add    $0x10,%esp
}
80104760:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1; // pid not found
80104763:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104768:	5b                   	pop    %ebx
80104769:	5e                   	pop    %esi
8010476a:	5d                   	pop    %ebp
8010476b:	c3                   	ret    
            release(&ptable.lock);
8010476c:	83 ec 0c             	sub    $0xc,%esp
8010476f:	68 20 2d 11 80       	push   $0x80112d20
80104774:	e8 c7 09 00 00       	call   80105140 <release>
            cprintf("the process is in this level now, can't change level!\n");
80104779:	c7 04 24 d8 84 10 80 	movl   $0x801084d8,(%esp)
80104780:	e8 1b bf ff ff       	call   801006a0 <cprintf>
            return -1;
80104785:	83 c4 10             	add    $0x10,%esp
}
80104788:	8d 65 f8             	lea    -0x8(%ebp),%esp
            return -1;
8010478b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104790:	5b                   	pop    %ebx
80104791:	5e                   	pop    %esi
80104792:	5d                   	pop    %ebp
80104793:	c3                   	ret    
                cprintf("\n",p->queue);
80104794:	83 ec 08             	sub    $0x8,%esp
80104797:	50                   	push   %eax
80104798:	68 cc 83 10 80       	push   $0x801083cc
8010479d:	e8 fe be ff ff       	call   801006a0 <cprintf>
                p->queue = new_level;
801047a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
                cprintf("\n",p->queue);
801047a5:	5a                   	pop    %edx
801047a6:	59                   	pop    %ecx
801047a7:	50                   	push   %eax
801047a8:	68 cc 83 10 80       	push   $0x801083cc
                p->queue = new_level;
801047ad:	89 43 7c             	mov    %eax,0x7c(%ebx)
                cprintf("\n",p->queue);
801047b0:	e8 eb be ff ff       	call   801006a0 <cprintf>
                release(&ptable.lock);
801047b5:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801047bc:	e8 7f 09 00 00       	call   80105140 <release>
                cprintf("changing level done!\n");
801047c1:	c7 04 24 b8 83 10 80 	movl   $0x801083b8,(%esp)
801047c8:	e8 d3 be ff ff       	call   801006a0 <cprintf>
                return 0; 
801047cd:	83 c4 10             	add    $0x10,%esp
}
801047d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
                return 0; 
801047d3:	31 c0                	xor    %eax,%eax
}
801047d5:	5b                   	pop    %ebx
801047d6:	5e                   	pop    %esi
801047d7:	5d                   	pop    %ebp
801047d8:	c3                   	ret    
801047d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801047e0 <getStateString>:





char* getStateString(enum procstate state) {
801047e0:	55                   	push   %ebp
801047e1:	b8 ce 83 10 80       	mov    $0x801083ce,%eax
801047e6:	89 e5                	mov    %esp,%ebp
801047e8:	8b 55 08             	mov    0x8(%ebp),%edx
801047eb:	83 fa 05             	cmp    $0x5,%edx
801047ee:	77 07                	ja     801047f7 <getStateString+0x17>
801047f0:	8b 04 95 f0 85 10 80 	mov    -0x7fef7a10(,%edx,4),%eax
    case RUNNABLE: return "RUNNABLE";
    case RUNNING: return "RUNNING";
    case ZOMBIE: return "ZOMBIE";
    default: return "UNKNOWN";
  }
}
801047f7:	5d                   	pop    %ebp
801047f8:	c3                   	ret    
801047f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104800 <getClassString>:
char* getClassString(enum priority_queue q) {
80104800:	55                   	push   %ebp
80104801:	b8 d6 83 10 80       	mov    $0x801083d6,%eax
80104806:	89 e5                	mov    %esp,%ebp
80104808:	8b 55 08             	mov    0x8(%ebp),%edx
8010480b:	83 fa 02             	cmp    $0x2,%edx
8010480e:	77 07                	ja     80104817 <getClassString+0x17>
80104810:	8b 04 95 e4 85 10 80 	mov    -0x7fef7a1c(,%edx,4),%eax
    case CLASS1: return "real-time";
    case CLASS2_RR: return "normal";
    case CLASS2_FCFS: return "normal";
    default: return "unknown";
  }
}
80104817:	5d                   	pop    %ebp
80104818:	c3                   	ret    
80104819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104820 <getAlgorithmString>:
char* getAlgorithmString(struct proc *p) {
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
  switch (p->queue) {
80104823:	8b 45 08             	mov    0x8(%ebp),%eax
80104826:	8b 50 7c             	mov    0x7c(%eax),%edx
80104829:	b8 d6 83 10 80       	mov    $0x801083d6,%eax
8010482e:	83 fa 02             	cmp    $0x2,%edx
80104831:	77 07                	ja     8010483a <getAlgorithmString+0x1a>
80104833:	8b 04 95 d8 85 10 80 	mov    -0x7fef7a28(,%edx,4),%eax
    case CLASS1: return "EDF";
    case CLASS2_RR: return "RR";
    case CLASS2_FCFS: return "FCFS";
    default: return "unknown";
  }
}
8010483a:	5d                   	pop    %ebp
8010483b:	c3                   	ret    
8010483c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104840 <count_digits>:


int count_digits(int number) {
80104840:	55                   	push   %ebp
80104841:	b9 01 00 00 00       	mov    $0x1,%ecx
80104846:	89 e5                	mov    %esp,%ebp
80104848:	53                   	push   %ebx
80104849:	8b 55 08             	mov    0x8(%ebp),%edx
  if (number == 0)
8010484c:	85 d2                	test   %edx,%edx
8010484e:	74 1c                	je     8010486c <count_digits+0x2c>
      return 1;  

  int count = 0;
80104850:	b9 00 00 00 00       	mov    $0x0,%ecx
  if (number < 0) {
80104855:	78 21                	js     80104878 <count_digits+0x38>
      number = -number; 
  }

  while (number > 0) {
      count++;
      number /= 10; 
80104857:	bb cd cc cc cc       	mov    $0xcccccccd,%ebx
8010485c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104860:	89 d0                	mov    %edx,%eax
      count++;
80104862:	83 c1 01             	add    $0x1,%ecx
      number /= 10; 
80104865:	f7 e3                	mul    %ebx
  while (number > 0) {
80104867:	c1 ea 03             	shr    $0x3,%edx
8010486a:	75 f4                	jne    80104860 <count_digits+0x20>
  }
  return count;
}
8010486c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010486f:	89 c8                	mov    %ecx,%eax
80104871:	c9                   	leave  
80104872:	c3                   	ret    
80104873:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104877:	90                   	nop
      number = -number; 
80104878:	f7 da                	neg    %edx
      count++;     
8010487a:	b9 01 00 00 00       	mov    $0x1,%ecx
8010487f:	eb d6                	jmp    80104857 <count_digits+0x17>
80104881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104888:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010488f:	90                   	nop

80104890 <printspaces>:

void printspaces(int count) { 
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	56                   	push   %esi
80104894:	8b 75 08             	mov    0x8(%ebp),%esi
80104897:	53                   	push   %ebx
  for (int i = 0; i < count; i++) {
80104898:	85 f6                	test   %esi,%esi
8010489a:	7e 1b                	jle    801048b7 <printspaces+0x27>
8010489c:	31 db                	xor    %ebx,%ebx
8010489e:	66 90                	xchg   %ax,%ax
    cprintf(" ");
801048a0:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < count; i++) {
801048a3:	83 c3 01             	add    $0x1,%ebx
    cprintf(" ");
801048a6:	68 68 84 10 80       	push   $0x80108468
801048ab:	e8 f0 bd ff ff       	call   801006a0 <cprintf>
  for (int i = 0; i < count; i++) {
801048b0:	83 c4 10             	add    $0x10,%esp
801048b3:	39 de                	cmp    %ebx,%esi
801048b5:	75 e9                	jne    801048a0 <printspaces+0x10>
  }
}
801048b7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048ba:	5b                   	pop    %ebx
801048bb:	5e                   	pop    %esi
801048bc:	5d                   	pop    %ebp
801048bd:	c3                   	ret    
801048be:	66 90                	xchg   %ax,%ax

801048c0 <printprocinfo>:

void printprocinfo(void) {
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
801048c3:	57                   	push   %edi
801048c4:	56                   	push   %esi
801048c5:	53                   	push   %ebx
801048c6:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
801048cb:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
801048ce:	68 20 2d 11 80       	push   $0x80112d20
801048d3:	e8 c8 08 00 00       	call   801051a0 <acquire>

  cprintf("name            pid  state class   algorithm wait_time deadline cons_run arrival\n"
801048d8:	c7 04 24 34 85 10 80 	movl   $0x80108534,(%esp)
801048df:	e8 bc bd ff ff       	call   801006a0 <cprintf>
    "------------------------------------------------------------------------------\n");

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801048e4:	83 c4 10             	add    $0x10,%esp
801048e7:	eb 19                	jmp    80104902 <printprocinfo+0x42>
801048e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048f0:	81 c3 b8 00 00 00    	add    $0xb8,%ebx
801048f6:	81 fb c0 5b 11 80    	cmp    $0x80115bc0,%ebx
801048fc:	0f 84 97 03 00 00    	je     80104c99 <printprocinfo+0x3d9>
    if (p->state == UNUSED)
80104902:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104905:	85 c0                	test   %eax,%eax
80104907:	74 e7                	je     801048f0 <printprocinfo+0x30>
      continue;

    static int columns[] = { 16, 5, 10, 9, 10, 8, 8, 8, 8 };

    cprintf("%s", p->name);
80104909:	83 ec 08             	sub    $0x8,%esp
    printspaces(columns[0] - strlen(p->name));
8010490c:	be 10 00 00 00       	mov    $0x10,%esi
    cprintf("%s", p->name);
80104911:	53                   	push   %ebx
80104912:	68 b5 83 10 80       	push   $0x801083b5
80104917:	e8 84 bd ff ff       	call   801006a0 <cprintf>
    printspaces(columns[0] - strlen(p->name));
8010491c:	89 1c 24             	mov    %ebx,(%esp)
8010491f:	e8 3c 0b 00 00       	call   80105460 <strlen>
  for (int i = 0; i < count; i++) {
80104924:	83 c4 10             	add    $0x10,%esp
    printspaces(columns[0] - strlen(p->name));
80104927:	29 c6                	sub    %eax,%esi
  for (int i = 0; i < count; i++) {
80104929:	85 f6                	test   %esi,%esi
8010492b:	7e 1a                	jle    80104947 <printprocinfo+0x87>
8010492d:	31 ff                	xor    %edi,%edi
8010492f:	90                   	nop
    cprintf(" ");
80104930:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < count; i++) {
80104933:	83 c7 01             	add    $0x1,%edi
    cprintf(" ");
80104936:	68 68 84 10 80       	push   $0x80108468
8010493b:	e8 60 bd ff ff       	call   801006a0 <cprintf>
  for (int i = 0; i < count; i++) {
80104940:	83 c4 10             	add    $0x10,%esp
80104943:	39 fe                	cmp    %edi,%esi
80104945:	75 e9                	jne    80104930 <printprocinfo+0x70>

    cprintf("%d", p->pid);
80104947:	83 ec 08             	sub    $0x8,%esp
8010494a:	ff 73 a4             	push   -0x5c(%ebx)
8010494d:	68 de 83 10 80       	push   $0x801083de
80104952:	e8 49 bd ff ff       	call   801006a0 <cprintf>
    printspaces(columns[1] - count_digits(p->pid));
80104957:	8b 53 a4             	mov    -0x5c(%ebx),%edx
  if (number == 0)
8010495a:	83 c4 10             	add    $0x10,%esp
8010495d:	85 d2                	test   %edx,%edx
8010495f:	0f 84 fb 03 00 00    	je     80104d60 <printprocinfo+0x4a0>
  int count = 0;
80104965:	b9 00 00 00 00       	mov    $0x0,%ecx
  if (number < 0) {
8010496a:	79 07                	jns    80104973 <printprocinfo+0xb3>
      number = -number; 
8010496c:	f7 da                	neg    %edx
      count++;     
8010496e:	b9 01 00 00 00       	mov    $0x1,%ecx
      number /= 10; 
80104973:	be cd cc cc cc       	mov    $0xcccccccd,%esi
80104978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010497f:	90                   	nop
80104980:	89 d0                	mov    %edx,%eax
      count++;
80104982:	83 c1 01             	add    $0x1,%ecx
      number /= 10; 
80104985:	f7 e6                	mul    %esi
  while (number > 0) {
80104987:	c1 ea 03             	shr    $0x3,%edx
8010498a:	75 f4                	jne    80104980 <printprocinfo+0xc0>
    printspaces(columns[1] - count_digits(p->pid));
8010498c:	be 05 00 00 00       	mov    $0x5,%esi
80104991:	29 ce                	sub    %ecx,%esi
  for (int i = 0; i < count; i++) {
80104993:	85 f6                	test   %esi,%esi
80104995:	7e 20                	jle    801049b7 <printprocinfo+0xf7>
    printspaces(columns[1] - count_digits(p->pid));
80104997:	31 ff                	xor    %edi,%edi
80104999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" ");
801049a0:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < count; i++) {
801049a3:	83 c7 01             	add    $0x1,%edi
    cprintf(" ");
801049a6:	68 68 84 10 80       	push   $0x80108468
801049ab:	e8 f0 bc ff ff       	call   801006a0 <cprintf>
  for (int i = 0; i < count; i++) {
801049b0:	83 c4 10             	add    $0x10,%esp
801049b3:	39 f7                	cmp    %esi,%edi
801049b5:	7c e9                	jl     801049a0 <printprocinfo+0xe0>

    char *stateStr = getStateString(p->state);
801049b7:	8b 43 a0             	mov    -0x60(%ebx),%eax
801049ba:	be ce 83 10 80       	mov    $0x801083ce,%esi
801049bf:	83 f8 05             	cmp    $0x5,%eax
801049c2:	77 07                	ja     801049cb <printprocinfo+0x10b>
801049c4:	8b 34 85 f0 85 10 80 	mov    -0x7fef7a10(,%eax,4),%esi
    cprintf("%s", stateStr);
801049cb:	83 ec 08             	sub    $0x8,%esp
801049ce:	56                   	push   %esi
801049cf:	68 b5 83 10 80       	push   $0x801083b5
801049d4:	e8 c7 bc ff ff       	call   801006a0 <cprintf>
    printspaces(columns[2] - strlen(stateStr));
801049d9:	89 34 24             	mov    %esi,(%esp)
801049dc:	be 0a 00 00 00       	mov    $0xa,%esi
801049e1:	e8 7a 0a 00 00       	call   80105460 <strlen>
  for (int i = 0; i < count; i++) {
801049e6:	83 c4 10             	add    $0x10,%esp
    printspaces(columns[2] - strlen(stateStr));
801049e9:	29 c6                	sub    %eax,%esi
  for (int i = 0; i < count; i++) {
801049eb:	85 f6                	test   %esi,%esi
801049ed:	7e 20                	jle    80104a0f <printprocinfo+0x14f>
801049ef:	31 ff                	xor    %edi,%edi
801049f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" ");
801049f8:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < count; i++) {
801049fb:	83 c7 01             	add    $0x1,%edi
    cprintf(" ");
801049fe:	68 68 84 10 80       	push   $0x80108468
80104a03:	e8 98 bc ff ff       	call   801006a0 <cprintf>
  for (int i = 0; i < count; i++) {
80104a08:	83 c4 10             	add    $0x10,%esp
80104a0b:	39 fe                	cmp    %edi,%esi
80104a0d:	75 e9                	jne    801049f8 <printprocinfo+0x138>

    char *classStr = getClassString(p->queue);
80104a0f:	8b 43 10             	mov    0x10(%ebx),%eax
80104a12:	be d6 83 10 80       	mov    $0x801083d6,%esi
80104a17:	83 f8 02             	cmp    $0x2,%eax
80104a1a:	77 07                	ja     80104a23 <printprocinfo+0x163>
80104a1c:	8b 34 85 e4 85 10 80 	mov    -0x7fef7a1c(,%eax,4),%esi
    cprintf("%s", classStr);
80104a23:	83 ec 08             	sub    $0x8,%esp
80104a26:	56                   	push   %esi
80104a27:	68 b5 83 10 80       	push   $0x801083b5
80104a2c:	e8 6f bc ff ff       	call   801006a0 <cprintf>
    printspaces(columns[3] - strlen(classStr));
80104a31:	89 34 24             	mov    %esi,(%esp)
80104a34:	be 09 00 00 00       	mov    $0x9,%esi
80104a39:	e8 22 0a 00 00       	call   80105460 <strlen>
  for (int i = 0; i < count; i++) {
80104a3e:	83 c4 10             	add    $0x10,%esp
    printspaces(columns[3] - strlen(classStr));
80104a41:	29 c6                	sub    %eax,%esi
  for (int i = 0; i < count; i++) {
80104a43:	85 f6                	test   %esi,%esi
80104a45:	7e 20                	jle    80104a67 <printprocinfo+0x1a7>
80104a47:	31 ff                	xor    %edi,%edi
80104a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" ");
80104a50:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < count; i++) {
80104a53:	83 c7 01             	add    $0x1,%edi
    cprintf(" ");
80104a56:	68 68 84 10 80       	push   $0x80108468
80104a5b:	e8 40 bc ff ff       	call   801006a0 <cprintf>
  for (int i = 0; i < count; i++) {
80104a60:	83 c4 10             	add    $0x10,%esp
80104a63:	39 fe                	cmp    %edi,%esi
80104a65:	75 e9                	jne    80104a50 <printprocinfo+0x190>
  switch (p->queue) {
80104a67:	8b 43 10             	mov    0x10(%ebx),%eax
80104a6a:	be d6 83 10 80       	mov    $0x801083d6,%esi
80104a6f:	83 f8 02             	cmp    $0x2,%eax
80104a72:	77 07                	ja     80104a7b <printprocinfo+0x1bb>
80104a74:	8b 34 85 d8 85 10 80 	mov    -0x7fef7a28(,%eax,4),%esi

    char *algoStr = getAlgorithmString(p);
    cprintf("%s", algoStr);
80104a7b:	83 ec 08             	sub    $0x8,%esp
80104a7e:	56                   	push   %esi
80104a7f:	68 b5 83 10 80       	push   $0x801083b5
80104a84:	e8 17 bc ff ff       	call   801006a0 <cprintf>
    printspaces(columns[4] - strlen(algoStr));
80104a89:	89 34 24             	mov    %esi,(%esp)
80104a8c:	be 0a 00 00 00       	mov    $0xa,%esi
80104a91:	e8 ca 09 00 00       	call   80105460 <strlen>
  for (int i = 0; i < count; i++) {
80104a96:	83 c4 10             	add    $0x10,%esp
    printspaces(columns[4] - strlen(algoStr));
80104a99:	29 c6                	sub    %eax,%esi
  for (int i = 0; i < count; i++) {
80104a9b:	85 f6                	test   %esi,%esi
80104a9d:	7e 20                	jle    80104abf <printprocinfo+0x1ff>
80104a9f:	31 ff                	xor    %edi,%edi
80104aa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" ");
80104aa8:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < count; i++) {
80104aab:	83 c7 01             	add    $0x1,%edi
    cprintf(" ");
80104aae:	68 68 84 10 80       	push   $0x80108468
80104ab3:	e8 e8 bb ff ff       	call   801006a0 <cprintf>
  for (int i = 0; i < count; i++) {
80104ab8:	83 c4 10             	add    $0x10,%esp
80104abb:	39 fe                	cmp    %edi,%esi
80104abd:	75 e9                	jne    80104aa8 <printprocinfo+0x1e8>

    cprintf("%d", p->wait_time);
80104abf:	83 ec 08             	sub    $0x8,%esp
80104ac2:	ff 73 40             	push   0x40(%ebx)
80104ac5:	68 de 83 10 80       	push   $0x801083de
80104aca:	e8 d1 bb ff ff       	call   801006a0 <cprintf>
    printspaces(columns[5] - count_digits(p->wait_time));
80104acf:	8b 53 40             	mov    0x40(%ebx),%edx
  if (number == 0)
80104ad2:	83 c4 10             	add    $0x10,%esp
80104ad5:	85 d2                	test   %edx,%edx
80104ad7:	0f 84 73 02 00 00    	je     80104d50 <printprocinfo+0x490>
  int count = 0;
80104add:	b9 00 00 00 00       	mov    $0x0,%ecx
  if (number < 0) {
80104ae2:	79 07                	jns    80104aeb <printprocinfo+0x22b>
      number = -number; 
80104ae4:	f7 da                	neg    %edx
      count++;     
80104ae6:	b9 01 00 00 00       	mov    $0x1,%ecx
      number /= 10; 
80104aeb:	be cd cc cc cc       	mov    $0xcccccccd,%esi
80104af0:	89 d0                	mov    %edx,%eax
      count++;
80104af2:	83 c1 01             	add    $0x1,%ecx
      number /= 10; 
80104af5:	f7 e6                	mul    %esi
  while (number > 0) {
80104af7:	c1 ea 03             	shr    $0x3,%edx
80104afa:	75 f4                	jne    80104af0 <printprocinfo+0x230>
    printspaces(columns[5] - count_digits(p->wait_time));
80104afc:	be 08 00 00 00       	mov    $0x8,%esi
80104b01:	29 ce                	sub    %ecx,%esi
  for (int i = 0; i < count; i++) {
80104b03:	85 f6                	test   %esi,%esi
80104b05:	7e 20                	jle    80104b27 <printprocinfo+0x267>
    printspaces(columns[5] - count_digits(p->wait_time));
80104b07:	31 ff                	xor    %edi,%edi
80104b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" ");
80104b10:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < count; i++) {
80104b13:	83 c7 01             	add    $0x1,%edi
    cprintf(" ");
80104b16:	68 68 84 10 80       	push   $0x80108468
80104b1b:	e8 80 bb ff ff       	call   801006a0 <cprintf>
  for (int i = 0; i < count; i++) {
80104b20:	83 c4 10             	add    $0x10,%esp
80104b23:	39 f7                	cmp    %esi,%edi
80104b25:	7c e9                	jl     80104b10 <printprocinfo+0x250>

    cprintf("%d", p->deadline);
80104b27:	83 ec 08             	sub    $0x8,%esp
80104b2a:	ff 73 18             	push   0x18(%ebx)
80104b2d:	68 de 83 10 80       	push   $0x801083de
80104b32:	e8 69 bb ff ff       	call   801006a0 <cprintf>
    printspaces(columns[6] - count_digits(p->deadline));
80104b37:	8b 53 18             	mov    0x18(%ebx),%edx
  if (number == 0)
80104b3a:	83 c4 10             	add    $0x10,%esp
80104b3d:	85 d2                	test   %edx,%edx
80104b3f:	0f 84 fb 01 00 00    	je     80104d40 <printprocinfo+0x480>
  int count = 0;
80104b45:	b9 00 00 00 00       	mov    $0x0,%ecx
  if (number < 0) {
80104b4a:	79 07                	jns    80104b53 <printprocinfo+0x293>
      number = -number; 
80104b4c:	f7 da                	neg    %edx
      count++;     
80104b4e:	b9 01 00 00 00       	mov    $0x1,%ecx
      number /= 10; 
80104b53:	be cd cc cc cc       	mov    $0xcccccccd,%esi
80104b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b5f:	90                   	nop
80104b60:	89 d0                	mov    %edx,%eax
      count++;
80104b62:	83 c1 01             	add    $0x1,%ecx
      number /= 10; 
80104b65:	f7 e6                	mul    %esi
  while (number > 0) {
80104b67:	c1 ea 03             	shr    $0x3,%edx
80104b6a:	75 f4                	jne    80104b60 <printprocinfo+0x2a0>
    printspaces(columns[6] - count_digits(p->deadline));
80104b6c:	be 08 00 00 00       	mov    $0x8,%esi
80104b71:	29 ce                	sub    %ecx,%esi
  for (int i = 0; i < count; i++) {
80104b73:	85 f6                	test   %esi,%esi
80104b75:	7e 20                	jle    80104b97 <printprocinfo+0x2d7>
    printspaces(columns[6] - count_digits(p->deadline));
80104b77:	31 ff                	xor    %edi,%edi
80104b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" ");
80104b80:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < count; i++) {
80104b83:	83 c7 01             	add    $0x1,%edi
    cprintf(" ");
80104b86:	68 68 84 10 80       	push   $0x80108468
80104b8b:	e8 10 bb ff ff       	call   801006a0 <cprintf>
  for (int i = 0; i < count; i++) {
80104b90:	83 c4 10             	add    $0x10,%esp
80104b93:	39 f7                	cmp    %esi,%edi
80104b95:	7c e9                	jl     80104b80 <printprocinfo+0x2c0>

    cprintf("%d", p->consecutive_run_ticks);
80104b97:	83 ec 08             	sub    $0x8,%esp
80104b9a:	ff 73 44             	push   0x44(%ebx)
80104b9d:	68 de 83 10 80       	push   $0x801083de
80104ba2:	e8 f9 ba ff ff       	call   801006a0 <cprintf>
    printspaces(columns[7] - count_digits(p->consecutive_run_ticks));
80104ba7:	8b 53 44             	mov    0x44(%ebx),%edx
  if (number == 0)
80104baa:	83 c4 10             	add    $0x10,%esp
80104bad:	85 d2                	test   %edx,%edx
80104baf:	0f 84 7b 01 00 00    	je     80104d30 <printprocinfo+0x470>
  int count = 0;
80104bb5:	b9 00 00 00 00       	mov    $0x0,%ecx
  if (number < 0) {
80104bba:	79 07                	jns    80104bc3 <printprocinfo+0x303>
      number = -number; 
80104bbc:	f7 da                	neg    %edx
      count++;     
80104bbe:	b9 01 00 00 00       	mov    $0x1,%ecx
      number /= 10; 
80104bc3:	be cd cc cc cc       	mov    $0xcccccccd,%esi
80104bc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bcf:	90                   	nop
80104bd0:	89 d0                	mov    %edx,%eax
      count++;
80104bd2:	83 c1 01             	add    $0x1,%ecx
      number /= 10; 
80104bd5:	f7 e6                	mul    %esi
  while (number > 0) {
80104bd7:	c1 ea 03             	shr    $0x3,%edx
80104bda:	75 f4                	jne    80104bd0 <printprocinfo+0x310>
    printspaces(columns[7] - count_digits(p->consecutive_run_ticks));
80104bdc:	be 08 00 00 00       	mov    $0x8,%esi
80104be1:	29 ce                	sub    %ecx,%esi
  for (int i = 0; i < count; i++) {
80104be3:	85 f6                	test   %esi,%esi
80104be5:	7e 20                	jle    80104c07 <printprocinfo+0x347>
    printspaces(columns[7] - count_digits(p->consecutive_run_ticks));
80104be7:	31 ff                	xor    %edi,%edi
80104be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" ");
80104bf0:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < count; i++) {
80104bf3:	83 c7 01             	add    $0x1,%edi
    cprintf(" ");
80104bf6:	68 68 84 10 80       	push   $0x80108468
80104bfb:	e8 a0 ba ff ff       	call   801006a0 <cprintf>
  for (int i = 0; i < count; i++) {
80104c00:	83 c4 10             	add    $0x10,%esp
80104c03:	39 f7                	cmp    %esi,%edi
80104c05:	7c e9                	jl     80104bf0 <printprocinfo+0x330>

    cprintf("%d", p->queue_arrival_time);
80104c07:	83 ec 08             	sub    $0x8,%esp
80104c0a:	ff 73 48             	push   0x48(%ebx)
80104c0d:	68 de 83 10 80       	push   $0x801083de
80104c12:	e8 89 ba ff ff       	call   801006a0 <cprintf>
    printspaces(columns[8] - count_digits(p->queue_arrival_time));
80104c17:	8b 53 48             	mov    0x48(%ebx),%edx
  if (number == 0)
80104c1a:	83 c4 10             	add    $0x10,%esp
80104c1d:	85 d2                	test   %edx,%edx
80104c1f:	0f 84 fb 00 00 00    	je     80104d20 <printprocinfo+0x460>
  int count = 0;
80104c25:	b9 00 00 00 00       	mov    $0x0,%ecx
  if (number < 0) {
80104c2a:	79 07                	jns    80104c33 <printprocinfo+0x373>
      number = -number; 
80104c2c:	f7 da                	neg    %edx
      count++;     
80104c2e:	b9 01 00 00 00       	mov    $0x1,%ecx
      number /= 10; 
80104c33:	be cd cc cc cc       	mov    $0xcccccccd,%esi
80104c38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c3f:	90                   	nop
80104c40:	89 d0                	mov    %edx,%eax
      count++;
80104c42:	83 c1 01             	add    $0x1,%ecx
      number /= 10; 
80104c45:	f7 e6                	mul    %esi
  while (number > 0) {
80104c47:	c1 ea 03             	shr    $0x3,%edx
80104c4a:	75 f4                	jne    80104c40 <printprocinfo+0x380>
    printspaces(columns[8] - count_digits(p->queue_arrival_time));
80104c4c:	be 08 00 00 00       	mov    $0x8,%esi
80104c51:	29 ce                	sub    %ecx,%esi
  for (int i = 0; i < count; i++) {
80104c53:	85 f6                	test   %esi,%esi
80104c55:	7e 20                	jle    80104c77 <printprocinfo+0x3b7>
    printspaces(columns[8] - count_digits(p->queue_arrival_time));
80104c57:	31 ff                	xor    %edi,%edi
80104c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" ");
80104c60:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < count; i++) {
80104c63:	83 c7 01             	add    $0x1,%edi
    cprintf(" ");
80104c66:	68 68 84 10 80       	push   $0x80108468
80104c6b:	e8 30 ba ff ff       	call   801006a0 <cprintf>
  for (int i = 0; i < count; i++) {
80104c70:	83 c4 10             	add    $0x10,%esp
80104c73:	39 f7                	cmp    %esi,%edi
80104c75:	7c e9                	jl     80104c60 <printprocinfo+0x3a0>

    cprintf("\n");
80104c77:	83 ec 0c             	sub    $0xc,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104c7a:	81 c3 b8 00 00 00    	add    $0xb8,%ebx
    cprintf("\n");
80104c80:	68 cc 83 10 80       	push   $0x801083cc
80104c85:	e8 16 ba ff ff       	call   801006a0 <cprintf>
80104c8a:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104c8d:	81 fb c0 5b 11 80    	cmp    $0x80115bc0,%ebx
80104c93:	0f 85 69 fc ff ff    	jne    80104902 <printprocinfo+0x42>
  } 
  cprintf("\nddddddd\n");
80104c99:	83 ec 0c             	sub    $0xc,%esp
80104c9c:	68 e1 83 10 80       	push   $0x801083e1
80104ca1:	e8 fa b9 ff ff       	call   801006a0 <cprintf>
  cprintf("%d", ptable.class1_num);
80104ca6:	58                   	pop    %eax
80104ca7:	5a                   	pop    %edx
80104ca8:	ff 35 54 5b 11 80    	push   0x80115b54
80104cae:	68 de 83 10 80       	push   $0x801083de
80104cb3:	e8 e8 b9 ff ff       	call   801006a0 <cprintf>
  cprintf("\nddddddd\n");
80104cb8:	c7 04 24 e1 83 10 80 	movl   $0x801083e1,(%esp)
80104cbf:	e8 dc b9 ff ff       	call   801006a0 <cprintf>
  cprintf("%d", ptable.rr_num);
80104cc4:	59                   	pop    %ecx
80104cc5:	5b                   	pop    %ebx
80104cc6:	ff 35 58 5b 11 80    	push   0x80115b58
80104ccc:	68 de 83 10 80       	push   $0x801083de
80104cd1:	e8 ca b9 ff ff       	call   801006a0 <cprintf>
  cprintf("\nddddddd\n");
80104cd6:	c7 04 24 e1 83 10 80 	movl   $0x801083e1,(%esp)
80104cdd:	e8 be b9 ff ff       	call   801006a0 <cprintf>
  cprintf("%d", ptable.fcfs_num);
80104ce2:	5e                   	pop    %esi
80104ce3:	5f                   	pop    %edi
80104ce4:	ff 35 5c 5b 11 80    	push   0x80115b5c
80104cea:	68 de 83 10 80       	push   $0x801083de
80104cef:	e8 ac b9 ff ff       	call   801006a0 <cprintf>
  cprintf("\nddddddd\n");
80104cf4:	c7 04 24 e1 83 10 80 	movl   $0x801083e1,(%esp)
80104cfb:	e8 a0 b9 ff ff       	call   801006a0 <cprintf>


  release(&ptable.lock);
80104d00:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104d07:	e8 34 04 00 00       	call   80105140 <release>
}
80104d0c:	83 c4 10             	add    $0x10,%esp
80104d0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d12:	5b                   	pop    %ebx
80104d13:	5e                   	pop    %esi
80104d14:	5f                   	pop    %edi
80104d15:	5d                   	pop    %ebp
80104d16:	c3                   	ret    
80104d17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d1e:	66 90                	xchg   %ax,%ax
    printspaces(columns[8] - count_digits(p->queue_arrival_time));
80104d20:	be 07 00 00 00       	mov    $0x7,%esi
80104d25:	e9 2d ff ff ff       	jmp    80104c57 <printprocinfo+0x397>
80104d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    printspaces(columns[7] - count_digits(p->consecutive_run_ticks));
80104d30:	be 07 00 00 00       	mov    $0x7,%esi
80104d35:	e9 ad fe ff ff       	jmp    80104be7 <printprocinfo+0x327>
80104d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    printspaces(columns[6] - count_digits(p->deadline));
80104d40:	be 07 00 00 00       	mov    $0x7,%esi
80104d45:	e9 2d fe ff ff       	jmp    80104b77 <printprocinfo+0x2b7>
80104d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    printspaces(columns[5] - count_digits(p->wait_time));
80104d50:	be 07 00 00 00       	mov    $0x7,%esi
80104d55:	e9 ad fd ff ff       	jmp    80104b07 <printprocinfo+0x247>
80104d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    printspaces(columns[1] - count_digits(p->pid));
80104d60:	be 04 00 00 00       	mov    $0x4,%esi
80104d65:	e9 2d fc ff ff       	jmp    80104997 <printprocinfo+0xd7>
80104d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d70 <sys_dl_proc>:

int sys_dl_proc(void){
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	83 ec 20             	sub    $0x20,%esp
  int pid, dead_line;
  
    if(argint(0, &pid) < 0)
80104d76:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d79:	50                   	push   %eax
80104d7a:	6a 00                	push   $0x0
80104d7c:	e8 9f 07 00 00       	call   80105520 <argint>
80104d81:	83 c4 10             	add    $0x10,%esp
80104d84:	85 c0                	test   %eax,%eax
80104d86:	0f 88 8c 00 00 00    	js     80104e18 <sys_dl_proc+0xa8>
        return -1;
    if(argint(1, &dead_line) < 0)
80104d8c:	83 ec 08             	sub    $0x8,%esp
80104d8f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d92:	50                   	push   %eax
80104d93:	6a 01                	push   $0x1
80104d95:	e8 86 07 00 00       	call   80105520 <argint>
80104d9a:	83 c4 10             	add    $0x10,%esp
80104d9d:	85 c0                	test   %eax,%eax
80104d9f:	78 77                	js     80104e18 <sys_dl_proc+0xa8>
        return -1;
    int flag = 0;
    acquire(&ptable.lock);
80104da1:	83 ec 0c             	sub    $0xc,%esp
80104da4:	68 20 2d 11 80       	push   $0x80112d20
80104da9:	e8 f2 03 00 00       	call   801051a0 <acquire>
    for(int index = 0; index < NPROC; index++) {
      if(ptable.proc[index].pid == pid) {
80104dae:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80104db1:	ba 64 2d 11 80       	mov    $0x80112d64,%edx
80104db6:	83 c4 10             	add    $0x10,%esp
    for(int index = 0; index < NPROC; index++) {
80104db9:	31 c0                	xor    %eax,%eax
80104dbb:	eb 11                	jmp    80104dce <sys_dl_proc+0x5e>
80104dbd:	8d 76 00             	lea    0x0(%esi),%esi
80104dc0:	83 c0 01             	add    $0x1,%eax
80104dc3:	81 c2 b8 00 00 00    	add    $0xb8,%edx
80104dc9:	83 f8 40             	cmp    $0x40,%eax
80104dcc:	74 52                	je     80104e20 <sys_dl_proc+0xb0>
      if(ptable.proc[index].pid == pid) {
80104dce:	39 0a                	cmp    %ecx,(%edx)
80104dd0:	75 ee                	jne    80104dc0 <sys_dl_proc+0x50>
        ptable.proc[index].deadline = dead_line;
80104dd2:	69 d0 b8 00 00 00    	imul   $0xb8,%eax,%edx
80104dd8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80104ddb:	81 c2 20 2d 11 80    	add    $0x80112d20,%edx
        if(ptable.proc[index].state == RUNNABLE) {
80104de1:	83 7a 40 03          	cmpl   $0x3,0x40(%edx)
        ptable.proc[index].deadline = dead_line;
80104de5:	89 8a b8 00 00 00    	mov    %ecx,0xb8(%edx)
        if(ptable.proc[index].state == RUNNABLE) {
80104deb:	74 5b                	je     80104e48 <sys_dl_proc+0xd8>
          change_num(&ptable.proc[index], -1);
          ptable.proc[index].queue = CLASS1;
          change_num(&ptable.proc[index], 1);
        }
        else {
          ptable.proc[index].queue = CLASS1;
80104ded:	c7 82 b0 00 00 00 00 	movl   $0x0,0xb0(%edx)
80104df4:	00 00 00 
        }
        flag = 1;
        break;
      }
    }
    release(&ptable.lock);
80104df7:	83 ec 0c             	sub    $0xc,%esp
80104dfa:	68 20 2d 11 80       	push   $0x80112d20
80104dff:	e8 3c 03 00 00       	call   80105140 <release>
80104e04:	83 c4 10             	add    $0x10,%esp
    if(flag == 1){
      printprocinfo();
80104e07:	e8 b4 fa ff ff       	call   801048c0 <printprocinfo>
    }
    else {
      cprintf("proc not found!");

    }
    return 1;
80104e0c:	b8 01 00 00 00       	mov    $0x1,%eax
80104e11:	c9                   	leave  
80104e12:	c3                   	ret    
80104e13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e17:	90                   	nop
80104e18:	c9                   	leave  
        return -1;
80104e19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e1e:	c3                   	ret    
80104e1f:	90                   	nop
    release(&ptable.lock);
80104e20:	83 ec 0c             	sub    $0xc,%esp
80104e23:	68 20 2d 11 80       	push   $0x80112d20
80104e28:	e8 13 03 00 00       	call   80105140 <release>
      cprintf("proc not found!");
80104e2d:	c7 04 24 eb 83 10 80 	movl   $0x801083eb,(%esp)
80104e34:	e8 67 b8 ff ff       	call   801006a0 <cprintf>
80104e39:	83 c4 10             	add    $0x10,%esp
    return 1;
80104e3c:	b8 01 00 00 00       	mov    $0x1,%eax
80104e41:	c9                   	leave  
80104e42:	c3                   	ret    
80104e43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e47:	90                   	nop
  if(p->queue==CLASS1){
80104e48:	8b 8a b0 00 00 00    	mov    0xb0(%edx),%ecx
    ptable.class1_num = ptable.class1_num + inc_or_dec;
80104e4e:	8b 15 54 5b 11 80    	mov    0x80115b54,%edx
  if(p->queue==CLASS1){
80104e54:	85 c9                	test   %ecx,%ecx
80104e56:	74 0f                	je     80104e67 <sys_dl_proc+0xf7>
    ptable.class1_num = ptable.class1_num + inc_or_dec;
80104e58:	83 c2 01             	add    $0x1,%edx
    if(p->queue==CLASS2_RR){
80104e5b:	83 f9 01             	cmp    $0x1,%ecx
80104e5e:	74 32                	je     80104e92 <sys_dl_proc+0x122>
      ptable.fcfs_num = ptable.fcfs_num + inc_or_dec;
80104e60:	83 2d 5c 5b 11 80 01 	subl   $0x1,0x80115b5c
    release(&ptable.lock);
80104e67:	83 ec 0c             	sub    $0xc,%esp
          ptable.proc[index].queue = CLASS1;
80104e6a:	69 c0 b8 00 00 00    	imul   $0xb8,%eax,%eax
    ptable.class1_num = ptable.class1_num + inc_or_dec;
80104e70:	89 15 54 5b 11 80    	mov    %edx,0x80115b54
    release(&ptable.lock);
80104e76:	68 20 2d 11 80       	push   $0x80112d20
          ptable.proc[index].queue = CLASS1;
80104e7b:	c7 80 d0 2d 11 80 00 	movl   $0x0,-0x7feed230(%eax)
80104e82:	00 00 00 
    release(&ptable.lock);
80104e85:	e8 b6 02 00 00       	call   80105140 <release>
80104e8a:	83 c4 10             	add    $0x10,%esp
80104e8d:	e9 75 ff ff ff       	jmp    80104e07 <sys_dl_proc+0x97>
      ptable.rr_num = ptable.rr_num + inc_or_dec;
80104e92:	83 2d 58 5b 11 80 01 	subl   $0x1,0x80115b58
80104e99:	eb cc                	jmp    80104e67 <sys_dl_proc+0xf7>
80104e9b:	66 90                	xchg   %ax,%ax
80104e9d:	66 90                	xchg   %ax,%ax
80104e9f:	90                   	nop

80104ea0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	53                   	push   %ebx
80104ea4:	83 ec 0c             	sub    $0xc,%esp
80104ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104eaa:	68 20 86 10 80       	push   $0x80108620
80104eaf:	8d 43 04             	lea    0x4(%ebx),%eax
80104eb2:	50                   	push   %eax
80104eb3:	e8 18 01 00 00       	call   80104fd0 <initlock>
  lk->name = name;
80104eb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104ebb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104ec1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104ec4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104ecb:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104ece:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ed1:	c9                   	leave  
80104ed2:	c3                   	ret    
80104ed3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ee0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	56                   	push   %esi
80104ee4:	53                   	push   %ebx
80104ee5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104ee8:	8d 73 04             	lea    0x4(%ebx),%esi
80104eeb:	83 ec 0c             	sub    $0xc,%esp
80104eee:	56                   	push   %esi
80104eef:	e8 ac 02 00 00       	call   801051a0 <acquire>
  while (lk->locked) {
80104ef4:	8b 13                	mov    (%ebx),%edx
80104ef6:	83 c4 10             	add    $0x10,%esp
80104ef9:	85 d2                	test   %edx,%edx
80104efb:	74 16                	je     80104f13 <acquiresleep+0x33>
80104efd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104f00:	83 ec 08             	sub    $0x8,%esp
80104f03:	56                   	push   %esi
80104f04:	53                   	push   %ebx
80104f05:	e8 d6 f4 ff ff       	call   801043e0 <sleep>
  while (lk->locked) {
80104f0a:	8b 03                	mov    (%ebx),%eax
80104f0c:	83 c4 10             	add    $0x10,%esp
80104f0f:	85 c0                	test   %eax,%eax
80104f11:	75 ed                	jne    80104f00 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104f13:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104f19:	e8 12 eb ff ff       	call   80103a30 <myproc>
80104f1e:	8b 40 10             	mov    0x10(%eax),%eax
80104f21:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104f24:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104f27:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f2a:	5b                   	pop    %ebx
80104f2b:	5e                   	pop    %esi
80104f2c:	5d                   	pop    %ebp
  release(&lk->lk);
80104f2d:	e9 0e 02 00 00       	jmp    80105140 <release>
80104f32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f40 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
80104f43:	56                   	push   %esi
80104f44:	53                   	push   %ebx
80104f45:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104f48:	8d 73 04             	lea    0x4(%ebx),%esi
80104f4b:	83 ec 0c             	sub    $0xc,%esp
80104f4e:	56                   	push   %esi
80104f4f:	e8 4c 02 00 00       	call   801051a0 <acquire>
  lk->locked = 0;
80104f54:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104f5a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104f61:	89 1c 24             	mov    %ebx,(%esp)
80104f64:	e8 37 f5 ff ff       	call   801044a0 <wakeup>
  release(&lk->lk);
80104f69:	89 75 08             	mov    %esi,0x8(%ebp)
80104f6c:	83 c4 10             	add    $0x10,%esp
}
80104f6f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f72:	5b                   	pop    %ebx
80104f73:	5e                   	pop    %esi
80104f74:	5d                   	pop    %ebp
  release(&lk->lk);
80104f75:	e9 c6 01 00 00       	jmp    80105140 <release>
80104f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f80 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	57                   	push   %edi
80104f84:	31 ff                	xor    %edi,%edi
80104f86:	56                   	push   %esi
80104f87:	53                   	push   %ebx
80104f88:	83 ec 18             	sub    $0x18,%esp
80104f8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104f8e:	8d 73 04             	lea    0x4(%ebx),%esi
80104f91:	56                   	push   %esi
80104f92:	e8 09 02 00 00       	call   801051a0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104f97:	8b 03                	mov    (%ebx),%eax
80104f99:	83 c4 10             	add    $0x10,%esp
80104f9c:	85 c0                	test   %eax,%eax
80104f9e:	75 18                	jne    80104fb8 <holdingsleep+0x38>
  release(&lk->lk);
80104fa0:	83 ec 0c             	sub    $0xc,%esp
80104fa3:	56                   	push   %esi
80104fa4:	e8 97 01 00 00       	call   80105140 <release>
  return r;
}
80104fa9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fac:	89 f8                	mov    %edi,%eax
80104fae:	5b                   	pop    %ebx
80104faf:	5e                   	pop    %esi
80104fb0:	5f                   	pop    %edi
80104fb1:	5d                   	pop    %ebp
80104fb2:	c3                   	ret    
80104fb3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fb7:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104fb8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104fbb:	e8 70 ea ff ff       	call   80103a30 <myproc>
80104fc0:	39 58 10             	cmp    %ebx,0x10(%eax)
80104fc3:	0f 94 c0             	sete   %al
80104fc6:	0f b6 c0             	movzbl %al,%eax
80104fc9:	89 c7                	mov    %eax,%edi
80104fcb:	eb d3                	jmp    80104fa0 <holdingsleep+0x20>
80104fcd:	66 90                	xchg   %ax,%ax
80104fcf:	90                   	nop

80104fd0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104fd6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104fd9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104fdf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104fe2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104fe9:	5d                   	pop    %ebp
80104fea:	c3                   	ret    
80104feb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fef:	90                   	nop

80104ff0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104ff0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104ff1:	31 d2                	xor    %edx,%edx
{
80104ff3:	89 e5                	mov    %esp,%ebp
80104ff5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104ff6:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104ff9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104ffc:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104fff:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105000:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80105006:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010500c:	77 1a                	ja     80105028 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010500e:	8b 58 04             	mov    0x4(%eax),%ebx
80105011:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80105014:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80105017:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105019:	83 fa 0a             	cmp    $0xa,%edx
8010501c:	75 e2                	jne    80105000 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010501e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105021:	c9                   	leave  
80105022:	c3                   	ret    
80105023:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105027:	90                   	nop
  for(; i < 10; i++)
80105028:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010502b:	8d 51 28             	lea    0x28(%ecx),%edx
8010502e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105030:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105036:	83 c0 04             	add    $0x4,%eax
80105039:	39 d0                	cmp    %edx,%eax
8010503b:	75 f3                	jne    80105030 <getcallerpcs+0x40>
}
8010503d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105040:	c9                   	leave  
80105041:	c3                   	ret    
80105042:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105050 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105050:	55                   	push   %ebp
80105051:	89 e5                	mov    %esp,%ebp
80105053:	53                   	push   %ebx
80105054:	83 ec 04             	sub    $0x4,%esp
80105057:	9c                   	pushf  
80105058:	5b                   	pop    %ebx
  asm volatile("cli");
80105059:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010505a:	e8 51 e9 ff ff       	call   801039b0 <mycpu>
8010505f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105065:	85 c0                	test   %eax,%eax
80105067:	74 17                	je     80105080 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80105069:	e8 42 e9 ff ff       	call   801039b0 <mycpu>
8010506e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80105075:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105078:	c9                   	leave  
80105079:	c3                   	ret    
8010507a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80105080:	e8 2b e9 ff ff       	call   801039b0 <mycpu>
80105085:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010508b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80105091:	eb d6                	jmp    80105069 <pushcli+0x19>
80105093:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010509a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801050a0 <popcli>:

void
popcli(void)
{
801050a0:	55                   	push   %ebp
801050a1:	89 e5                	mov    %esp,%ebp
801050a3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801050a6:	9c                   	pushf  
801050a7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801050a8:	f6 c4 02             	test   $0x2,%ah
801050ab:	75 35                	jne    801050e2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801050ad:	e8 fe e8 ff ff       	call   801039b0 <mycpu>
801050b2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801050b9:	78 34                	js     801050ef <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801050bb:	e8 f0 e8 ff ff       	call   801039b0 <mycpu>
801050c0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801050c6:	85 d2                	test   %edx,%edx
801050c8:	74 06                	je     801050d0 <popcli+0x30>
    sti();
}
801050ca:	c9                   	leave  
801050cb:	c3                   	ret    
801050cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801050d0:	e8 db e8 ff ff       	call   801039b0 <mycpu>
801050d5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801050db:	85 c0                	test   %eax,%eax
801050dd:	74 eb                	je     801050ca <popcli+0x2a>
  asm volatile("sti");
801050df:	fb                   	sti    
}
801050e0:	c9                   	leave  
801050e1:	c3                   	ret    
    panic("popcli - interruptible");
801050e2:	83 ec 0c             	sub    $0xc,%esp
801050e5:	68 2b 86 10 80       	push   $0x8010862b
801050ea:	e8 91 b2 ff ff       	call   80100380 <panic>
    panic("popcli");
801050ef:	83 ec 0c             	sub    $0xc,%esp
801050f2:	68 42 86 10 80       	push   $0x80108642
801050f7:	e8 84 b2 ff ff       	call   80100380 <panic>
801050fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105100 <holding>:
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	56                   	push   %esi
80105104:	53                   	push   %ebx
80105105:	8b 75 08             	mov    0x8(%ebp),%esi
80105108:	31 db                	xor    %ebx,%ebx
  pushcli();
8010510a:	e8 41 ff ff ff       	call   80105050 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010510f:	8b 06                	mov    (%esi),%eax
80105111:	85 c0                	test   %eax,%eax
80105113:	75 0b                	jne    80105120 <holding+0x20>
  popcli();
80105115:	e8 86 ff ff ff       	call   801050a0 <popcli>
}
8010511a:	89 d8                	mov    %ebx,%eax
8010511c:	5b                   	pop    %ebx
8010511d:	5e                   	pop    %esi
8010511e:	5d                   	pop    %ebp
8010511f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80105120:	8b 5e 08             	mov    0x8(%esi),%ebx
80105123:	e8 88 e8 ff ff       	call   801039b0 <mycpu>
80105128:	39 c3                	cmp    %eax,%ebx
8010512a:	0f 94 c3             	sete   %bl
  popcli();
8010512d:	e8 6e ff ff ff       	call   801050a0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80105132:	0f b6 db             	movzbl %bl,%ebx
}
80105135:	89 d8                	mov    %ebx,%eax
80105137:	5b                   	pop    %ebx
80105138:	5e                   	pop    %esi
80105139:	5d                   	pop    %ebp
8010513a:	c3                   	ret    
8010513b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010513f:	90                   	nop

80105140 <release>:
{
80105140:	55                   	push   %ebp
80105141:	89 e5                	mov    %esp,%ebp
80105143:	56                   	push   %esi
80105144:	53                   	push   %ebx
80105145:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80105148:	e8 03 ff ff ff       	call   80105050 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010514d:	8b 03                	mov    (%ebx),%eax
8010514f:	85 c0                	test   %eax,%eax
80105151:	75 15                	jne    80105168 <release+0x28>
  popcli();
80105153:	e8 48 ff ff ff       	call   801050a0 <popcli>
    panic("release");
80105158:	83 ec 0c             	sub    $0xc,%esp
8010515b:	68 49 86 10 80       	push   $0x80108649
80105160:	e8 1b b2 ff ff       	call   80100380 <panic>
80105165:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80105168:	8b 73 08             	mov    0x8(%ebx),%esi
8010516b:	e8 40 e8 ff ff       	call   801039b0 <mycpu>
80105170:	39 c6                	cmp    %eax,%esi
80105172:	75 df                	jne    80105153 <release+0x13>
  popcli();
80105174:	e8 27 ff ff ff       	call   801050a0 <popcli>
  lk->pcs[0] = 0;
80105179:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80105180:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105187:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010518c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105192:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105195:	5b                   	pop    %ebx
80105196:	5e                   	pop    %esi
80105197:	5d                   	pop    %ebp
  popcli();
80105198:	e9 03 ff ff ff       	jmp    801050a0 <popcli>
8010519d:	8d 76 00             	lea    0x0(%esi),%esi

801051a0 <acquire>:
{
801051a0:	55                   	push   %ebp
801051a1:	89 e5                	mov    %esp,%ebp
801051a3:	53                   	push   %ebx
801051a4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801051a7:	e8 a4 fe ff ff       	call   80105050 <pushcli>
  if(holding(lk))
801051ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801051af:	e8 9c fe ff ff       	call   80105050 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801051b4:	8b 03                	mov    (%ebx),%eax
801051b6:	85 c0                	test   %eax,%eax
801051b8:	75 7e                	jne    80105238 <acquire+0x98>
  popcli();
801051ba:	e8 e1 fe ff ff       	call   801050a0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
801051bf:	b9 01 00 00 00       	mov    $0x1,%ecx
801051c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
801051c8:	8b 55 08             	mov    0x8(%ebp),%edx
801051cb:	89 c8                	mov    %ecx,%eax
801051cd:	f0 87 02             	lock xchg %eax,(%edx)
801051d0:	85 c0                	test   %eax,%eax
801051d2:	75 f4                	jne    801051c8 <acquire+0x28>
  __sync_synchronize();
801051d4:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801051d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801051dc:	e8 cf e7 ff ff       	call   801039b0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801051e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
801051e4:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
801051e6:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
801051e9:	31 c0                	xor    %eax,%eax
801051eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051ef:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801051f0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801051f6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801051fc:	77 1a                	ja     80105218 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
801051fe:	8b 5a 04             	mov    0x4(%edx),%ebx
80105201:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80105205:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80105208:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010520a:	83 f8 0a             	cmp    $0xa,%eax
8010520d:	75 e1                	jne    801051f0 <acquire+0x50>
}
8010520f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105212:	c9                   	leave  
80105213:	c3                   	ret    
80105214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80105218:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010521c:	8d 51 34             	lea    0x34(%ecx),%edx
8010521f:	90                   	nop
    pcs[i] = 0;
80105220:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105226:	83 c0 04             	add    $0x4,%eax
80105229:	39 c2                	cmp    %eax,%edx
8010522b:	75 f3                	jne    80105220 <acquire+0x80>
}
8010522d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105230:	c9                   	leave  
80105231:	c3                   	ret    
80105232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80105238:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010523b:	e8 70 e7 ff ff       	call   801039b0 <mycpu>
80105240:	39 c3                	cmp    %eax,%ebx
80105242:	0f 85 72 ff ff ff    	jne    801051ba <acquire+0x1a>
  popcli();
80105248:	e8 53 fe ff ff       	call   801050a0 <popcli>
    panic("acquire");
8010524d:	83 ec 0c             	sub    $0xc,%esp
80105250:	68 51 86 10 80       	push   $0x80108651
80105255:	e8 26 b1 ff ff       	call   80100380 <panic>
8010525a:	66 90                	xchg   %ax,%ax
8010525c:	66 90                	xchg   %ax,%ax
8010525e:	66 90                	xchg   %ax,%ax

80105260 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105260:	55                   	push   %ebp
80105261:	89 e5                	mov    %esp,%ebp
80105263:	57                   	push   %edi
80105264:	8b 55 08             	mov    0x8(%ebp),%edx
80105267:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010526a:	53                   	push   %ebx
8010526b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
8010526e:	89 d7                	mov    %edx,%edi
80105270:	09 cf                	or     %ecx,%edi
80105272:	83 e7 03             	and    $0x3,%edi
80105275:	75 29                	jne    801052a0 <memset+0x40>
    c &= 0xFF;
80105277:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010527a:	c1 e0 18             	shl    $0x18,%eax
8010527d:	89 fb                	mov    %edi,%ebx
8010527f:	c1 e9 02             	shr    $0x2,%ecx
80105282:	c1 e3 10             	shl    $0x10,%ebx
80105285:	09 d8                	or     %ebx,%eax
80105287:	09 f8                	or     %edi,%eax
80105289:	c1 e7 08             	shl    $0x8,%edi
8010528c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010528e:	89 d7                	mov    %edx,%edi
80105290:	fc                   	cld    
80105291:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80105293:	5b                   	pop    %ebx
80105294:	89 d0                	mov    %edx,%eax
80105296:	5f                   	pop    %edi
80105297:	5d                   	pop    %ebp
80105298:	c3                   	ret    
80105299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801052a0:	89 d7                	mov    %edx,%edi
801052a2:	fc                   	cld    
801052a3:	f3 aa                	rep stos %al,%es:(%edi)
801052a5:	5b                   	pop    %ebx
801052a6:	89 d0                	mov    %edx,%eax
801052a8:	5f                   	pop    %edi
801052a9:	5d                   	pop    %ebp
801052aa:	c3                   	ret    
801052ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052af:	90                   	nop

801052b0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801052b0:	55                   	push   %ebp
801052b1:	89 e5                	mov    %esp,%ebp
801052b3:	56                   	push   %esi
801052b4:	8b 75 10             	mov    0x10(%ebp),%esi
801052b7:	8b 55 08             	mov    0x8(%ebp),%edx
801052ba:	53                   	push   %ebx
801052bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801052be:	85 f6                	test   %esi,%esi
801052c0:	74 2e                	je     801052f0 <memcmp+0x40>
801052c2:	01 c6                	add    %eax,%esi
801052c4:	eb 14                	jmp    801052da <memcmp+0x2a>
801052c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052cd:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801052d0:	83 c0 01             	add    $0x1,%eax
801052d3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801052d6:	39 f0                	cmp    %esi,%eax
801052d8:	74 16                	je     801052f0 <memcmp+0x40>
    if(*s1 != *s2)
801052da:	0f b6 0a             	movzbl (%edx),%ecx
801052dd:	0f b6 18             	movzbl (%eax),%ebx
801052e0:	38 d9                	cmp    %bl,%cl
801052e2:	74 ec                	je     801052d0 <memcmp+0x20>
      return *s1 - *s2;
801052e4:	0f b6 c1             	movzbl %cl,%eax
801052e7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801052e9:	5b                   	pop    %ebx
801052ea:	5e                   	pop    %esi
801052eb:	5d                   	pop    %ebp
801052ec:	c3                   	ret    
801052ed:	8d 76 00             	lea    0x0(%esi),%esi
801052f0:	5b                   	pop    %ebx
  return 0;
801052f1:	31 c0                	xor    %eax,%eax
}
801052f3:	5e                   	pop    %esi
801052f4:	5d                   	pop    %ebp
801052f5:	c3                   	ret    
801052f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052fd:	8d 76 00             	lea    0x0(%esi),%esi

80105300 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105300:	55                   	push   %ebp
80105301:	89 e5                	mov    %esp,%ebp
80105303:	57                   	push   %edi
80105304:	8b 55 08             	mov    0x8(%ebp),%edx
80105307:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010530a:	56                   	push   %esi
8010530b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010530e:	39 d6                	cmp    %edx,%esi
80105310:	73 26                	jae    80105338 <memmove+0x38>
80105312:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80105315:	39 fa                	cmp    %edi,%edx
80105317:	73 1f                	jae    80105338 <memmove+0x38>
80105319:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
8010531c:	85 c9                	test   %ecx,%ecx
8010531e:	74 0c                	je     8010532c <memmove+0x2c>
      *--d = *--s;
80105320:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80105324:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80105327:	83 e8 01             	sub    $0x1,%eax
8010532a:	73 f4                	jae    80105320 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010532c:	5e                   	pop    %esi
8010532d:	89 d0                	mov    %edx,%eax
8010532f:	5f                   	pop    %edi
80105330:	5d                   	pop    %ebp
80105331:	c3                   	ret    
80105332:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80105338:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
8010533b:	89 d7                	mov    %edx,%edi
8010533d:	85 c9                	test   %ecx,%ecx
8010533f:	74 eb                	je     8010532c <memmove+0x2c>
80105341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105348:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105349:	39 c6                	cmp    %eax,%esi
8010534b:	75 fb                	jne    80105348 <memmove+0x48>
}
8010534d:	5e                   	pop    %esi
8010534e:	89 d0                	mov    %edx,%eax
80105350:	5f                   	pop    %edi
80105351:	5d                   	pop    %ebp
80105352:	c3                   	ret    
80105353:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010535a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105360 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80105360:	eb 9e                	jmp    80105300 <memmove>
80105362:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105370 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105370:	55                   	push   %ebp
80105371:	89 e5                	mov    %esp,%ebp
80105373:	56                   	push   %esi
80105374:	8b 75 10             	mov    0x10(%ebp),%esi
80105377:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010537a:	53                   	push   %ebx
8010537b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
8010537e:	85 f6                	test   %esi,%esi
80105380:	74 2e                	je     801053b0 <strncmp+0x40>
80105382:	01 d6                	add    %edx,%esi
80105384:	eb 18                	jmp    8010539e <strncmp+0x2e>
80105386:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010538d:	8d 76 00             	lea    0x0(%esi),%esi
80105390:	38 d8                	cmp    %bl,%al
80105392:	75 14                	jne    801053a8 <strncmp+0x38>
    n--, p++, q++;
80105394:	83 c2 01             	add    $0x1,%edx
80105397:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010539a:	39 f2                	cmp    %esi,%edx
8010539c:	74 12                	je     801053b0 <strncmp+0x40>
8010539e:	0f b6 01             	movzbl (%ecx),%eax
801053a1:	0f b6 1a             	movzbl (%edx),%ebx
801053a4:	84 c0                	test   %al,%al
801053a6:	75 e8                	jne    80105390 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801053a8:	29 d8                	sub    %ebx,%eax
}
801053aa:	5b                   	pop    %ebx
801053ab:	5e                   	pop    %esi
801053ac:	5d                   	pop    %ebp
801053ad:	c3                   	ret    
801053ae:	66 90                	xchg   %ax,%ax
801053b0:	5b                   	pop    %ebx
    return 0;
801053b1:	31 c0                	xor    %eax,%eax
}
801053b3:	5e                   	pop    %esi
801053b4:	5d                   	pop    %ebp
801053b5:	c3                   	ret    
801053b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053bd:	8d 76 00             	lea    0x0(%esi),%esi

801053c0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
801053c3:	57                   	push   %edi
801053c4:	56                   	push   %esi
801053c5:	8b 75 08             	mov    0x8(%ebp),%esi
801053c8:	53                   	push   %ebx
801053c9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801053cc:	89 f0                	mov    %esi,%eax
801053ce:	eb 15                	jmp    801053e5 <strncpy+0x25>
801053d0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801053d4:	8b 7d 0c             	mov    0xc(%ebp),%edi
801053d7:	83 c0 01             	add    $0x1,%eax
801053da:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
801053de:	88 50 ff             	mov    %dl,-0x1(%eax)
801053e1:	84 d2                	test   %dl,%dl
801053e3:	74 09                	je     801053ee <strncpy+0x2e>
801053e5:	89 cb                	mov    %ecx,%ebx
801053e7:	83 e9 01             	sub    $0x1,%ecx
801053ea:	85 db                	test   %ebx,%ebx
801053ec:	7f e2                	jg     801053d0 <strncpy+0x10>
    ;
  while(n-- > 0)
801053ee:	89 c2                	mov    %eax,%edx
801053f0:	85 c9                	test   %ecx,%ecx
801053f2:	7e 17                	jle    8010540b <strncpy+0x4b>
801053f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801053f8:	83 c2 01             	add    $0x1,%edx
801053fb:	89 c1                	mov    %eax,%ecx
801053fd:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80105401:	29 d1                	sub    %edx,%ecx
80105403:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80105407:	85 c9                	test   %ecx,%ecx
80105409:	7f ed                	jg     801053f8 <strncpy+0x38>
  return os;
}
8010540b:	5b                   	pop    %ebx
8010540c:	89 f0                	mov    %esi,%eax
8010540e:	5e                   	pop    %esi
8010540f:	5f                   	pop    %edi
80105410:	5d                   	pop    %ebp
80105411:	c3                   	ret    
80105412:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105420 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105420:	55                   	push   %ebp
80105421:	89 e5                	mov    %esp,%ebp
80105423:	56                   	push   %esi
80105424:	8b 55 10             	mov    0x10(%ebp),%edx
80105427:	8b 75 08             	mov    0x8(%ebp),%esi
8010542a:	53                   	push   %ebx
8010542b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010542e:	85 d2                	test   %edx,%edx
80105430:	7e 25                	jle    80105457 <safestrcpy+0x37>
80105432:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80105436:	89 f2                	mov    %esi,%edx
80105438:	eb 16                	jmp    80105450 <safestrcpy+0x30>
8010543a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105440:	0f b6 08             	movzbl (%eax),%ecx
80105443:	83 c0 01             	add    $0x1,%eax
80105446:	83 c2 01             	add    $0x1,%edx
80105449:	88 4a ff             	mov    %cl,-0x1(%edx)
8010544c:	84 c9                	test   %cl,%cl
8010544e:	74 04                	je     80105454 <safestrcpy+0x34>
80105450:	39 d8                	cmp    %ebx,%eax
80105452:	75 ec                	jne    80105440 <safestrcpy+0x20>
    ;
  *s = 0;
80105454:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105457:	89 f0                	mov    %esi,%eax
80105459:	5b                   	pop    %ebx
8010545a:	5e                   	pop    %esi
8010545b:	5d                   	pop    %ebp
8010545c:	c3                   	ret    
8010545d:	8d 76 00             	lea    0x0(%esi),%esi

80105460 <strlen>:

int
strlen(const char *s)
{
80105460:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105461:	31 c0                	xor    %eax,%eax
{
80105463:	89 e5                	mov    %esp,%ebp
80105465:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105468:	80 3a 00             	cmpb   $0x0,(%edx)
8010546b:	74 0c                	je     80105479 <strlen+0x19>
8010546d:	8d 76 00             	lea    0x0(%esi),%esi
80105470:	83 c0 01             	add    $0x1,%eax
80105473:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105477:	75 f7                	jne    80105470 <strlen+0x10>
    ;
  return n;
}
80105479:	5d                   	pop    %ebp
8010547a:	c3                   	ret    

8010547b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010547b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010547f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105483:	55                   	push   %ebp
  pushl %ebx
80105484:	53                   	push   %ebx
  pushl %esi
80105485:	56                   	push   %esi
  pushl %edi
80105486:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105487:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105489:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010548b:	5f                   	pop    %edi
  popl %esi
8010548c:	5e                   	pop    %esi
  popl %ebx
8010548d:	5b                   	pop    %ebx
  popl %ebp
8010548e:	5d                   	pop    %ebp
  ret
8010548f:	c3                   	ret    

80105490 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105490:	55                   	push   %ebp
80105491:	89 e5                	mov    %esp,%ebp
80105493:	53                   	push   %ebx
80105494:	83 ec 04             	sub    $0x4,%esp
80105497:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010549a:	e8 91 e5 ff ff       	call   80103a30 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010549f:	8b 00                	mov    (%eax),%eax
801054a1:	39 d8                	cmp    %ebx,%eax
801054a3:	76 1b                	jbe    801054c0 <fetchint+0x30>
801054a5:	8d 53 04             	lea    0x4(%ebx),%edx
801054a8:	39 d0                	cmp    %edx,%eax
801054aa:	72 14                	jb     801054c0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801054ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801054af:	8b 13                	mov    (%ebx),%edx
801054b1:	89 10                	mov    %edx,(%eax)
  return 0;
801054b3:	31 c0                	xor    %eax,%eax
}
801054b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801054b8:	c9                   	leave  
801054b9:	c3                   	ret    
801054ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801054c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054c5:	eb ee                	jmp    801054b5 <fetchint+0x25>
801054c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054ce:	66 90                	xchg   %ax,%ax

801054d0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801054d0:	55                   	push   %ebp
801054d1:	89 e5                	mov    %esp,%ebp
801054d3:	53                   	push   %ebx
801054d4:	83 ec 04             	sub    $0x4,%esp
801054d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801054da:	e8 51 e5 ff ff       	call   80103a30 <myproc>

  if(addr >= curproc->sz)
801054df:	39 18                	cmp    %ebx,(%eax)
801054e1:	76 2d                	jbe    80105510 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
801054e3:	8b 55 0c             	mov    0xc(%ebp),%edx
801054e6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801054e8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801054ea:	39 d3                	cmp    %edx,%ebx
801054ec:	73 22                	jae    80105510 <fetchstr+0x40>
801054ee:	89 d8                	mov    %ebx,%eax
801054f0:	eb 0d                	jmp    801054ff <fetchstr+0x2f>
801054f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801054f8:	83 c0 01             	add    $0x1,%eax
801054fb:	39 c2                	cmp    %eax,%edx
801054fd:	76 11                	jbe    80105510 <fetchstr+0x40>
    if(*s == 0)
801054ff:	80 38 00             	cmpb   $0x0,(%eax)
80105502:	75 f4                	jne    801054f8 <fetchstr+0x28>
      return s - *pp;
80105504:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80105506:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105509:	c9                   	leave  
8010550a:	c3                   	ret    
8010550b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010550f:	90                   	nop
80105510:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105513:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105518:	c9                   	leave  
80105519:	c3                   	ret    
8010551a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105520 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105520:	55                   	push   %ebp
80105521:	89 e5                	mov    %esp,%ebp
80105523:	56                   	push   %esi
80105524:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105525:	e8 06 e5 ff ff       	call   80103a30 <myproc>
8010552a:	8b 55 08             	mov    0x8(%ebp),%edx
8010552d:	8b 40 18             	mov    0x18(%eax),%eax
80105530:	8b 40 44             	mov    0x44(%eax),%eax
80105533:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105536:	e8 f5 e4 ff ff       	call   80103a30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010553b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010553e:	8b 00                	mov    (%eax),%eax
80105540:	39 c6                	cmp    %eax,%esi
80105542:	73 1c                	jae    80105560 <argint+0x40>
80105544:	8d 53 08             	lea    0x8(%ebx),%edx
80105547:	39 d0                	cmp    %edx,%eax
80105549:	72 15                	jb     80105560 <argint+0x40>
  *ip = *(int*)(addr);
8010554b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010554e:	8b 53 04             	mov    0x4(%ebx),%edx
80105551:	89 10                	mov    %edx,(%eax)
  return 0;
80105553:	31 c0                	xor    %eax,%eax
}
80105555:	5b                   	pop    %ebx
80105556:	5e                   	pop    %esi
80105557:	5d                   	pop    %ebp
80105558:	c3                   	ret    
80105559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105560:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105565:	eb ee                	jmp    80105555 <argint+0x35>
80105567:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010556e:	66 90                	xchg   %ax,%ax

80105570 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105570:	55                   	push   %ebp
80105571:	89 e5                	mov    %esp,%ebp
80105573:	57                   	push   %edi
80105574:	56                   	push   %esi
80105575:	53                   	push   %ebx
80105576:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80105579:	e8 b2 e4 ff ff       	call   80103a30 <myproc>
8010557e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105580:	e8 ab e4 ff ff       	call   80103a30 <myproc>
80105585:	8b 55 08             	mov    0x8(%ebp),%edx
80105588:	8b 40 18             	mov    0x18(%eax),%eax
8010558b:	8b 40 44             	mov    0x44(%eax),%eax
8010558e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105591:	e8 9a e4 ff ff       	call   80103a30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105596:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105599:	8b 00                	mov    (%eax),%eax
8010559b:	39 c7                	cmp    %eax,%edi
8010559d:	73 31                	jae    801055d0 <argptr+0x60>
8010559f:	8d 4b 08             	lea    0x8(%ebx),%ecx
801055a2:	39 c8                	cmp    %ecx,%eax
801055a4:	72 2a                	jb     801055d0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801055a6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
801055a9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801055ac:	85 d2                	test   %edx,%edx
801055ae:	78 20                	js     801055d0 <argptr+0x60>
801055b0:	8b 16                	mov    (%esi),%edx
801055b2:	39 c2                	cmp    %eax,%edx
801055b4:	76 1a                	jbe    801055d0 <argptr+0x60>
801055b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801055b9:	01 c3                	add    %eax,%ebx
801055bb:	39 da                	cmp    %ebx,%edx
801055bd:	72 11                	jb     801055d0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
801055bf:	8b 55 0c             	mov    0xc(%ebp),%edx
801055c2:	89 02                	mov    %eax,(%edx)
  return 0;
801055c4:	31 c0                	xor    %eax,%eax
}
801055c6:	83 c4 0c             	add    $0xc,%esp
801055c9:	5b                   	pop    %ebx
801055ca:	5e                   	pop    %esi
801055cb:	5f                   	pop    %edi
801055cc:	5d                   	pop    %ebp
801055cd:	c3                   	ret    
801055ce:	66 90                	xchg   %ax,%ax
    return -1;
801055d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055d5:	eb ef                	jmp    801055c6 <argptr+0x56>
801055d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055de:	66 90                	xchg   %ax,%ax

801055e0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	56                   	push   %esi
801055e4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801055e5:	e8 46 e4 ff ff       	call   80103a30 <myproc>
801055ea:	8b 55 08             	mov    0x8(%ebp),%edx
801055ed:	8b 40 18             	mov    0x18(%eax),%eax
801055f0:	8b 40 44             	mov    0x44(%eax),%eax
801055f3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801055f6:	e8 35 e4 ff ff       	call   80103a30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801055fb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801055fe:	8b 00                	mov    (%eax),%eax
80105600:	39 c6                	cmp    %eax,%esi
80105602:	73 44                	jae    80105648 <argstr+0x68>
80105604:	8d 53 08             	lea    0x8(%ebx),%edx
80105607:	39 d0                	cmp    %edx,%eax
80105609:	72 3d                	jb     80105648 <argstr+0x68>
  *ip = *(int*)(addr);
8010560b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
8010560e:	e8 1d e4 ff ff       	call   80103a30 <myproc>
  if(addr >= curproc->sz)
80105613:	3b 18                	cmp    (%eax),%ebx
80105615:	73 31                	jae    80105648 <argstr+0x68>
  *pp = (char*)addr;
80105617:	8b 55 0c             	mov    0xc(%ebp),%edx
8010561a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010561c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010561e:	39 d3                	cmp    %edx,%ebx
80105620:	73 26                	jae    80105648 <argstr+0x68>
80105622:	89 d8                	mov    %ebx,%eax
80105624:	eb 11                	jmp    80105637 <argstr+0x57>
80105626:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010562d:	8d 76 00             	lea    0x0(%esi),%esi
80105630:	83 c0 01             	add    $0x1,%eax
80105633:	39 c2                	cmp    %eax,%edx
80105635:	76 11                	jbe    80105648 <argstr+0x68>
    if(*s == 0)
80105637:	80 38 00             	cmpb   $0x0,(%eax)
8010563a:	75 f4                	jne    80105630 <argstr+0x50>
      return s - *pp;
8010563c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
8010563e:	5b                   	pop    %ebx
8010563f:	5e                   	pop    %esi
80105640:	5d                   	pop    %ebp
80105641:	c3                   	ret    
80105642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105648:	5b                   	pop    %ebx
    return -1;
80105649:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010564e:	5e                   	pop    %esi
8010564f:	5d                   	pop    %ebp
80105650:	c3                   	ret    
80105651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105658:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010565f:	90                   	nop

80105660 <syscall>:
[SYS_dl_proc]   sys_dl_proc, 
};

void
syscall(void)
{
80105660:	55                   	push   %ebp
80105661:	89 e5                	mov    %esp,%ebp
80105663:	53                   	push   %ebx
80105664:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105667:	e8 c4 e3 ff ff       	call   80103a30 <myproc>
8010566c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010566e:	8b 40 18             	mov    0x18(%eax),%eax
80105671:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105674:	8d 50 ff             	lea    -0x1(%eax),%edx
80105677:	83 fa 17             	cmp    $0x17,%edx
8010567a:	77 24                	ja     801056a0 <syscall+0x40>
8010567c:	8b 14 85 80 86 10 80 	mov    -0x7fef7980(,%eax,4),%edx
80105683:	85 d2                	test   %edx,%edx
80105685:	74 19                	je     801056a0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80105687:	ff d2                	call   *%edx
80105689:	89 c2                	mov    %eax,%edx
8010568b:	8b 43 18             	mov    0x18(%ebx),%eax
8010568e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105691:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105694:	c9                   	leave  
80105695:	c3                   	ret    
80105696:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010569d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
801056a0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801056a1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801056a4:	50                   	push   %eax
801056a5:	ff 73 10             	push   0x10(%ebx)
801056a8:	68 59 86 10 80       	push   $0x80108659
801056ad:	e8 ee af ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
801056b2:	8b 43 18             	mov    0x18(%ebx),%eax
801056b5:	83 c4 10             	add    $0x10,%esp
801056b8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801056bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056c2:	c9                   	leave  
801056c3:	c3                   	ret    
801056c4:	66 90                	xchg   %ax,%ax
801056c6:	66 90                	xchg   %ax,%ax
801056c8:	66 90                	xchg   %ax,%ax
801056ca:	66 90                	xchg   %ax,%ax
801056cc:	66 90                	xchg   %ax,%ax
801056ce:	66 90                	xchg   %ax,%ax

801056d0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
801056d3:	57                   	push   %edi
801056d4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801056d5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
801056d8:	53                   	push   %ebx
801056d9:	83 ec 34             	sub    $0x34,%esp
801056dc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801056df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801056e2:	57                   	push   %edi
801056e3:	50                   	push   %eax
{
801056e4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801056e7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801056ea:	e8 41 ca ff ff       	call   80102130 <nameiparent>
801056ef:	83 c4 10             	add    $0x10,%esp
801056f2:	85 c0                	test   %eax,%eax
801056f4:	0f 84 46 01 00 00    	je     80105840 <create+0x170>
    return 0;
  ilock(dp);
801056fa:	83 ec 0c             	sub    $0xc,%esp
801056fd:	89 c3                	mov    %eax,%ebx
801056ff:	50                   	push   %eax
80105700:	e8 eb c0 ff ff       	call   801017f0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105705:	83 c4 0c             	add    $0xc,%esp
80105708:	6a 00                	push   $0x0
8010570a:	57                   	push   %edi
8010570b:	53                   	push   %ebx
8010570c:	e8 3f c6 ff ff       	call   80101d50 <dirlookup>
80105711:	83 c4 10             	add    $0x10,%esp
80105714:	89 c6                	mov    %eax,%esi
80105716:	85 c0                	test   %eax,%eax
80105718:	74 56                	je     80105770 <create+0xa0>
    iunlockput(dp);
8010571a:	83 ec 0c             	sub    $0xc,%esp
8010571d:	53                   	push   %ebx
8010571e:	e8 5d c3 ff ff       	call   80101a80 <iunlockput>
    ilock(ip);
80105723:	89 34 24             	mov    %esi,(%esp)
80105726:	e8 c5 c0 ff ff       	call   801017f0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010572b:	83 c4 10             	add    $0x10,%esp
8010572e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105733:	75 1b                	jne    80105750 <create+0x80>
80105735:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010573a:	75 14                	jne    80105750 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010573c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010573f:	89 f0                	mov    %esi,%eax
80105741:	5b                   	pop    %ebx
80105742:	5e                   	pop    %esi
80105743:	5f                   	pop    %edi
80105744:	5d                   	pop    %ebp
80105745:	c3                   	ret    
80105746:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010574d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105750:	83 ec 0c             	sub    $0xc,%esp
80105753:	56                   	push   %esi
    return 0;
80105754:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105756:	e8 25 c3 ff ff       	call   80101a80 <iunlockput>
    return 0;
8010575b:	83 c4 10             	add    $0x10,%esp
}
8010575e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105761:	89 f0                	mov    %esi,%eax
80105763:	5b                   	pop    %ebx
80105764:	5e                   	pop    %esi
80105765:	5f                   	pop    %edi
80105766:	5d                   	pop    %ebp
80105767:	c3                   	ret    
80105768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010576f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105770:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105774:	83 ec 08             	sub    $0x8,%esp
80105777:	50                   	push   %eax
80105778:	ff 33                	push   (%ebx)
8010577a:	e8 01 bf ff ff       	call   80101680 <ialloc>
8010577f:	83 c4 10             	add    $0x10,%esp
80105782:	89 c6                	mov    %eax,%esi
80105784:	85 c0                	test   %eax,%eax
80105786:	0f 84 cd 00 00 00    	je     80105859 <create+0x189>
  ilock(ip);
8010578c:	83 ec 0c             	sub    $0xc,%esp
8010578f:	50                   	push   %eax
80105790:	e8 5b c0 ff ff       	call   801017f0 <ilock>
  ip->major = major;
80105795:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105799:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010579d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801057a1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801057a5:	b8 01 00 00 00       	mov    $0x1,%eax
801057aa:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801057ae:	89 34 24             	mov    %esi,(%esp)
801057b1:	e8 8a bf ff ff       	call   80101740 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801057b6:	83 c4 10             	add    $0x10,%esp
801057b9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801057be:	74 30                	je     801057f0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
801057c0:	83 ec 04             	sub    $0x4,%esp
801057c3:	ff 76 04             	push   0x4(%esi)
801057c6:	57                   	push   %edi
801057c7:	53                   	push   %ebx
801057c8:	e8 83 c8 ff ff       	call   80102050 <dirlink>
801057cd:	83 c4 10             	add    $0x10,%esp
801057d0:	85 c0                	test   %eax,%eax
801057d2:	78 78                	js     8010584c <create+0x17c>
  iunlockput(dp);
801057d4:	83 ec 0c             	sub    $0xc,%esp
801057d7:	53                   	push   %ebx
801057d8:	e8 a3 c2 ff ff       	call   80101a80 <iunlockput>
  return ip;
801057dd:	83 c4 10             	add    $0x10,%esp
}
801057e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057e3:	89 f0                	mov    %esi,%eax
801057e5:	5b                   	pop    %ebx
801057e6:	5e                   	pop    %esi
801057e7:	5f                   	pop    %edi
801057e8:	5d                   	pop    %ebp
801057e9:	c3                   	ret    
801057ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
801057f0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
801057f3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801057f8:	53                   	push   %ebx
801057f9:	e8 42 bf ff ff       	call   80101740 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801057fe:	83 c4 0c             	add    $0xc,%esp
80105801:	ff 76 04             	push   0x4(%esi)
80105804:	68 00 87 10 80       	push   $0x80108700
80105809:	56                   	push   %esi
8010580a:	e8 41 c8 ff ff       	call   80102050 <dirlink>
8010580f:	83 c4 10             	add    $0x10,%esp
80105812:	85 c0                	test   %eax,%eax
80105814:	78 18                	js     8010582e <create+0x15e>
80105816:	83 ec 04             	sub    $0x4,%esp
80105819:	ff 73 04             	push   0x4(%ebx)
8010581c:	68 ff 86 10 80       	push   $0x801086ff
80105821:	56                   	push   %esi
80105822:	e8 29 c8 ff ff       	call   80102050 <dirlink>
80105827:	83 c4 10             	add    $0x10,%esp
8010582a:	85 c0                	test   %eax,%eax
8010582c:	79 92                	jns    801057c0 <create+0xf0>
      panic("create dots");
8010582e:	83 ec 0c             	sub    $0xc,%esp
80105831:	68 f3 86 10 80       	push   $0x801086f3
80105836:	e8 45 ab ff ff       	call   80100380 <panic>
8010583b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010583f:	90                   	nop
}
80105840:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105843:	31 f6                	xor    %esi,%esi
}
80105845:	5b                   	pop    %ebx
80105846:	89 f0                	mov    %esi,%eax
80105848:	5e                   	pop    %esi
80105849:	5f                   	pop    %edi
8010584a:	5d                   	pop    %ebp
8010584b:	c3                   	ret    
    panic("create: dirlink");
8010584c:	83 ec 0c             	sub    $0xc,%esp
8010584f:	68 02 87 10 80       	push   $0x80108702
80105854:	e8 27 ab ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80105859:	83 ec 0c             	sub    $0xc,%esp
8010585c:	68 e4 86 10 80       	push   $0x801086e4
80105861:	e8 1a ab ff ff       	call   80100380 <panic>
80105866:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010586d:	8d 76 00             	lea    0x0(%esi),%esi

80105870 <sys_dup>:
{
80105870:	55                   	push   %ebp
80105871:	89 e5                	mov    %esp,%ebp
80105873:	56                   	push   %esi
80105874:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105875:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105878:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010587b:	50                   	push   %eax
8010587c:	6a 00                	push   $0x0
8010587e:	e8 9d fc ff ff       	call   80105520 <argint>
80105883:	83 c4 10             	add    $0x10,%esp
80105886:	85 c0                	test   %eax,%eax
80105888:	78 36                	js     801058c0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010588a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010588e:	77 30                	ja     801058c0 <sys_dup+0x50>
80105890:	e8 9b e1 ff ff       	call   80103a30 <myproc>
80105895:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105898:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010589c:	85 f6                	test   %esi,%esi
8010589e:	74 20                	je     801058c0 <sys_dup+0x50>
  struct proc *curproc = myproc();
801058a0:	e8 8b e1 ff ff       	call   80103a30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801058a5:	31 db                	xor    %ebx,%ebx
801058a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ae:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
801058b0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801058b4:	85 d2                	test   %edx,%edx
801058b6:	74 18                	je     801058d0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
801058b8:	83 c3 01             	add    $0x1,%ebx
801058bb:	83 fb 10             	cmp    $0x10,%ebx
801058be:	75 f0                	jne    801058b0 <sys_dup+0x40>
}
801058c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801058c3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801058c8:	89 d8                	mov    %ebx,%eax
801058ca:	5b                   	pop    %ebx
801058cb:	5e                   	pop    %esi
801058cc:	5d                   	pop    %ebp
801058cd:	c3                   	ret    
801058ce:	66 90                	xchg   %ax,%ax
  filedup(f);
801058d0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801058d3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801058d7:	56                   	push   %esi
801058d8:	e8 33 b6 ff ff       	call   80100f10 <filedup>
  return fd;
801058dd:	83 c4 10             	add    $0x10,%esp
}
801058e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801058e3:	89 d8                	mov    %ebx,%eax
801058e5:	5b                   	pop    %ebx
801058e6:	5e                   	pop    %esi
801058e7:	5d                   	pop    %ebp
801058e8:	c3                   	ret    
801058e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801058f0 <sys_read>:
{
801058f0:	55                   	push   %ebp
801058f1:	89 e5                	mov    %esp,%ebp
801058f3:	56                   	push   %esi
801058f4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801058f5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801058f8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801058fb:	53                   	push   %ebx
801058fc:	6a 00                	push   $0x0
801058fe:	e8 1d fc ff ff       	call   80105520 <argint>
80105903:	83 c4 10             	add    $0x10,%esp
80105906:	85 c0                	test   %eax,%eax
80105908:	78 5e                	js     80105968 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010590a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010590e:	77 58                	ja     80105968 <sys_read+0x78>
80105910:	e8 1b e1 ff ff       	call   80103a30 <myproc>
80105915:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105918:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010591c:	85 f6                	test   %esi,%esi
8010591e:	74 48                	je     80105968 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105920:	83 ec 08             	sub    $0x8,%esp
80105923:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105926:	50                   	push   %eax
80105927:	6a 02                	push   $0x2
80105929:	e8 f2 fb ff ff       	call   80105520 <argint>
8010592e:	83 c4 10             	add    $0x10,%esp
80105931:	85 c0                	test   %eax,%eax
80105933:	78 33                	js     80105968 <sys_read+0x78>
80105935:	83 ec 04             	sub    $0x4,%esp
80105938:	ff 75 f0             	push   -0x10(%ebp)
8010593b:	53                   	push   %ebx
8010593c:	6a 01                	push   $0x1
8010593e:	e8 2d fc ff ff       	call   80105570 <argptr>
80105943:	83 c4 10             	add    $0x10,%esp
80105946:	85 c0                	test   %eax,%eax
80105948:	78 1e                	js     80105968 <sys_read+0x78>
  return fileread(f, p, n);
8010594a:	83 ec 04             	sub    $0x4,%esp
8010594d:	ff 75 f0             	push   -0x10(%ebp)
80105950:	ff 75 f4             	push   -0xc(%ebp)
80105953:	56                   	push   %esi
80105954:	e8 37 b7 ff ff       	call   80101090 <fileread>
80105959:	83 c4 10             	add    $0x10,%esp
}
8010595c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010595f:	5b                   	pop    %ebx
80105960:	5e                   	pop    %esi
80105961:	5d                   	pop    %ebp
80105962:	c3                   	ret    
80105963:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105967:	90                   	nop
    return -1;
80105968:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010596d:	eb ed                	jmp    8010595c <sys_read+0x6c>
8010596f:	90                   	nop

80105970 <sys_write>:
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
80105973:	56                   	push   %esi
80105974:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105975:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105978:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010597b:	53                   	push   %ebx
8010597c:	6a 00                	push   $0x0
8010597e:	e8 9d fb ff ff       	call   80105520 <argint>
80105983:	83 c4 10             	add    $0x10,%esp
80105986:	85 c0                	test   %eax,%eax
80105988:	78 5e                	js     801059e8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010598a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010598e:	77 58                	ja     801059e8 <sys_write+0x78>
80105990:	e8 9b e0 ff ff       	call   80103a30 <myproc>
80105995:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105998:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010599c:	85 f6                	test   %esi,%esi
8010599e:	74 48                	je     801059e8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801059a0:	83 ec 08             	sub    $0x8,%esp
801059a3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059a6:	50                   	push   %eax
801059a7:	6a 02                	push   $0x2
801059a9:	e8 72 fb ff ff       	call   80105520 <argint>
801059ae:	83 c4 10             	add    $0x10,%esp
801059b1:	85 c0                	test   %eax,%eax
801059b3:	78 33                	js     801059e8 <sys_write+0x78>
801059b5:	83 ec 04             	sub    $0x4,%esp
801059b8:	ff 75 f0             	push   -0x10(%ebp)
801059bb:	53                   	push   %ebx
801059bc:	6a 01                	push   $0x1
801059be:	e8 ad fb ff ff       	call   80105570 <argptr>
801059c3:	83 c4 10             	add    $0x10,%esp
801059c6:	85 c0                	test   %eax,%eax
801059c8:	78 1e                	js     801059e8 <sys_write+0x78>
  return filewrite(f, p, n);
801059ca:	83 ec 04             	sub    $0x4,%esp
801059cd:	ff 75 f0             	push   -0x10(%ebp)
801059d0:	ff 75 f4             	push   -0xc(%ebp)
801059d3:	56                   	push   %esi
801059d4:	e8 47 b7 ff ff       	call   80101120 <filewrite>
801059d9:	83 c4 10             	add    $0x10,%esp
}
801059dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801059df:	5b                   	pop    %ebx
801059e0:	5e                   	pop    %esi
801059e1:	5d                   	pop    %ebp
801059e2:	c3                   	ret    
801059e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059e7:	90                   	nop
    return -1;
801059e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059ed:	eb ed                	jmp    801059dc <sys_write+0x6c>
801059ef:	90                   	nop

801059f0 <sys_close>:
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	56                   	push   %esi
801059f4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801059f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801059f8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801059fb:	50                   	push   %eax
801059fc:	6a 00                	push   $0x0
801059fe:	e8 1d fb ff ff       	call   80105520 <argint>
80105a03:	83 c4 10             	add    $0x10,%esp
80105a06:	85 c0                	test   %eax,%eax
80105a08:	78 3e                	js     80105a48 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105a0a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105a0e:	77 38                	ja     80105a48 <sys_close+0x58>
80105a10:	e8 1b e0 ff ff       	call   80103a30 <myproc>
80105a15:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a18:	8d 5a 08             	lea    0x8(%edx),%ebx
80105a1b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80105a1f:	85 f6                	test   %esi,%esi
80105a21:	74 25                	je     80105a48 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105a23:	e8 08 e0 ff ff       	call   80103a30 <myproc>
  fileclose(f);
80105a28:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105a2b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105a32:	00 
  fileclose(f);
80105a33:	56                   	push   %esi
80105a34:	e8 27 b5 ff ff       	call   80100f60 <fileclose>
  return 0;
80105a39:	83 c4 10             	add    $0x10,%esp
80105a3c:	31 c0                	xor    %eax,%eax
}
80105a3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105a41:	5b                   	pop    %ebx
80105a42:	5e                   	pop    %esi
80105a43:	5d                   	pop    %ebp
80105a44:	c3                   	ret    
80105a45:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105a48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a4d:	eb ef                	jmp    80105a3e <sys_close+0x4e>
80105a4f:	90                   	nop

80105a50 <sys_fstat>:
{
80105a50:	55                   	push   %ebp
80105a51:	89 e5                	mov    %esp,%ebp
80105a53:	56                   	push   %esi
80105a54:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105a55:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105a58:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105a5b:	53                   	push   %ebx
80105a5c:	6a 00                	push   $0x0
80105a5e:	e8 bd fa ff ff       	call   80105520 <argint>
80105a63:	83 c4 10             	add    $0x10,%esp
80105a66:	85 c0                	test   %eax,%eax
80105a68:	78 46                	js     80105ab0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105a6a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105a6e:	77 40                	ja     80105ab0 <sys_fstat+0x60>
80105a70:	e8 bb df ff ff       	call   80103a30 <myproc>
80105a75:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a78:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80105a7c:	85 f6                	test   %esi,%esi
80105a7e:	74 30                	je     80105ab0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105a80:	83 ec 04             	sub    $0x4,%esp
80105a83:	6a 14                	push   $0x14
80105a85:	53                   	push   %ebx
80105a86:	6a 01                	push   $0x1
80105a88:	e8 e3 fa ff ff       	call   80105570 <argptr>
80105a8d:	83 c4 10             	add    $0x10,%esp
80105a90:	85 c0                	test   %eax,%eax
80105a92:	78 1c                	js     80105ab0 <sys_fstat+0x60>
  return filestat(f, st);
80105a94:	83 ec 08             	sub    $0x8,%esp
80105a97:	ff 75 f4             	push   -0xc(%ebp)
80105a9a:	56                   	push   %esi
80105a9b:	e8 a0 b5 ff ff       	call   80101040 <filestat>
80105aa0:	83 c4 10             	add    $0x10,%esp
}
80105aa3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105aa6:	5b                   	pop    %ebx
80105aa7:	5e                   	pop    %esi
80105aa8:	5d                   	pop    %ebp
80105aa9:	c3                   	ret    
80105aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105ab0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ab5:	eb ec                	jmp    80105aa3 <sys_fstat+0x53>
80105ab7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105abe:	66 90                	xchg   %ax,%ax

80105ac0 <sys_link>:
{
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
80105ac3:	57                   	push   %edi
80105ac4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105ac5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105ac8:	53                   	push   %ebx
80105ac9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105acc:	50                   	push   %eax
80105acd:	6a 00                	push   $0x0
80105acf:	e8 0c fb ff ff       	call   801055e0 <argstr>
80105ad4:	83 c4 10             	add    $0x10,%esp
80105ad7:	85 c0                	test   %eax,%eax
80105ad9:	0f 88 fb 00 00 00    	js     80105bda <sys_link+0x11a>
80105adf:	83 ec 08             	sub    $0x8,%esp
80105ae2:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105ae5:	50                   	push   %eax
80105ae6:	6a 01                	push   $0x1
80105ae8:	e8 f3 fa ff ff       	call   801055e0 <argstr>
80105aed:	83 c4 10             	add    $0x10,%esp
80105af0:	85 c0                	test   %eax,%eax
80105af2:	0f 88 e2 00 00 00    	js     80105bda <sys_link+0x11a>
  begin_op();
80105af8:	e8 d3 d2 ff ff       	call   80102dd0 <begin_op>
  if((ip = namei(old)) == 0){
80105afd:	83 ec 0c             	sub    $0xc,%esp
80105b00:	ff 75 d4             	push   -0x2c(%ebp)
80105b03:	e8 08 c6 ff ff       	call   80102110 <namei>
80105b08:	83 c4 10             	add    $0x10,%esp
80105b0b:	89 c3                	mov    %eax,%ebx
80105b0d:	85 c0                	test   %eax,%eax
80105b0f:	0f 84 e4 00 00 00    	je     80105bf9 <sys_link+0x139>
  ilock(ip);
80105b15:	83 ec 0c             	sub    $0xc,%esp
80105b18:	50                   	push   %eax
80105b19:	e8 d2 bc ff ff       	call   801017f0 <ilock>
  if(ip->type == T_DIR){
80105b1e:	83 c4 10             	add    $0x10,%esp
80105b21:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105b26:	0f 84 b5 00 00 00    	je     80105be1 <sys_link+0x121>
  iupdate(ip);
80105b2c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105b2f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105b34:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105b37:	53                   	push   %ebx
80105b38:	e8 03 bc ff ff       	call   80101740 <iupdate>
  iunlock(ip);
80105b3d:	89 1c 24             	mov    %ebx,(%esp)
80105b40:	e8 8b bd ff ff       	call   801018d0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105b45:	58                   	pop    %eax
80105b46:	5a                   	pop    %edx
80105b47:	57                   	push   %edi
80105b48:	ff 75 d0             	push   -0x30(%ebp)
80105b4b:	e8 e0 c5 ff ff       	call   80102130 <nameiparent>
80105b50:	83 c4 10             	add    $0x10,%esp
80105b53:	89 c6                	mov    %eax,%esi
80105b55:	85 c0                	test   %eax,%eax
80105b57:	74 5b                	je     80105bb4 <sys_link+0xf4>
  ilock(dp);
80105b59:	83 ec 0c             	sub    $0xc,%esp
80105b5c:	50                   	push   %eax
80105b5d:	e8 8e bc ff ff       	call   801017f0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105b62:	8b 03                	mov    (%ebx),%eax
80105b64:	83 c4 10             	add    $0x10,%esp
80105b67:	39 06                	cmp    %eax,(%esi)
80105b69:	75 3d                	jne    80105ba8 <sys_link+0xe8>
80105b6b:	83 ec 04             	sub    $0x4,%esp
80105b6e:	ff 73 04             	push   0x4(%ebx)
80105b71:	57                   	push   %edi
80105b72:	56                   	push   %esi
80105b73:	e8 d8 c4 ff ff       	call   80102050 <dirlink>
80105b78:	83 c4 10             	add    $0x10,%esp
80105b7b:	85 c0                	test   %eax,%eax
80105b7d:	78 29                	js     80105ba8 <sys_link+0xe8>
  iunlockput(dp);
80105b7f:	83 ec 0c             	sub    $0xc,%esp
80105b82:	56                   	push   %esi
80105b83:	e8 f8 be ff ff       	call   80101a80 <iunlockput>
  iput(ip);
80105b88:	89 1c 24             	mov    %ebx,(%esp)
80105b8b:	e8 90 bd ff ff       	call   80101920 <iput>
  end_op();
80105b90:	e8 ab d2 ff ff       	call   80102e40 <end_op>
  return 0;
80105b95:	83 c4 10             	add    $0x10,%esp
80105b98:	31 c0                	xor    %eax,%eax
}
80105b9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b9d:	5b                   	pop    %ebx
80105b9e:	5e                   	pop    %esi
80105b9f:	5f                   	pop    %edi
80105ba0:	5d                   	pop    %ebp
80105ba1:	c3                   	ret    
80105ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105ba8:	83 ec 0c             	sub    $0xc,%esp
80105bab:	56                   	push   %esi
80105bac:	e8 cf be ff ff       	call   80101a80 <iunlockput>
    goto bad;
80105bb1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105bb4:	83 ec 0c             	sub    $0xc,%esp
80105bb7:	53                   	push   %ebx
80105bb8:	e8 33 bc ff ff       	call   801017f0 <ilock>
  ip->nlink--;
80105bbd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105bc2:	89 1c 24             	mov    %ebx,(%esp)
80105bc5:	e8 76 bb ff ff       	call   80101740 <iupdate>
  iunlockput(ip);
80105bca:	89 1c 24             	mov    %ebx,(%esp)
80105bcd:	e8 ae be ff ff       	call   80101a80 <iunlockput>
  end_op();
80105bd2:	e8 69 d2 ff ff       	call   80102e40 <end_op>
  return -1;
80105bd7:	83 c4 10             	add    $0x10,%esp
80105bda:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bdf:	eb b9                	jmp    80105b9a <sys_link+0xda>
    iunlockput(ip);
80105be1:	83 ec 0c             	sub    $0xc,%esp
80105be4:	53                   	push   %ebx
80105be5:	e8 96 be ff ff       	call   80101a80 <iunlockput>
    end_op();
80105bea:	e8 51 d2 ff ff       	call   80102e40 <end_op>
    return -1;
80105bef:	83 c4 10             	add    $0x10,%esp
80105bf2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bf7:	eb a1                	jmp    80105b9a <sys_link+0xda>
    end_op();
80105bf9:	e8 42 d2 ff ff       	call   80102e40 <end_op>
    return -1;
80105bfe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c03:	eb 95                	jmp    80105b9a <sys_link+0xda>
80105c05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c10 <sys_unlink>:
{
80105c10:	55                   	push   %ebp
80105c11:	89 e5                	mov    %esp,%ebp
80105c13:	57                   	push   %edi
80105c14:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105c15:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105c18:	53                   	push   %ebx
80105c19:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105c1c:	50                   	push   %eax
80105c1d:	6a 00                	push   $0x0
80105c1f:	e8 bc f9 ff ff       	call   801055e0 <argstr>
80105c24:	83 c4 10             	add    $0x10,%esp
80105c27:	85 c0                	test   %eax,%eax
80105c29:	0f 88 7a 01 00 00    	js     80105da9 <sys_unlink+0x199>
  begin_op();
80105c2f:	e8 9c d1 ff ff       	call   80102dd0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105c34:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105c37:	83 ec 08             	sub    $0x8,%esp
80105c3a:	53                   	push   %ebx
80105c3b:	ff 75 c0             	push   -0x40(%ebp)
80105c3e:	e8 ed c4 ff ff       	call   80102130 <nameiparent>
80105c43:	83 c4 10             	add    $0x10,%esp
80105c46:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105c49:	85 c0                	test   %eax,%eax
80105c4b:	0f 84 62 01 00 00    	je     80105db3 <sys_unlink+0x1a3>
  ilock(dp);
80105c51:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105c54:	83 ec 0c             	sub    $0xc,%esp
80105c57:	57                   	push   %edi
80105c58:	e8 93 bb ff ff       	call   801017f0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105c5d:	58                   	pop    %eax
80105c5e:	5a                   	pop    %edx
80105c5f:	68 00 87 10 80       	push   $0x80108700
80105c64:	53                   	push   %ebx
80105c65:	e8 c6 c0 ff ff       	call   80101d30 <namecmp>
80105c6a:	83 c4 10             	add    $0x10,%esp
80105c6d:	85 c0                	test   %eax,%eax
80105c6f:	0f 84 fb 00 00 00    	je     80105d70 <sys_unlink+0x160>
80105c75:	83 ec 08             	sub    $0x8,%esp
80105c78:	68 ff 86 10 80       	push   $0x801086ff
80105c7d:	53                   	push   %ebx
80105c7e:	e8 ad c0 ff ff       	call   80101d30 <namecmp>
80105c83:	83 c4 10             	add    $0x10,%esp
80105c86:	85 c0                	test   %eax,%eax
80105c88:	0f 84 e2 00 00 00    	je     80105d70 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
80105c8e:	83 ec 04             	sub    $0x4,%esp
80105c91:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105c94:	50                   	push   %eax
80105c95:	53                   	push   %ebx
80105c96:	57                   	push   %edi
80105c97:	e8 b4 c0 ff ff       	call   80101d50 <dirlookup>
80105c9c:	83 c4 10             	add    $0x10,%esp
80105c9f:	89 c3                	mov    %eax,%ebx
80105ca1:	85 c0                	test   %eax,%eax
80105ca3:	0f 84 c7 00 00 00    	je     80105d70 <sys_unlink+0x160>
  ilock(ip);
80105ca9:	83 ec 0c             	sub    $0xc,%esp
80105cac:	50                   	push   %eax
80105cad:	e8 3e bb ff ff       	call   801017f0 <ilock>
  if(ip->nlink < 1)
80105cb2:	83 c4 10             	add    $0x10,%esp
80105cb5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105cba:	0f 8e 1c 01 00 00    	jle    80105ddc <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105cc0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105cc5:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105cc8:	74 66                	je     80105d30 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105cca:	83 ec 04             	sub    $0x4,%esp
80105ccd:	6a 10                	push   $0x10
80105ccf:	6a 00                	push   $0x0
80105cd1:	57                   	push   %edi
80105cd2:	e8 89 f5 ff ff       	call   80105260 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105cd7:	6a 10                	push   $0x10
80105cd9:	ff 75 c4             	push   -0x3c(%ebp)
80105cdc:	57                   	push   %edi
80105cdd:	ff 75 b4             	push   -0x4c(%ebp)
80105ce0:	e8 1b bf ff ff       	call   80101c00 <writei>
80105ce5:	83 c4 20             	add    $0x20,%esp
80105ce8:	83 f8 10             	cmp    $0x10,%eax
80105ceb:	0f 85 de 00 00 00    	jne    80105dcf <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105cf1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105cf6:	0f 84 94 00 00 00    	je     80105d90 <sys_unlink+0x180>
  iunlockput(dp);
80105cfc:	83 ec 0c             	sub    $0xc,%esp
80105cff:	ff 75 b4             	push   -0x4c(%ebp)
80105d02:	e8 79 bd ff ff       	call   80101a80 <iunlockput>
  ip->nlink--;
80105d07:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105d0c:	89 1c 24             	mov    %ebx,(%esp)
80105d0f:	e8 2c ba ff ff       	call   80101740 <iupdate>
  iunlockput(ip);
80105d14:	89 1c 24             	mov    %ebx,(%esp)
80105d17:	e8 64 bd ff ff       	call   80101a80 <iunlockput>
  end_op();
80105d1c:	e8 1f d1 ff ff       	call   80102e40 <end_op>
  return 0;
80105d21:	83 c4 10             	add    $0x10,%esp
80105d24:	31 c0                	xor    %eax,%eax
}
80105d26:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d29:	5b                   	pop    %ebx
80105d2a:	5e                   	pop    %esi
80105d2b:	5f                   	pop    %edi
80105d2c:	5d                   	pop    %ebp
80105d2d:	c3                   	ret    
80105d2e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105d30:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105d34:	76 94                	jbe    80105cca <sys_unlink+0xba>
80105d36:	be 20 00 00 00       	mov    $0x20,%esi
80105d3b:	eb 0b                	jmp    80105d48 <sys_unlink+0x138>
80105d3d:	8d 76 00             	lea    0x0(%esi),%esi
80105d40:	83 c6 10             	add    $0x10,%esi
80105d43:	3b 73 58             	cmp    0x58(%ebx),%esi
80105d46:	73 82                	jae    80105cca <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105d48:	6a 10                	push   $0x10
80105d4a:	56                   	push   %esi
80105d4b:	57                   	push   %edi
80105d4c:	53                   	push   %ebx
80105d4d:	e8 ae bd ff ff       	call   80101b00 <readi>
80105d52:	83 c4 10             	add    $0x10,%esp
80105d55:	83 f8 10             	cmp    $0x10,%eax
80105d58:	75 68                	jne    80105dc2 <sys_unlink+0x1b2>
    if(de.inum != 0)
80105d5a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105d5f:	74 df                	je     80105d40 <sys_unlink+0x130>
    iunlockput(ip);
80105d61:	83 ec 0c             	sub    $0xc,%esp
80105d64:	53                   	push   %ebx
80105d65:	e8 16 bd ff ff       	call   80101a80 <iunlockput>
    goto bad;
80105d6a:	83 c4 10             	add    $0x10,%esp
80105d6d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105d70:	83 ec 0c             	sub    $0xc,%esp
80105d73:	ff 75 b4             	push   -0x4c(%ebp)
80105d76:	e8 05 bd ff ff       	call   80101a80 <iunlockput>
  end_op();
80105d7b:	e8 c0 d0 ff ff       	call   80102e40 <end_op>
  return -1;
80105d80:	83 c4 10             	add    $0x10,%esp
80105d83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d88:	eb 9c                	jmp    80105d26 <sys_unlink+0x116>
80105d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105d90:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105d93:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105d96:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105d9b:	50                   	push   %eax
80105d9c:	e8 9f b9 ff ff       	call   80101740 <iupdate>
80105da1:	83 c4 10             	add    $0x10,%esp
80105da4:	e9 53 ff ff ff       	jmp    80105cfc <sys_unlink+0xec>
    return -1;
80105da9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dae:	e9 73 ff ff ff       	jmp    80105d26 <sys_unlink+0x116>
    end_op();
80105db3:	e8 88 d0 ff ff       	call   80102e40 <end_op>
    return -1;
80105db8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dbd:	e9 64 ff ff ff       	jmp    80105d26 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105dc2:	83 ec 0c             	sub    $0xc,%esp
80105dc5:	68 24 87 10 80       	push   $0x80108724
80105dca:	e8 b1 a5 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
80105dcf:	83 ec 0c             	sub    $0xc,%esp
80105dd2:	68 36 87 10 80       	push   $0x80108736
80105dd7:	e8 a4 a5 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
80105ddc:	83 ec 0c             	sub    $0xc,%esp
80105ddf:	68 12 87 10 80       	push   $0x80108712
80105de4:	e8 97 a5 ff ff       	call   80100380 <panic>
80105de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105df0 <sys_open>:

int
sys_open(void)
{
80105df0:	55                   	push   %ebp
80105df1:	89 e5                	mov    %esp,%ebp
80105df3:	57                   	push   %edi
80105df4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105df5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105df8:	53                   	push   %ebx
80105df9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105dfc:	50                   	push   %eax
80105dfd:	6a 00                	push   $0x0
80105dff:	e8 dc f7 ff ff       	call   801055e0 <argstr>
80105e04:	83 c4 10             	add    $0x10,%esp
80105e07:	85 c0                	test   %eax,%eax
80105e09:	0f 88 8e 00 00 00    	js     80105e9d <sys_open+0xad>
80105e0f:	83 ec 08             	sub    $0x8,%esp
80105e12:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e15:	50                   	push   %eax
80105e16:	6a 01                	push   $0x1
80105e18:	e8 03 f7 ff ff       	call   80105520 <argint>
80105e1d:	83 c4 10             	add    $0x10,%esp
80105e20:	85 c0                	test   %eax,%eax
80105e22:	78 79                	js     80105e9d <sys_open+0xad>
    return -1;

  begin_op();
80105e24:	e8 a7 cf ff ff       	call   80102dd0 <begin_op>

  if(omode & O_CREATE){
80105e29:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105e2d:	75 79                	jne    80105ea8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105e2f:	83 ec 0c             	sub    $0xc,%esp
80105e32:	ff 75 e0             	push   -0x20(%ebp)
80105e35:	e8 d6 c2 ff ff       	call   80102110 <namei>
80105e3a:	83 c4 10             	add    $0x10,%esp
80105e3d:	89 c6                	mov    %eax,%esi
80105e3f:	85 c0                	test   %eax,%eax
80105e41:	0f 84 7e 00 00 00    	je     80105ec5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105e47:	83 ec 0c             	sub    $0xc,%esp
80105e4a:	50                   	push   %eax
80105e4b:	e8 a0 b9 ff ff       	call   801017f0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105e50:	83 c4 10             	add    $0x10,%esp
80105e53:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105e58:	0f 84 c2 00 00 00    	je     80105f20 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105e5e:	e8 3d b0 ff ff       	call   80100ea0 <filealloc>
80105e63:	89 c7                	mov    %eax,%edi
80105e65:	85 c0                	test   %eax,%eax
80105e67:	74 23                	je     80105e8c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105e69:	e8 c2 db ff ff       	call   80103a30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105e6e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105e70:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105e74:	85 d2                	test   %edx,%edx
80105e76:	74 60                	je     80105ed8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105e78:	83 c3 01             	add    $0x1,%ebx
80105e7b:	83 fb 10             	cmp    $0x10,%ebx
80105e7e:	75 f0                	jne    80105e70 <sys_open+0x80>
    if(f)
      fileclose(f);
80105e80:	83 ec 0c             	sub    $0xc,%esp
80105e83:	57                   	push   %edi
80105e84:	e8 d7 b0 ff ff       	call   80100f60 <fileclose>
80105e89:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105e8c:	83 ec 0c             	sub    $0xc,%esp
80105e8f:	56                   	push   %esi
80105e90:	e8 eb bb ff ff       	call   80101a80 <iunlockput>
    end_op();
80105e95:	e8 a6 cf ff ff       	call   80102e40 <end_op>
    return -1;
80105e9a:	83 c4 10             	add    $0x10,%esp
80105e9d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105ea2:	eb 6d                	jmp    80105f11 <sys_open+0x121>
80105ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105ea8:	83 ec 0c             	sub    $0xc,%esp
80105eab:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105eae:	31 c9                	xor    %ecx,%ecx
80105eb0:	ba 02 00 00 00       	mov    $0x2,%edx
80105eb5:	6a 00                	push   $0x0
80105eb7:	e8 14 f8 ff ff       	call   801056d0 <create>
    if(ip == 0){
80105ebc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105ebf:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105ec1:	85 c0                	test   %eax,%eax
80105ec3:	75 99                	jne    80105e5e <sys_open+0x6e>
      end_op();
80105ec5:	e8 76 cf ff ff       	call   80102e40 <end_op>
      return -1;
80105eca:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105ecf:	eb 40                	jmp    80105f11 <sys_open+0x121>
80105ed1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105ed8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105edb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105edf:	56                   	push   %esi
80105ee0:	e8 eb b9 ff ff       	call   801018d0 <iunlock>
  end_op();
80105ee5:	e8 56 cf ff ff       	call   80102e40 <end_op>

  f->type = FD_INODE;
80105eea:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105ef0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ef3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105ef6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105ef9:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105efb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105f02:	f7 d0                	not    %eax
80105f04:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105f07:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105f0a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105f0d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105f11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f14:	89 d8                	mov    %ebx,%eax
80105f16:	5b                   	pop    %ebx
80105f17:	5e                   	pop    %esi
80105f18:	5f                   	pop    %edi
80105f19:	5d                   	pop    %ebp
80105f1a:	c3                   	ret    
80105f1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f1f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105f20:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105f23:	85 c9                	test   %ecx,%ecx
80105f25:	0f 84 33 ff ff ff    	je     80105e5e <sys_open+0x6e>
80105f2b:	e9 5c ff ff ff       	jmp    80105e8c <sys_open+0x9c>

80105f30 <sys_mkdir>:

int
sys_mkdir(void)
{
80105f30:	55                   	push   %ebp
80105f31:	89 e5                	mov    %esp,%ebp
80105f33:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105f36:	e8 95 ce ff ff       	call   80102dd0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105f3b:	83 ec 08             	sub    $0x8,%esp
80105f3e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f41:	50                   	push   %eax
80105f42:	6a 00                	push   $0x0
80105f44:	e8 97 f6 ff ff       	call   801055e0 <argstr>
80105f49:	83 c4 10             	add    $0x10,%esp
80105f4c:	85 c0                	test   %eax,%eax
80105f4e:	78 30                	js     80105f80 <sys_mkdir+0x50>
80105f50:	83 ec 0c             	sub    $0xc,%esp
80105f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f56:	31 c9                	xor    %ecx,%ecx
80105f58:	ba 01 00 00 00       	mov    $0x1,%edx
80105f5d:	6a 00                	push   $0x0
80105f5f:	e8 6c f7 ff ff       	call   801056d0 <create>
80105f64:	83 c4 10             	add    $0x10,%esp
80105f67:	85 c0                	test   %eax,%eax
80105f69:	74 15                	je     80105f80 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105f6b:	83 ec 0c             	sub    $0xc,%esp
80105f6e:	50                   	push   %eax
80105f6f:	e8 0c bb ff ff       	call   80101a80 <iunlockput>
  end_op();
80105f74:	e8 c7 ce ff ff       	call   80102e40 <end_op>
  return 0;
80105f79:	83 c4 10             	add    $0x10,%esp
80105f7c:	31 c0                	xor    %eax,%eax
}
80105f7e:	c9                   	leave  
80105f7f:	c3                   	ret    
    end_op();
80105f80:	e8 bb ce ff ff       	call   80102e40 <end_op>
    return -1;
80105f85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f8a:	c9                   	leave  
80105f8b:	c3                   	ret    
80105f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f90 <sys_mknod>:

int
sys_mknod(void)
{
80105f90:	55                   	push   %ebp
80105f91:	89 e5                	mov    %esp,%ebp
80105f93:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105f96:	e8 35 ce ff ff       	call   80102dd0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105f9b:	83 ec 08             	sub    $0x8,%esp
80105f9e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105fa1:	50                   	push   %eax
80105fa2:	6a 00                	push   $0x0
80105fa4:	e8 37 f6 ff ff       	call   801055e0 <argstr>
80105fa9:	83 c4 10             	add    $0x10,%esp
80105fac:	85 c0                	test   %eax,%eax
80105fae:	78 60                	js     80106010 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105fb0:	83 ec 08             	sub    $0x8,%esp
80105fb3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105fb6:	50                   	push   %eax
80105fb7:	6a 01                	push   $0x1
80105fb9:	e8 62 f5 ff ff       	call   80105520 <argint>
  if((argstr(0, &path)) < 0 ||
80105fbe:	83 c4 10             	add    $0x10,%esp
80105fc1:	85 c0                	test   %eax,%eax
80105fc3:	78 4b                	js     80106010 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105fc5:	83 ec 08             	sub    $0x8,%esp
80105fc8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fcb:	50                   	push   %eax
80105fcc:	6a 02                	push   $0x2
80105fce:	e8 4d f5 ff ff       	call   80105520 <argint>
     argint(1, &major) < 0 ||
80105fd3:	83 c4 10             	add    $0x10,%esp
80105fd6:	85 c0                	test   %eax,%eax
80105fd8:	78 36                	js     80106010 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105fda:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105fde:	83 ec 0c             	sub    $0xc,%esp
80105fe1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105fe5:	ba 03 00 00 00       	mov    $0x3,%edx
80105fea:	50                   	push   %eax
80105feb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105fee:	e8 dd f6 ff ff       	call   801056d0 <create>
     argint(2, &minor) < 0 ||
80105ff3:	83 c4 10             	add    $0x10,%esp
80105ff6:	85 c0                	test   %eax,%eax
80105ff8:	74 16                	je     80106010 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105ffa:	83 ec 0c             	sub    $0xc,%esp
80105ffd:	50                   	push   %eax
80105ffe:	e8 7d ba ff ff       	call   80101a80 <iunlockput>
  end_op();
80106003:	e8 38 ce ff ff       	call   80102e40 <end_op>
  return 0;
80106008:	83 c4 10             	add    $0x10,%esp
8010600b:	31 c0                	xor    %eax,%eax
}
8010600d:	c9                   	leave  
8010600e:	c3                   	ret    
8010600f:	90                   	nop
    end_op();
80106010:	e8 2b ce ff ff       	call   80102e40 <end_op>
    return -1;
80106015:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010601a:	c9                   	leave  
8010601b:	c3                   	ret    
8010601c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106020 <sys_chdir>:

int
sys_chdir(void)
{
80106020:	55                   	push   %ebp
80106021:	89 e5                	mov    %esp,%ebp
80106023:	56                   	push   %esi
80106024:	53                   	push   %ebx
80106025:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80106028:	e8 03 da ff ff       	call   80103a30 <myproc>
8010602d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010602f:	e8 9c cd ff ff       	call   80102dd0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106034:	83 ec 08             	sub    $0x8,%esp
80106037:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010603a:	50                   	push   %eax
8010603b:	6a 00                	push   $0x0
8010603d:	e8 9e f5 ff ff       	call   801055e0 <argstr>
80106042:	83 c4 10             	add    $0x10,%esp
80106045:	85 c0                	test   %eax,%eax
80106047:	78 77                	js     801060c0 <sys_chdir+0xa0>
80106049:	83 ec 0c             	sub    $0xc,%esp
8010604c:	ff 75 f4             	push   -0xc(%ebp)
8010604f:	e8 bc c0 ff ff       	call   80102110 <namei>
80106054:	83 c4 10             	add    $0x10,%esp
80106057:	89 c3                	mov    %eax,%ebx
80106059:	85 c0                	test   %eax,%eax
8010605b:	74 63                	je     801060c0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010605d:	83 ec 0c             	sub    $0xc,%esp
80106060:	50                   	push   %eax
80106061:	e8 8a b7 ff ff       	call   801017f0 <ilock>
  if(ip->type != T_DIR){
80106066:	83 c4 10             	add    $0x10,%esp
80106069:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010606e:	75 30                	jne    801060a0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106070:	83 ec 0c             	sub    $0xc,%esp
80106073:	53                   	push   %ebx
80106074:	e8 57 b8 ff ff       	call   801018d0 <iunlock>
  iput(curproc->cwd);
80106079:	58                   	pop    %eax
8010607a:	ff 76 68             	push   0x68(%esi)
8010607d:	e8 9e b8 ff ff       	call   80101920 <iput>
  end_op();
80106082:	e8 b9 cd ff ff       	call   80102e40 <end_op>
  curproc->cwd = ip;
80106087:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010608a:	83 c4 10             	add    $0x10,%esp
8010608d:	31 c0                	xor    %eax,%eax
}
8010608f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106092:	5b                   	pop    %ebx
80106093:	5e                   	pop    %esi
80106094:	5d                   	pop    %ebp
80106095:	c3                   	ret    
80106096:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010609d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801060a0:	83 ec 0c             	sub    $0xc,%esp
801060a3:	53                   	push   %ebx
801060a4:	e8 d7 b9 ff ff       	call   80101a80 <iunlockput>
    end_op();
801060a9:	e8 92 cd ff ff       	call   80102e40 <end_op>
    return -1;
801060ae:	83 c4 10             	add    $0x10,%esp
801060b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060b6:	eb d7                	jmp    8010608f <sys_chdir+0x6f>
801060b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060bf:	90                   	nop
    end_op();
801060c0:	e8 7b cd ff ff       	call   80102e40 <end_op>
    return -1;
801060c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060ca:	eb c3                	jmp    8010608f <sys_chdir+0x6f>
801060cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801060d0 <sys_exec>:

int
sys_exec(void)
{
801060d0:	55                   	push   %ebp
801060d1:	89 e5                	mov    %esp,%ebp
801060d3:	57                   	push   %edi
801060d4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801060d5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801060db:	53                   	push   %ebx
801060dc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801060e2:	50                   	push   %eax
801060e3:	6a 00                	push   $0x0
801060e5:	e8 f6 f4 ff ff       	call   801055e0 <argstr>
801060ea:	83 c4 10             	add    $0x10,%esp
801060ed:	85 c0                	test   %eax,%eax
801060ef:	0f 88 87 00 00 00    	js     8010617c <sys_exec+0xac>
801060f5:	83 ec 08             	sub    $0x8,%esp
801060f8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801060fe:	50                   	push   %eax
801060ff:	6a 01                	push   $0x1
80106101:	e8 1a f4 ff ff       	call   80105520 <argint>
80106106:	83 c4 10             	add    $0x10,%esp
80106109:	85 c0                	test   %eax,%eax
8010610b:	78 6f                	js     8010617c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010610d:	83 ec 04             	sub    $0x4,%esp
80106110:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80106116:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80106118:	68 80 00 00 00       	push   $0x80
8010611d:	6a 00                	push   $0x0
8010611f:	56                   	push   %esi
80106120:	e8 3b f1 ff ff       	call   80105260 <memset>
80106125:	83 c4 10             	add    $0x10,%esp
80106128:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010612f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106130:	83 ec 08             	sub    $0x8,%esp
80106133:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80106139:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80106140:	50                   	push   %eax
80106141:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106147:	01 f8                	add    %edi,%eax
80106149:	50                   	push   %eax
8010614a:	e8 41 f3 ff ff       	call   80105490 <fetchint>
8010614f:	83 c4 10             	add    $0x10,%esp
80106152:	85 c0                	test   %eax,%eax
80106154:	78 26                	js     8010617c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80106156:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010615c:	85 c0                	test   %eax,%eax
8010615e:	74 30                	je     80106190 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106160:	83 ec 08             	sub    $0x8,%esp
80106163:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80106166:	52                   	push   %edx
80106167:	50                   	push   %eax
80106168:	e8 63 f3 ff ff       	call   801054d0 <fetchstr>
8010616d:	83 c4 10             	add    $0x10,%esp
80106170:	85 c0                	test   %eax,%eax
80106172:	78 08                	js     8010617c <sys_exec+0xac>
  for(i=0;; i++){
80106174:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80106177:	83 fb 20             	cmp    $0x20,%ebx
8010617a:	75 b4                	jne    80106130 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010617c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010617f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106184:	5b                   	pop    %ebx
80106185:	5e                   	pop    %esi
80106186:	5f                   	pop    %edi
80106187:	5d                   	pop    %ebp
80106188:	c3                   	ret    
80106189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80106190:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106197:	00 00 00 00 
  return exec(path, argv);
8010619b:	83 ec 08             	sub    $0x8,%esp
8010619e:	56                   	push   %esi
8010619f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801061a5:	e8 06 a9 ff ff       	call   80100ab0 <exec>
801061aa:	83 c4 10             	add    $0x10,%esp
}
801061ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061b0:	5b                   	pop    %ebx
801061b1:	5e                   	pop    %esi
801061b2:	5f                   	pop    %edi
801061b3:	5d                   	pop    %ebp
801061b4:	c3                   	ret    
801061b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801061c0 <sys_pipe>:

int
sys_pipe(void)
{
801061c0:	55                   	push   %ebp
801061c1:	89 e5                	mov    %esp,%ebp
801061c3:	57                   	push   %edi
801061c4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801061c5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801061c8:	53                   	push   %ebx
801061c9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801061cc:	6a 08                	push   $0x8
801061ce:	50                   	push   %eax
801061cf:	6a 00                	push   $0x0
801061d1:	e8 9a f3 ff ff       	call   80105570 <argptr>
801061d6:	83 c4 10             	add    $0x10,%esp
801061d9:	85 c0                	test   %eax,%eax
801061db:	78 4a                	js     80106227 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801061dd:	83 ec 08             	sub    $0x8,%esp
801061e0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801061e3:	50                   	push   %eax
801061e4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801061e7:	50                   	push   %eax
801061e8:	e8 b3 d2 ff ff       	call   801034a0 <pipealloc>
801061ed:	83 c4 10             	add    $0x10,%esp
801061f0:	85 c0                	test   %eax,%eax
801061f2:	78 33                	js     80106227 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801061f4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801061f7:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801061f9:	e8 32 d8 ff ff       	call   80103a30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801061fe:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80106200:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80106204:	85 f6                	test   %esi,%esi
80106206:	74 28                	je     80106230 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80106208:	83 c3 01             	add    $0x1,%ebx
8010620b:	83 fb 10             	cmp    $0x10,%ebx
8010620e:	75 f0                	jne    80106200 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80106210:	83 ec 0c             	sub    $0xc,%esp
80106213:	ff 75 e0             	push   -0x20(%ebp)
80106216:	e8 45 ad ff ff       	call   80100f60 <fileclose>
    fileclose(wf);
8010621b:	58                   	pop    %eax
8010621c:	ff 75 e4             	push   -0x1c(%ebp)
8010621f:	e8 3c ad ff ff       	call   80100f60 <fileclose>
    return -1;
80106224:	83 c4 10             	add    $0x10,%esp
80106227:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010622c:	eb 53                	jmp    80106281 <sys_pipe+0xc1>
8010622e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106230:	8d 73 08             	lea    0x8(%ebx),%esi
80106233:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106237:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010623a:	e8 f1 d7 ff ff       	call   80103a30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010623f:	31 d2                	xor    %edx,%edx
80106241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80106248:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010624c:	85 c9                	test   %ecx,%ecx
8010624e:	74 20                	je     80106270 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80106250:	83 c2 01             	add    $0x1,%edx
80106253:	83 fa 10             	cmp    $0x10,%edx
80106256:	75 f0                	jne    80106248 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80106258:	e8 d3 d7 ff ff       	call   80103a30 <myproc>
8010625d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106264:	00 
80106265:	eb a9                	jmp    80106210 <sys_pipe+0x50>
80106267:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010626e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106270:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80106274:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106277:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106279:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010627c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010627f:	31 c0                	xor    %eax,%eax
}
80106281:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106284:	5b                   	pop    %ebx
80106285:	5e                   	pop    %esi
80106286:	5f                   	pop    %edi
80106287:	5d                   	pop    %ebp
80106288:	c3                   	ret    
80106289:	66 90                	xchg   %ax,%ax
8010628b:	66 90                	xchg   %ax,%ax
8010628d:	66 90                	xchg   %ax,%ax
8010628f:	90                   	nop

80106290 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80106290:	e9 6b d9 ff ff       	jmp    80103c00 <fork>
80106295:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010629c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801062a0 <sys_exit>:
}

int
sys_exit(void)
{
801062a0:	55                   	push   %ebp
801062a1:	89 e5                	mov    %esp,%ebp
801062a3:	83 ec 08             	sub    $0x8,%esp
  exit();
801062a6:	e8 f5 dd ff ff       	call   801040a0 <exit>
  return 0;  // not reached
}
801062ab:	31 c0                	xor    %eax,%eax
801062ad:	c9                   	leave  
801062ae:	c3                   	ret    
801062af:	90                   	nop

801062b0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801062b0:	e9 6b df ff ff       	jmp    80104220 <wait>
801062b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801062c0 <sys_kill>:
}

int
sys_kill(void)
{
801062c0:	55                   	push   %ebp
801062c1:	89 e5                	mov    %esp,%ebp
801062c3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801062c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801062c9:	50                   	push   %eax
801062ca:	6a 00                	push   $0x0
801062cc:	e8 4f f2 ff ff       	call   80105520 <argint>
801062d1:	83 c4 10             	add    $0x10,%esp
801062d4:	85 c0                	test   %eax,%eax
801062d6:	78 18                	js     801062f0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801062d8:	83 ec 0c             	sub    $0xc,%esp
801062db:	ff 75 f4             	push   -0xc(%ebp)
801062de:	e8 4d e2 ff ff       	call   80104530 <kill>
801062e3:	83 c4 10             	add    $0x10,%esp
}
801062e6:	c9                   	leave  
801062e7:	c3                   	ret    
801062e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062ef:	90                   	nop
801062f0:	c9                   	leave  
    return -1;
801062f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062f6:	c3                   	ret    
801062f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062fe:	66 90                	xchg   %ax,%ax

80106300 <sys_getpid>:

int
sys_getpid(void)
{
80106300:	55                   	push   %ebp
80106301:	89 e5                	mov    %esp,%ebp
80106303:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106306:	e8 25 d7 ff ff       	call   80103a30 <myproc>
8010630b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010630e:	c9                   	leave  
8010630f:	c3                   	ret    

80106310 <sys_sbrk>:

int
sys_sbrk(void)
{
80106310:	55                   	push   %ebp
80106311:	89 e5                	mov    %esp,%ebp
80106313:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106314:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106317:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010631a:	50                   	push   %eax
8010631b:	6a 00                	push   $0x0
8010631d:	e8 fe f1 ff ff       	call   80105520 <argint>
80106322:	83 c4 10             	add    $0x10,%esp
80106325:	85 c0                	test   %eax,%eax
80106327:	78 27                	js     80106350 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106329:	e8 02 d7 ff ff       	call   80103a30 <myproc>
  if(growproc(n) < 0)
8010632e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106331:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106333:	ff 75 f4             	push   -0xc(%ebp)
80106336:	e8 45 d8 ff ff       	call   80103b80 <growproc>
8010633b:	83 c4 10             	add    $0x10,%esp
8010633e:	85 c0                	test   %eax,%eax
80106340:	78 0e                	js     80106350 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106342:	89 d8                	mov    %ebx,%eax
80106344:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106347:	c9                   	leave  
80106348:	c3                   	ret    
80106349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106350:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106355:	eb eb                	jmp    80106342 <sys_sbrk+0x32>
80106357:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010635e:	66 90                	xchg   %ax,%ax

80106360 <sys_sleep>:

int
sys_sleep(void)
{
80106360:	55                   	push   %ebp
80106361:	89 e5                	mov    %esp,%ebp
80106363:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106364:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106367:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010636a:	50                   	push   %eax
8010636b:	6a 00                	push   $0x0
8010636d:	e8 ae f1 ff ff       	call   80105520 <argint>
80106372:	83 c4 10             	add    $0x10,%esp
80106375:	85 c0                	test   %eax,%eax
80106377:	0f 88 8a 00 00 00    	js     80106407 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010637d:	83 ec 0c             	sub    $0xc,%esp
80106380:	68 a0 5b 11 80       	push   $0x80115ba0
80106385:	e8 16 ee ff ff       	call   801051a0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010638a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
8010638d:	8b 1d 80 5b 11 80    	mov    0x80115b80,%ebx
  while(ticks - ticks0 < n){
80106393:	83 c4 10             	add    $0x10,%esp
80106396:	85 d2                	test   %edx,%edx
80106398:	75 27                	jne    801063c1 <sys_sleep+0x61>
8010639a:	eb 54                	jmp    801063f0 <sys_sleep+0x90>
8010639c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801063a0:	83 ec 08             	sub    $0x8,%esp
801063a3:	68 a0 5b 11 80       	push   $0x80115ba0
801063a8:	68 80 5b 11 80       	push   $0x80115b80
801063ad:	e8 2e e0 ff ff       	call   801043e0 <sleep>
  while(ticks - ticks0 < n){
801063b2:	a1 80 5b 11 80       	mov    0x80115b80,%eax
801063b7:	83 c4 10             	add    $0x10,%esp
801063ba:	29 d8                	sub    %ebx,%eax
801063bc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801063bf:	73 2f                	jae    801063f0 <sys_sleep+0x90>
    if(myproc()->killed){
801063c1:	e8 6a d6 ff ff       	call   80103a30 <myproc>
801063c6:	8b 40 24             	mov    0x24(%eax),%eax
801063c9:	85 c0                	test   %eax,%eax
801063cb:	74 d3                	je     801063a0 <sys_sleep+0x40>
      release(&tickslock);
801063cd:	83 ec 0c             	sub    $0xc,%esp
801063d0:	68 a0 5b 11 80       	push   $0x80115ba0
801063d5:	e8 66 ed ff ff       	call   80105140 <release>
  }
  release(&tickslock);
  return 0;
}
801063da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
801063dd:	83 c4 10             	add    $0x10,%esp
801063e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801063e5:	c9                   	leave  
801063e6:	c3                   	ret    
801063e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063ee:	66 90                	xchg   %ax,%ax
  release(&tickslock);
801063f0:	83 ec 0c             	sub    $0xc,%esp
801063f3:	68 a0 5b 11 80       	push   $0x80115ba0
801063f8:	e8 43 ed ff ff       	call   80105140 <release>
  return 0;
801063fd:	83 c4 10             	add    $0x10,%esp
80106400:	31 c0                	xor    %eax,%eax
}
80106402:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106405:	c9                   	leave  
80106406:	c3                   	ret    
    return -1;
80106407:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010640c:	eb f4                	jmp    80106402 <sys_sleep+0xa2>
8010640e:	66 90                	xchg   %ax,%ax

80106410 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106410:	55                   	push   %ebp
80106411:	89 e5                	mov    %esp,%ebp
80106413:	53                   	push   %ebx
80106414:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106417:	68 a0 5b 11 80       	push   $0x80115ba0
8010641c:	e8 7f ed ff ff       	call   801051a0 <acquire>
  xticks = ticks;
80106421:	8b 1d 80 5b 11 80    	mov    0x80115b80,%ebx
  release(&tickslock);
80106427:	c7 04 24 a0 5b 11 80 	movl   $0x80115ba0,(%esp)
8010642e:	e8 0d ed ff ff       	call   80105140 <release>
  return xticks;
}
80106433:	89 d8                	mov    %ebx,%eax
80106435:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106438:	c9                   	leave  
80106439:	c3                   	ret    
8010643a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106440 <sys_printprocinfo>:


extern void printprocinfo(void);

int sys_printprocinfo(void){
80106440:	55                   	push   %ebp
80106441:	89 e5                	mov    %esp,%ebp
80106443:	83 ec 08             	sub    $0x8,%esp
  printprocinfo();
80106446:	e8 75 e4 ff ff       	call   801048c0 <printprocinfo>
  return 0;
}
8010644b:	31 c0                	xor    %eax,%eax
8010644d:	c9                   	leave  
8010644e:	c3                   	ret    

8010644f <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010644f:	1e                   	push   %ds
  pushl %es
80106450:	06                   	push   %es
  pushl %fs
80106451:	0f a0                	push   %fs
  pushl %gs
80106453:	0f a8                	push   %gs
  pushal
80106455:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106456:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010645a:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010645c:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010645e:	54                   	push   %esp
  call trap
8010645f:	e8 cc 00 00 00       	call   80106530 <trap>
  addl $4, %esp
80106464:	83 c4 04             	add    $0x4,%esp

80106467 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106467:	61                   	popa   
  popl %gs
80106468:	0f a9                	pop    %gs
  popl %fs
8010646a:	0f a1                	pop    %fs
  popl %es
8010646c:	07                   	pop    %es
  popl %ds
8010646d:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010646e:	83 c4 08             	add    $0x8,%esp
  iret
80106471:	cf                   	iret   
80106472:	66 90                	xchg   %ax,%ax
80106474:	66 90                	xchg   %ax,%ax
80106476:	66 90                	xchg   %ax,%ax
80106478:	66 90                	xchg   %ax,%ax
8010647a:	66 90                	xchg   %ax,%ax
8010647c:	66 90                	xchg   %ax,%ax
8010647e:	66 90                	xchg   %ax,%ax

80106480 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106480:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106481:	31 c0                	xor    %eax,%eax
{
80106483:	89 e5                	mov    %esp,%ebp
80106485:	83 ec 08             	sub    $0x8,%esp
80106488:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010648f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106490:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106497:	c7 04 c5 e2 5b 11 80 	movl   $0x8e000008,-0x7feea41e(,%eax,8)
8010649e:	08 00 00 8e 
801064a2:	66 89 14 c5 e0 5b 11 	mov    %dx,-0x7feea420(,%eax,8)
801064a9:	80 
801064aa:	c1 ea 10             	shr    $0x10,%edx
801064ad:	66 89 14 c5 e6 5b 11 	mov    %dx,-0x7feea41a(,%eax,8)
801064b4:	80 
  for(i = 0; i < 256; i++)
801064b5:	83 c0 01             	add    $0x1,%eax
801064b8:	3d 00 01 00 00       	cmp    $0x100,%eax
801064bd:	75 d1                	jne    80106490 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801064bf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801064c2:	a1 08 b1 10 80       	mov    0x8010b108,%eax
801064c7:	c7 05 e2 5d 11 80 08 	movl   $0xef000008,0x80115de2
801064ce:	00 00 ef 
  initlock(&tickslock, "time");
801064d1:	68 0c 84 10 80       	push   $0x8010840c
801064d6:	68 a0 5b 11 80       	push   $0x80115ba0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801064db:	66 a3 e0 5d 11 80    	mov    %ax,0x80115de0
801064e1:	c1 e8 10             	shr    $0x10,%eax
801064e4:	66 a3 e6 5d 11 80    	mov    %ax,0x80115de6
  initlock(&tickslock, "time");
801064ea:	e8 e1 ea ff ff       	call   80104fd0 <initlock>
}
801064ef:	83 c4 10             	add    $0x10,%esp
801064f2:	c9                   	leave  
801064f3:	c3                   	ret    
801064f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801064ff:	90                   	nop

80106500 <idtinit>:

void
idtinit(void)
{
80106500:	55                   	push   %ebp
  pd[0] = size-1;
80106501:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106506:	89 e5                	mov    %esp,%ebp
80106508:	83 ec 10             	sub    $0x10,%esp
8010650b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010650f:	b8 e0 5b 11 80       	mov    $0x80115be0,%eax
80106514:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106518:	c1 e8 10             	shr    $0x10,%eax
8010651b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010651f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106522:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106525:	c9                   	leave  
80106526:	c3                   	ret    
80106527:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010652e:	66 90                	xchg   %ax,%ax

80106530 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106530:	55                   	push   %ebp
80106531:	89 e5                	mov    %esp,%ebp
80106533:	57                   	push   %edi
80106534:	56                   	push   %esi
80106535:	53                   	push   %ebx
80106536:	83 ec 1c             	sub    $0x1c,%esp
80106539:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010653c:	8b 43 30             	mov    0x30(%ebx),%eax
8010653f:	83 f8 40             	cmp    $0x40,%eax
80106542:	0f 84 68 01 00 00    	je     801066b0 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106548:	83 e8 20             	sub    $0x20,%eax
8010654b:	83 f8 1f             	cmp    $0x1f,%eax
8010654e:	0f 87 8c 00 00 00    	ja     801065e0 <trap+0xb0>
80106554:	ff 24 85 e8 87 10 80 	jmp    *-0x7fef7818(,%eax,4)
8010655b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010655f:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106560:	e8 4b bd ff ff       	call   801022b0 <ideintr>
    lapiceoi();
80106565:	e8 16 c4 ff ff       	call   80102980 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010656a:	e8 c1 d4 ff ff       	call   80103a30 <myproc>
8010656f:	85 c0                	test   %eax,%eax
80106571:	74 1d                	je     80106590 <trap+0x60>
80106573:	e8 b8 d4 ff ff       	call   80103a30 <myproc>
80106578:	8b 50 24             	mov    0x24(%eax),%edx
8010657b:	85 d2                	test   %edx,%edx
8010657d:	74 11                	je     80106590 <trap+0x60>
8010657f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106583:	83 e0 03             	and    $0x3,%eax
80106586:	66 83 f8 03          	cmp    $0x3,%ax
8010658a:	0f 84 e8 01 00 00    	je     80106778 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106590:	e8 9b d4 ff ff       	call   80103a30 <myproc>
80106595:	85 c0                	test   %eax,%eax
80106597:	74 0f                	je     801065a8 <trap+0x78>
80106599:	e8 92 d4 ff ff       	call   80103a30 <myproc>
8010659e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801065a2:	0f 84 b8 00 00 00    	je     80106660 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801065a8:	e8 83 d4 ff ff       	call   80103a30 <myproc>
801065ad:	85 c0                	test   %eax,%eax
801065af:	74 1d                	je     801065ce <trap+0x9e>
801065b1:	e8 7a d4 ff ff       	call   80103a30 <myproc>
801065b6:	8b 40 24             	mov    0x24(%eax),%eax
801065b9:	85 c0                	test   %eax,%eax
801065bb:	74 11                	je     801065ce <trap+0x9e>
801065bd:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801065c1:	83 e0 03             	and    $0x3,%eax
801065c4:	66 83 f8 03          	cmp    $0x3,%ax
801065c8:	0f 84 0f 01 00 00    	je     801066dd <trap+0x1ad>
    exit();
}
801065ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065d1:	5b                   	pop    %ebx
801065d2:	5e                   	pop    %esi
801065d3:	5f                   	pop    %edi
801065d4:	5d                   	pop    %ebp
801065d5:	c3                   	ret    
801065d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065dd:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
801065e0:	e8 4b d4 ff ff       	call   80103a30 <myproc>
801065e5:	8b 7b 38             	mov    0x38(%ebx),%edi
801065e8:	85 c0                	test   %eax,%eax
801065ea:	0f 84 a2 01 00 00    	je     80106792 <trap+0x262>
801065f0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801065f4:	0f 84 98 01 00 00    	je     80106792 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801065fa:	0f 20 d1             	mov    %cr2,%ecx
801065fd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106600:	e8 0b d4 ff ff       	call   80103a10 <cpuid>
80106605:	8b 73 30             	mov    0x30(%ebx),%esi
80106608:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010660b:	8b 43 34             	mov    0x34(%ebx),%eax
8010660e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80106611:	e8 1a d4 ff ff       	call   80103a30 <myproc>
80106616:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106619:	e8 12 d4 ff ff       	call   80103a30 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010661e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106621:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106624:	51                   	push   %ecx
80106625:	57                   	push   %edi
80106626:	52                   	push   %edx
80106627:	ff 75 e4             	push   -0x1c(%ebp)
8010662a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010662b:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010662e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106631:	56                   	push   %esi
80106632:	ff 70 10             	push   0x10(%eax)
80106635:	68 a4 87 10 80       	push   $0x801087a4
8010663a:	e8 61 a0 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
8010663f:	83 c4 20             	add    $0x20,%esp
80106642:	e8 e9 d3 ff ff       	call   80103a30 <myproc>
80106647:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010664e:	e8 dd d3 ff ff       	call   80103a30 <myproc>
80106653:	85 c0                	test   %eax,%eax
80106655:	0f 85 18 ff ff ff    	jne    80106573 <trap+0x43>
8010665b:	e9 30 ff ff ff       	jmp    80106590 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80106660:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106664:	0f 85 3e ff ff ff    	jne    801065a8 <trap+0x78>
    yield();
8010666a:	e8 e1 dc ff ff       	call   80104350 <yield>
8010666f:	e9 34 ff ff ff       	jmp    801065a8 <trap+0x78>
80106674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106678:	8b 7b 38             	mov    0x38(%ebx),%edi
8010667b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
8010667f:	e8 8c d3 ff ff       	call   80103a10 <cpuid>
80106684:	57                   	push   %edi
80106685:	56                   	push   %esi
80106686:	50                   	push   %eax
80106687:	68 4c 87 10 80       	push   $0x8010874c
8010668c:	e8 0f a0 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80106691:	e8 ea c2 ff ff       	call   80102980 <lapiceoi>
    break;
80106696:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106699:	e8 92 d3 ff ff       	call   80103a30 <myproc>
8010669e:	85 c0                	test   %eax,%eax
801066a0:	0f 85 cd fe ff ff    	jne    80106573 <trap+0x43>
801066a6:	e9 e5 fe ff ff       	jmp    80106590 <trap+0x60>
801066ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801066af:	90                   	nop
    if(myproc()->killed)
801066b0:	e8 7b d3 ff ff       	call   80103a30 <myproc>
801066b5:	8b 70 24             	mov    0x24(%eax),%esi
801066b8:	85 f6                	test   %esi,%esi
801066ba:	0f 85 c8 00 00 00    	jne    80106788 <trap+0x258>
    myproc()->tf = tf;
801066c0:	e8 6b d3 ff ff       	call   80103a30 <myproc>
801066c5:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801066c8:	e8 93 ef ff ff       	call   80105660 <syscall>
    if(myproc()->killed)
801066cd:	e8 5e d3 ff ff       	call   80103a30 <myproc>
801066d2:	8b 48 24             	mov    0x24(%eax),%ecx
801066d5:	85 c9                	test   %ecx,%ecx
801066d7:	0f 84 f1 fe ff ff    	je     801065ce <trap+0x9e>
}
801066dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066e0:	5b                   	pop    %ebx
801066e1:	5e                   	pop    %esi
801066e2:	5f                   	pop    %edi
801066e3:	5d                   	pop    %ebp
      exit();
801066e4:	e9 b7 d9 ff ff       	jmp    801040a0 <exit>
801066e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
801066f0:	e8 3b 02 00 00       	call   80106930 <uartintr>
    lapiceoi();
801066f5:	e8 86 c2 ff ff       	call   80102980 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801066fa:	e8 31 d3 ff ff       	call   80103a30 <myproc>
801066ff:	85 c0                	test   %eax,%eax
80106701:	0f 85 6c fe ff ff    	jne    80106573 <trap+0x43>
80106707:	e9 84 fe ff ff       	jmp    80106590 <trap+0x60>
8010670c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106710:	e8 2b c1 ff ff       	call   80102840 <kbdintr>
    lapiceoi();
80106715:	e8 66 c2 ff ff       	call   80102980 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010671a:	e8 11 d3 ff ff       	call   80103a30 <myproc>
8010671f:	85 c0                	test   %eax,%eax
80106721:	0f 85 4c fe ff ff    	jne    80106573 <trap+0x43>
80106727:	e9 64 fe ff ff       	jmp    80106590 <trap+0x60>
8010672c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106730:	e8 db d2 ff ff       	call   80103a10 <cpuid>
80106735:	85 c0                	test   %eax,%eax
80106737:	0f 85 28 fe ff ff    	jne    80106565 <trap+0x35>
      acquire(&tickslock);
8010673d:	83 ec 0c             	sub    $0xc,%esp
80106740:	68 a0 5b 11 80       	push   $0x80115ba0
80106745:	e8 56 ea ff ff       	call   801051a0 <acquire>
      wakeup(&ticks);
8010674a:	c7 04 24 80 5b 11 80 	movl   $0x80115b80,(%esp)
      ticks++;
80106751:	83 05 80 5b 11 80 01 	addl   $0x1,0x80115b80
      wakeup(&ticks);
80106758:	e8 43 dd ff ff       	call   801044a0 <wakeup>
      release(&tickslock);
8010675d:	c7 04 24 a0 5b 11 80 	movl   $0x80115ba0,(%esp)
80106764:	e8 d7 e9 ff ff       	call   80105140 <release>
80106769:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010676c:	e9 f4 fd ff ff       	jmp    80106565 <trap+0x35>
80106771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80106778:	e8 23 d9 ff ff       	call   801040a0 <exit>
8010677d:	e9 0e fe ff ff       	jmp    80106590 <trap+0x60>
80106782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106788:	e8 13 d9 ff ff       	call   801040a0 <exit>
8010678d:	e9 2e ff ff ff       	jmp    801066c0 <trap+0x190>
80106792:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106795:	e8 76 d2 ff ff       	call   80103a10 <cpuid>
8010679a:	83 ec 0c             	sub    $0xc,%esp
8010679d:	56                   	push   %esi
8010679e:	57                   	push   %edi
8010679f:	50                   	push   %eax
801067a0:	ff 73 30             	push   0x30(%ebx)
801067a3:	68 70 87 10 80       	push   $0x80108770
801067a8:	e8 f3 9e ff ff       	call   801006a0 <cprintf>
      panic("trap");
801067ad:	83 c4 14             	add    $0x14,%esp
801067b0:	68 45 87 10 80       	push   $0x80108745
801067b5:	e8 c6 9b ff ff       	call   80100380 <panic>
801067ba:	66 90                	xchg   %ax,%ax
801067bc:	66 90                	xchg   %ax,%ax
801067be:	66 90                	xchg   %ax,%ax

801067c0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801067c0:	a1 e0 63 11 80       	mov    0x801163e0,%eax
801067c5:	85 c0                	test   %eax,%eax
801067c7:	74 17                	je     801067e0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801067c9:	ba fd 03 00 00       	mov    $0x3fd,%edx
801067ce:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801067cf:	a8 01                	test   $0x1,%al
801067d1:	74 0d                	je     801067e0 <uartgetc+0x20>
801067d3:	ba f8 03 00 00       	mov    $0x3f8,%edx
801067d8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801067d9:	0f b6 c0             	movzbl %al,%eax
801067dc:	c3                   	ret    
801067dd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801067e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801067e5:	c3                   	ret    
801067e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067ed:	8d 76 00             	lea    0x0(%esi),%esi

801067f0 <uartinit>:
{
801067f0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801067f1:	31 c9                	xor    %ecx,%ecx
801067f3:	89 c8                	mov    %ecx,%eax
801067f5:	89 e5                	mov    %esp,%ebp
801067f7:	57                   	push   %edi
801067f8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801067fd:	56                   	push   %esi
801067fe:	89 fa                	mov    %edi,%edx
80106800:	53                   	push   %ebx
80106801:	83 ec 1c             	sub    $0x1c,%esp
80106804:	ee                   	out    %al,(%dx)
80106805:	be fb 03 00 00       	mov    $0x3fb,%esi
8010680a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010680f:	89 f2                	mov    %esi,%edx
80106811:	ee                   	out    %al,(%dx)
80106812:	b8 0c 00 00 00       	mov    $0xc,%eax
80106817:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010681c:	ee                   	out    %al,(%dx)
8010681d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106822:	89 c8                	mov    %ecx,%eax
80106824:	89 da                	mov    %ebx,%edx
80106826:	ee                   	out    %al,(%dx)
80106827:	b8 03 00 00 00       	mov    $0x3,%eax
8010682c:	89 f2                	mov    %esi,%edx
8010682e:	ee                   	out    %al,(%dx)
8010682f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106834:	89 c8                	mov    %ecx,%eax
80106836:	ee                   	out    %al,(%dx)
80106837:	b8 01 00 00 00       	mov    $0x1,%eax
8010683c:	89 da                	mov    %ebx,%edx
8010683e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010683f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106844:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106845:	3c ff                	cmp    $0xff,%al
80106847:	74 78                	je     801068c1 <uartinit+0xd1>
  uart = 1;
80106849:	c7 05 e0 63 11 80 01 	movl   $0x1,0x801163e0
80106850:	00 00 00 
80106853:	89 fa                	mov    %edi,%edx
80106855:	ec                   	in     (%dx),%al
80106856:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010685b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010685c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010685f:	bf 68 88 10 80       	mov    $0x80108868,%edi
80106864:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106869:	6a 00                	push   $0x0
8010686b:	6a 04                	push   $0x4
8010686d:	e8 7e bc ff ff       	call   801024f0 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106872:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106876:	83 c4 10             	add    $0x10,%esp
80106879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106880:	a1 e0 63 11 80       	mov    0x801163e0,%eax
80106885:	bb 80 00 00 00       	mov    $0x80,%ebx
8010688a:	85 c0                	test   %eax,%eax
8010688c:	75 14                	jne    801068a2 <uartinit+0xb2>
8010688e:	eb 23                	jmp    801068b3 <uartinit+0xc3>
    microdelay(10);
80106890:	83 ec 0c             	sub    $0xc,%esp
80106893:	6a 0a                	push   $0xa
80106895:	e8 06 c1 ff ff       	call   801029a0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010689a:	83 c4 10             	add    $0x10,%esp
8010689d:	83 eb 01             	sub    $0x1,%ebx
801068a0:	74 07                	je     801068a9 <uartinit+0xb9>
801068a2:	89 f2                	mov    %esi,%edx
801068a4:	ec                   	in     (%dx),%al
801068a5:	a8 20                	test   $0x20,%al
801068a7:	74 e7                	je     80106890 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801068a9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801068ad:	ba f8 03 00 00       	mov    $0x3f8,%edx
801068b2:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
801068b3:	0f b6 47 01          	movzbl 0x1(%edi),%eax
801068b7:	83 c7 01             	add    $0x1,%edi
801068ba:	88 45 e7             	mov    %al,-0x19(%ebp)
801068bd:	84 c0                	test   %al,%al
801068bf:	75 bf                	jne    80106880 <uartinit+0x90>
}
801068c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068c4:	5b                   	pop    %ebx
801068c5:	5e                   	pop    %esi
801068c6:	5f                   	pop    %edi
801068c7:	5d                   	pop    %ebp
801068c8:	c3                   	ret    
801068c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801068d0 <uartputc>:
  if(!uart)
801068d0:	a1 e0 63 11 80       	mov    0x801163e0,%eax
801068d5:	85 c0                	test   %eax,%eax
801068d7:	74 47                	je     80106920 <uartputc+0x50>
{
801068d9:	55                   	push   %ebp
801068da:	89 e5                	mov    %esp,%ebp
801068dc:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801068dd:	be fd 03 00 00       	mov    $0x3fd,%esi
801068e2:	53                   	push   %ebx
801068e3:	bb 80 00 00 00       	mov    $0x80,%ebx
801068e8:	eb 18                	jmp    80106902 <uartputc+0x32>
801068ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
801068f0:	83 ec 0c             	sub    $0xc,%esp
801068f3:	6a 0a                	push   $0xa
801068f5:	e8 a6 c0 ff ff       	call   801029a0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801068fa:	83 c4 10             	add    $0x10,%esp
801068fd:	83 eb 01             	sub    $0x1,%ebx
80106900:	74 07                	je     80106909 <uartputc+0x39>
80106902:	89 f2                	mov    %esi,%edx
80106904:	ec                   	in     (%dx),%al
80106905:	a8 20                	test   $0x20,%al
80106907:	74 e7                	je     801068f0 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106909:	8b 45 08             	mov    0x8(%ebp),%eax
8010690c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106911:	ee                   	out    %al,(%dx)
}
80106912:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106915:	5b                   	pop    %ebx
80106916:	5e                   	pop    %esi
80106917:	5d                   	pop    %ebp
80106918:	c3                   	ret    
80106919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106920:	c3                   	ret    
80106921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106928:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010692f:	90                   	nop

80106930 <uartintr>:

void
uartintr(void)
{
80106930:	55                   	push   %ebp
80106931:	89 e5                	mov    %esp,%ebp
80106933:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106936:	68 c0 67 10 80       	push   $0x801067c0
8010693b:	e8 40 9f ff ff       	call   80100880 <consoleintr>
}
80106940:	83 c4 10             	add    $0x10,%esp
80106943:	c9                   	leave  
80106944:	c3                   	ret    

80106945 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106945:	6a 00                	push   $0x0
  pushl $0
80106947:	6a 00                	push   $0x0
  jmp alltraps
80106949:	e9 01 fb ff ff       	jmp    8010644f <alltraps>

8010694e <vector1>:
.globl vector1
vector1:
  pushl $0
8010694e:	6a 00                	push   $0x0
  pushl $1
80106950:	6a 01                	push   $0x1
  jmp alltraps
80106952:	e9 f8 fa ff ff       	jmp    8010644f <alltraps>

80106957 <vector2>:
.globl vector2
vector2:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $2
80106959:	6a 02                	push   $0x2
  jmp alltraps
8010695b:	e9 ef fa ff ff       	jmp    8010644f <alltraps>

80106960 <vector3>:
.globl vector3
vector3:
  pushl $0
80106960:	6a 00                	push   $0x0
  pushl $3
80106962:	6a 03                	push   $0x3
  jmp alltraps
80106964:	e9 e6 fa ff ff       	jmp    8010644f <alltraps>

80106969 <vector4>:
.globl vector4
vector4:
  pushl $0
80106969:	6a 00                	push   $0x0
  pushl $4
8010696b:	6a 04                	push   $0x4
  jmp alltraps
8010696d:	e9 dd fa ff ff       	jmp    8010644f <alltraps>

80106972 <vector5>:
.globl vector5
vector5:
  pushl $0
80106972:	6a 00                	push   $0x0
  pushl $5
80106974:	6a 05                	push   $0x5
  jmp alltraps
80106976:	e9 d4 fa ff ff       	jmp    8010644f <alltraps>

8010697b <vector6>:
.globl vector6
vector6:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $6
8010697d:	6a 06                	push   $0x6
  jmp alltraps
8010697f:	e9 cb fa ff ff       	jmp    8010644f <alltraps>

80106984 <vector7>:
.globl vector7
vector7:
  pushl $0
80106984:	6a 00                	push   $0x0
  pushl $7
80106986:	6a 07                	push   $0x7
  jmp alltraps
80106988:	e9 c2 fa ff ff       	jmp    8010644f <alltraps>

8010698d <vector8>:
.globl vector8
vector8:
  pushl $8
8010698d:	6a 08                	push   $0x8
  jmp alltraps
8010698f:	e9 bb fa ff ff       	jmp    8010644f <alltraps>

80106994 <vector9>:
.globl vector9
vector9:
  pushl $0
80106994:	6a 00                	push   $0x0
  pushl $9
80106996:	6a 09                	push   $0x9
  jmp alltraps
80106998:	e9 b2 fa ff ff       	jmp    8010644f <alltraps>

8010699d <vector10>:
.globl vector10
vector10:
  pushl $10
8010699d:	6a 0a                	push   $0xa
  jmp alltraps
8010699f:	e9 ab fa ff ff       	jmp    8010644f <alltraps>

801069a4 <vector11>:
.globl vector11
vector11:
  pushl $11
801069a4:	6a 0b                	push   $0xb
  jmp alltraps
801069a6:	e9 a4 fa ff ff       	jmp    8010644f <alltraps>

801069ab <vector12>:
.globl vector12
vector12:
  pushl $12
801069ab:	6a 0c                	push   $0xc
  jmp alltraps
801069ad:	e9 9d fa ff ff       	jmp    8010644f <alltraps>

801069b2 <vector13>:
.globl vector13
vector13:
  pushl $13
801069b2:	6a 0d                	push   $0xd
  jmp alltraps
801069b4:	e9 96 fa ff ff       	jmp    8010644f <alltraps>

801069b9 <vector14>:
.globl vector14
vector14:
  pushl $14
801069b9:	6a 0e                	push   $0xe
  jmp alltraps
801069bb:	e9 8f fa ff ff       	jmp    8010644f <alltraps>

801069c0 <vector15>:
.globl vector15
vector15:
  pushl $0
801069c0:	6a 00                	push   $0x0
  pushl $15
801069c2:	6a 0f                	push   $0xf
  jmp alltraps
801069c4:	e9 86 fa ff ff       	jmp    8010644f <alltraps>

801069c9 <vector16>:
.globl vector16
vector16:
  pushl $0
801069c9:	6a 00                	push   $0x0
  pushl $16
801069cb:	6a 10                	push   $0x10
  jmp alltraps
801069cd:	e9 7d fa ff ff       	jmp    8010644f <alltraps>

801069d2 <vector17>:
.globl vector17
vector17:
  pushl $17
801069d2:	6a 11                	push   $0x11
  jmp alltraps
801069d4:	e9 76 fa ff ff       	jmp    8010644f <alltraps>

801069d9 <vector18>:
.globl vector18
vector18:
  pushl $0
801069d9:	6a 00                	push   $0x0
  pushl $18
801069db:	6a 12                	push   $0x12
  jmp alltraps
801069dd:	e9 6d fa ff ff       	jmp    8010644f <alltraps>

801069e2 <vector19>:
.globl vector19
vector19:
  pushl $0
801069e2:	6a 00                	push   $0x0
  pushl $19
801069e4:	6a 13                	push   $0x13
  jmp alltraps
801069e6:	e9 64 fa ff ff       	jmp    8010644f <alltraps>

801069eb <vector20>:
.globl vector20
vector20:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $20
801069ed:	6a 14                	push   $0x14
  jmp alltraps
801069ef:	e9 5b fa ff ff       	jmp    8010644f <alltraps>

801069f4 <vector21>:
.globl vector21
vector21:
  pushl $0
801069f4:	6a 00                	push   $0x0
  pushl $21
801069f6:	6a 15                	push   $0x15
  jmp alltraps
801069f8:	e9 52 fa ff ff       	jmp    8010644f <alltraps>

801069fd <vector22>:
.globl vector22
vector22:
  pushl $0
801069fd:	6a 00                	push   $0x0
  pushl $22
801069ff:	6a 16                	push   $0x16
  jmp alltraps
80106a01:	e9 49 fa ff ff       	jmp    8010644f <alltraps>

80106a06 <vector23>:
.globl vector23
vector23:
  pushl $0
80106a06:	6a 00                	push   $0x0
  pushl $23
80106a08:	6a 17                	push   $0x17
  jmp alltraps
80106a0a:	e9 40 fa ff ff       	jmp    8010644f <alltraps>

80106a0f <vector24>:
.globl vector24
vector24:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $24
80106a11:	6a 18                	push   $0x18
  jmp alltraps
80106a13:	e9 37 fa ff ff       	jmp    8010644f <alltraps>

80106a18 <vector25>:
.globl vector25
vector25:
  pushl $0
80106a18:	6a 00                	push   $0x0
  pushl $25
80106a1a:	6a 19                	push   $0x19
  jmp alltraps
80106a1c:	e9 2e fa ff ff       	jmp    8010644f <alltraps>

80106a21 <vector26>:
.globl vector26
vector26:
  pushl $0
80106a21:	6a 00                	push   $0x0
  pushl $26
80106a23:	6a 1a                	push   $0x1a
  jmp alltraps
80106a25:	e9 25 fa ff ff       	jmp    8010644f <alltraps>

80106a2a <vector27>:
.globl vector27
vector27:
  pushl $0
80106a2a:	6a 00                	push   $0x0
  pushl $27
80106a2c:	6a 1b                	push   $0x1b
  jmp alltraps
80106a2e:	e9 1c fa ff ff       	jmp    8010644f <alltraps>

80106a33 <vector28>:
.globl vector28
vector28:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $28
80106a35:	6a 1c                	push   $0x1c
  jmp alltraps
80106a37:	e9 13 fa ff ff       	jmp    8010644f <alltraps>

80106a3c <vector29>:
.globl vector29
vector29:
  pushl $0
80106a3c:	6a 00                	push   $0x0
  pushl $29
80106a3e:	6a 1d                	push   $0x1d
  jmp alltraps
80106a40:	e9 0a fa ff ff       	jmp    8010644f <alltraps>

80106a45 <vector30>:
.globl vector30
vector30:
  pushl $0
80106a45:	6a 00                	push   $0x0
  pushl $30
80106a47:	6a 1e                	push   $0x1e
  jmp alltraps
80106a49:	e9 01 fa ff ff       	jmp    8010644f <alltraps>

80106a4e <vector31>:
.globl vector31
vector31:
  pushl $0
80106a4e:	6a 00                	push   $0x0
  pushl $31
80106a50:	6a 1f                	push   $0x1f
  jmp alltraps
80106a52:	e9 f8 f9 ff ff       	jmp    8010644f <alltraps>

80106a57 <vector32>:
.globl vector32
vector32:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $32
80106a59:	6a 20                	push   $0x20
  jmp alltraps
80106a5b:	e9 ef f9 ff ff       	jmp    8010644f <alltraps>

80106a60 <vector33>:
.globl vector33
vector33:
  pushl $0
80106a60:	6a 00                	push   $0x0
  pushl $33
80106a62:	6a 21                	push   $0x21
  jmp alltraps
80106a64:	e9 e6 f9 ff ff       	jmp    8010644f <alltraps>

80106a69 <vector34>:
.globl vector34
vector34:
  pushl $0
80106a69:	6a 00                	push   $0x0
  pushl $34
80106a6b:	6a 22                	push   $0x22
  jmp alltraps
80106a6d:	e9 dd f9 ff ff       	jmp    8010644f <alltraps>

80106a72 <vector35>:
.globl vector35
vector35:
  pushl $0
80106a72:	6a 00                	push   $0x0
  pushl $35
80106a74:	6a 23                	push   $0x23
  jmp alltraps
80106a76:	e9 d4 f9 ff ff       	jmp    8010644f <alltraps>

80106a7b <vector36>:
.globl vector36
vector36:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $36
80106a7d:	6a 24                	push   $0x24
  jmp alltraps
80106a7f:	e9 cb f9 ff ff       	jmp    8010644f <alltraps>

80106a84 <vector37>:
.globl vector37
vector37:
  pushl $0
80106a84:	6a 00                	push   $0x0
  pushl $37
80106a86:	6a 25                	push   $0x25
  jmp alltraps
80106a88:	e9 c2 f9 ff ff       	jmp    8010644f <alltraps>

80106a8d <vector38>:
.globl vector38
vector38:
  pushl $0
80106a8d:	6a 00                	push   $0x0
  pushl $38
80106a8f:	6a 26                	push   $0x26
  jmp alltraps
80106a91:	e9 b9 f9 ff ff       	jmp    8010644f <alltraps>

80106a96 <vector39>:
.globl vector39
vector39:
  pushl $0
80106a96:	6a 00                	push   $0x0
  pushl $39
80106a98:	6a 27                	push   $0x27
  jmp alltraps
80106a9a:	e9 b0 f9 ff ff       	jmp    8010644f <alltraps>

80106a9f <vector40>:
.globl vector40
vector40:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $40
80106aa1:	6a 28                	push   $0x28
  jmp alltraps
80106aa3:	e9 a7 f9 ff ff       	jmp    8010644f <alltraps>

80106aa8 <vector41>:
.globl vector41
vector41:
  pushl $0
80106aa8:	6a 00                	push   $0x0
  pushl $41
80106aaa:	6a 29                	push   $0x29
  jmp alltraps
80106aac:	e9 9e f9 ff ff       	jmp    8010644f <alltraps>

80106ab1 <vector42>:
.globl vector42
vector42:
  pushl $0
80106ab1:	6a 00                	push   $0x0
  pushl $42
80106ab3:	6a 2a                	push   $0x2a
  jmp alltraps
80106ab5:	e9 95 f9 ff ff       	jmp    8010644f <alltraps>

80106aba <vector43>:
.globl vector43
vector43:
  pushl $0
80106aba:	6a 00                	push   $0x0
  pushl $43
80106abc:	6a 2b                	push   $0x2b
  jmp alltraps
80106abe:	e9 8c f9 ff ff       	jmp    8010644f <alltraps>

80106ac3 <vector44>:
.globl vector44
vector44:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $44
80106ac5:	6a 2c                	push   $0x2c
  jmp alltraps
80106ac7:	e9 83 f9 ff ff       	jmp    8010644f <alltraps>

80106acc <vector45>:
.globl vector45
vector45:
  pushl $0
80106acc:	6a 00                	push   $0x0
  pushl $45
80106ace:	6a 2d                	push   $0x2d
  jmp alltraps
80106ad0:	e9 7a f9 ff ff       	jmp    8010644f <alltraps>

80106ad5 <vector46>:
.globl vector46
vector46:
  pushl $0
80106ad5:	6a 00                	push   $0x0
  pushl $46
80106ad7:	6a 2e                	push   $0x2e
  jmp alltraps
80106ad9:	e9 71 f9 ff ff       	jmp    8010644f <alltraps>

80106ade <vector47>:
.globl vector47
vector47:
  pushl $0
80106ade:	6a 00                	push   $0x0
  pushl $47
80106ae0:	6a 2f                	push   $0x2f
  jmp alltraps
80106ae2:	e9 68 f9 ff ff       	jmp    8010644f <alltraps>

80106ae7 <vector48>:
.globl vector48
vector48:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $48
80106ae9:	6a 30                	push   $0x30
  jmp alltraps
80106aeb:	e9 5f f9 ff ff       	jmp    8010644f <alltraps>

80106af0 <vector49>:
.globl vector49
vector49:
  pushl $0
80106af0:	6a 00                	push   $0x0
  pushl $49
80106af2:	6a 31                	push   $0x31
  jmp alltraps
80106af4:	e9 56 f9 ff ff       	jmp    8010644f <alltraps>

80106af9 <vector50>:
.globl vector50
vector50:
  pushl $0
80106af9:	6a 00                	push   $0x0
  pushl $50
80106afb:	6a 32                	push   $0x32
  jmp alltraps
80106afd:	e9 4d f9 ff ff       	jmp    8010644f <alltraps>

80106b02 <vector51>:
.globl vector51
vector51:
  pushl $0
80106b02:	6a 00                	push   $0x0
  pushl $51
80106b04:	6a 33                	push   $0x33
  jmp alltraps
80106b06:	e9 44 f9 ff ff       	jmp    8010644f <alltraps>

80106b0b <vector52>:
.globl vector52
vector52:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $52
80106b0d:	6a 34                	push   $0x34
  jmp alltraps
80106b0f:	e9 3b f9 ff ff       	jmp    8010644f <alltraps>

80106b14 <vector53>:
.globl vector53
vector53:
  pushl $0
80106b14:	6a 00                	push   $0x0
  pushl $53
80106b16:	6a 35                	push   $0x35
  jmp alltraps
80106b18:	e9 32 f9 ff ff       	jmp    8010644f <alltraps>

80106b1d <vector54>:
.globl vector54
vector54:
  pushl $0
80106b1d:	6a 00                	push   $0x0
  pushl $54
80106b1f:	6a 36                	push   $0x36
  jmp alltraps
80106b21:	e9 29 f9 ff ff       	jmp    8010644f <alltraps>

80106b26 <vector55>:
.globl vector55
vector55:
  pushl $0
80106b26:	6a 00                	push   $0x0
  pushl $55
80106b28:	6a 37                	push   $0x37
  jmp alltraps
80106b2a:	e9 20 f9 ff ff       	jmp    8010644f <alltraps>

80106b2f <vector56>:
.globl vector56
vector56:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $56
80106b31:	6a 38                	push   $0x38
  jmp alltraps
80106b33:	e9 17 f9 ff ff       	jmp    8010644f <alltraps>

80106b38 <vector57>:
.globl vector57
vector57:
  pushl $0
80106b38:	6a 00                	push   $0x0
  pushl $57
80106b3a:	6a 39                	push   $0x39
  jmp alltraps
80106b3c:	e9 0e f9 ff ff       	jmp    8010644f <alltraps>

80106b41 <vector58>:
.globl vector58
vector58:
  pushl $0
80106b41:	6a 00                	push   $0x0
  pushl $58
80106b43:	6a 3a                	push   $0x3a
  jmp alltraps
80106b45:	e9 05 f9 ff ff       	jmp    8010644f <alltraps>

80106b4a <vector59>:
.globl vector59
vector59:
  pushl $0
80106b4a:	6a 00                	push   $0x0
  pushl $59
80106b4c:	6a 3b                	push   $0x3b
  jmp alltraps
80106b4e:	e9 fc f8 ff ff       	jmp    8010644f <alltraps>

80106b53 <vector60>:
.globl vector60
vector60:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $60
80106b55:	6a 3c                	push   $0x3c
  jmp alltraps
80106b57:	e9 f3 f8 ff ff       	jmp    8010644f <alltraps>

80106b5c <vector61>:
.globl vector61
vector61:
  pushl $0
80106b5c:	6a 00                	push   $0x0
  pushl $61
80106b5e:	6a 3d                	push   $0x3d
  jmp alltraps
80106b60:	e9 ea f8 ff ff       	jmp    8010644f <alltraps>

80106b65 <vector62>:
.globl vector62
vector62:
  pushl $0
80106b65:	6a 00                	push   $0x0
  pushl $62
80106b67:	6a 3e                	push   $0x3e
  jmp alltraps
80106b69:	e9 e1 f8 ff ff       	jmp    8010644f <alltraps>

80106b6e <vector63>:
.globl vector63
vector63:
  pushl $0
80106b6e:	6a 00                	push   $0x0
  pushl $63
80106b70:	6a 3f                	push   $0x3f
  jmp alltraps
80106b72:	e9 d8 f8 ff ff       	jmp    8010644f <alltraps>

80106b77 <vector64>:
.globl vector64
vector64:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $64
80106b79:	6a 40                	push   $0x40
  jmp alltraps
80106b7b:	e9 cf f8 ff ff       	jmp    8010644f <alltraps>

80106b80 <vector65>:
.globl vector65
vector65:
  pushl $0
80106b80:	6a 00                	push   $0x0
  pushl $65
80106b82:	6a 41                	push   $0x41
  jmp alltraps
80106b84:	e9 c6 f8 ff ff       	jmp    8010644f <alltraps>

80106b89 <vector66>:
.globl vector66
vector66:
  pushl $0
80106b89:	6a 00                	push   $0x0
  pushl $66
80106b8b:	6a 42                	push   $0x42
  jmp alltraps
80106b8d:	e9 bd f8 ff ff       	jmp    8010644f <alltraps>

80106b92 <vector67>:
.globl vector67
vector67:
  pushl $0
80106b92:	6a 00                	push   $0x0
  pushl $67
80106b94:	6a 43                	push   $0x43
  jmp alltraps
80106b96:	e9 b4 f8 ff ff       	jmp    8010644f <alltraps>

80106b9b <vector68>:
.globl vector68
vector68:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $68
80106b9d:	6a 44                	push   $0x44
  jmp alltraps
80106b9f:	e9 ab f8 ff ff       	jmp    8010644f <alltraps>

80106ba4 <vector69>:
.globl vector69
vector69:
  pushl $0
80106ba4:	6a 00                	push   $0x0
  pushl $69
80106ba6:	6a 45                	push   $0x45
  jmp alltraps
80106ba8:	e9 a2 f8 ff ff       	jmp    8010644f <alltraps>

80106bad <vector70>:
.globl vector70
vector70:
  pushl $0
80106bad:	6a 00                	push   $0x0
  pushl $70
80106baf:	6a 46                	push   $0x46
  jmp alltraps
80106bb1:	e9 99 f8 ff ff       	jmp    8010644f <alltraps>

80106bb6 <vector71>:
.globl vector71
vector71:
  pushl $0
80106bb6:	6a 00                	push   $0x0
  pushl $71
80106bb8:	6a 47                	push   $0x47
  jmp alltraps
80106bba:	e9 90 f8 ff ff       	jmp    8010644f <alltraps>

80106bbf <vector72>:
.globl vector72
vector72:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $72
80106bc1:	6a 48                	push   $0x48
  jmp alltraps
80106bc3:	e9 87 f8 ff ff       	jmp    8010644f <alltraps>

80106bc8 <vector73>:
.globl vector73
vector73:
  pushl $0
80106bc8:	6a 00                	push   $0x0
  pushl $73
80106bca:	6a 49                	push   $0x49
  jmp alltraps
80106bcc:	e9 7e f8 ff ff       	jmp    8010644f <alltraps>

80106bd1 <vector74>:
.globl vector74
vector74:
  pushl $0
80106bd1:	6a 00                	push   $0x0
  pushl $74
80106bd3:	6a 4a                	push   $0x4a
  jmp alltraps
80106bd5:	e9 75 f8 ff ff       	jmp    8010644f <alltraps>

80106bda <vector75>:
.globl vector75
vector75:
  pushl $0
80106bda:	6a 00                	push   $0x0
  pushl $75
80106bdc:	6a 4b                	push   $0x4b
  jmp alltraps
80106bde:	e9 6c f8 ff ff       	jmp    8010644f <alltraps>

80106be3 <vector76>:
.globl vector76
vector76:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $76
80106be5:	6a 4c                	push   $0x4c
  jmp alltraps
80106be7:	e9 63 f8 ff ff       	jmp    8010644f <alltraps>

80106bec <vector77>:
.globl vector77
vector77:
  pushl $0
80106bec:	6a 00                	push   $0x0
  pushl $77
80106bee:	6a 4d                	push   $0x4d
  jmp alltraps
80106bf0:	e9 5a f8 ff ff       	jmp    8010644f <alltraps>

80106bf5 <vector78>:
.globl vector78
vector78:
  pushl $0
80106bf5:	6a 00                	push   $0x0
  pushl $78
80106bf7:	6a 4e                	push   $0x4e
  jmp alltraps
80106bf9:	e9 51 f8 ff ff       	jmp    8010644f <alltraps>

80106bfe <vector79>:
.globl vector79
vector79:
  pushl $0
80106bfe:	6a 00                	push   $0x0
  pushl $79
80106c00:	6a 4f                	push   $0x4f
  jmp alltraps
80106c02:	e9 48 f8 ff ff       	jmp    8010644f <alltraps>

80106c07 <vector80>:
.globl vector80
vector80:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $80
80106c09:	6a 50                	push   $0x50
  jmp alltraps
80106c0b:	e9 3f f8 ff ff       	jmp    8010644f <alltraps>

80106c10 <vector81>:
.globl vector81
vector81:
  pushl $0
80106c10:	6a 00                	push   $0x0
  pushl $81
80106c12:	6a 51                	push   $0x51
  jmp alltraps
80106c14:	e9 36 f8 ff ff       	jmp    8010644f <alltraps>

80106c19 <vector82>:
.globl vector82
vector82:
  pushl $0
80106c19:	6a 00                	push   $0x0
  pushl $82
80106c1b:	6a 52                	push   $0x52
  jmp alltraps
80106c1d:	e9 2d f8 ff ff       	jmp    8010644f <alltraps>

80106c22 <vector83>:
.globl vector83
vector83:
  pushl $0
80106c22:	6a 00                	push   $0x0
  pushl $83
80106c24:	6a 53                	push   $0x53
  jmp alltraps
80106c26:	e9 24 f8 ff ff       	jmp    8010644f <alltraps>

80106c2b <vector84>:
.globl vector84
vector84:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $84
80106c2d:	6a 54                	push   $0x54
  jmp alltraps
80106c2f:	e9 1b f8 ff ff       	jmp    8010644f <alltraps>

80106c34 <vector85>:
.globl vector85
vector85:
  pushl $0
80106c34:	6a 00                	push   $0x0
  pushl $85
80106c36:	6a 55                	push   $0x55
  jmp alltraps
80106c38:	e9 12 f8 ff ff       	jmp    8010644f <alltraps>

80106c3d <vector86>:
.globl vector86
vector86:
  pushl $0
80106c3d:	6a 00                	push   $0x0
  pushl $86
80106c3f:	6a 56                	push   $0x56
  jmp alltraps
80106c41:	e9 09 f8 ff ff       	jmp    8010644f <alltraps>

80106c46 <vector87>:
.globl vector87
vector87:
  pushl $0
80106c46:	6a 00                	push   $0x0
  pushl $87
80106c48:	6a 57                	push   $0x57
  jmp alltraps
80106c4a:	e9 00 f8 ff ff       	jmp    8010644f <alltraps>

80106c4f <vector88>:
.globl vector88
vector88:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $88
80106c51:	6a 58                	push   $0x58
  jmp alltraps
80106c53:	e9 f7 f7 ff ff       	jmp    8010644f <alltraps>

80106c58 <vector89>:
.globl vector89
vector89:
  pushl $0
80106c58:	6a 00                	push   $0x0
  pushl $89
80106c5a:	6a 59                	push   $0x59
  jmp alltraps
80106c5c:	e9 ee f7 ff ff       	jmp    8010644f <alltraps>

80106c61 <vector90>:
.globl vector90
vector90:
  pushl $0
80106c61:	6a 00                	push   $0x0
  pushl $90
80106c63:	6a 5a                	push   $0x5a
  jmp alltraps
80106c65:	e9 e5 f7 ff ff       	jmp    8010644f <alltraps>

80106c6a <vector91>:
.globl vector91
vector91:
  pushl $0
80106c6a:	6a 00                	push   $0x0
  pushl $91
80106c6c:	6a 5b                	push   $0x5b
  jmp alltraps
80106c6e:	e9 dc f7 ff ff       	jmp    8010644f <alltraps>

80106c73 <vector92>:
.globl vector92
vector92:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $92
80106c75:	6a 5c                	push   $0x5c
  jmp alltraps
80106c77:	e9 d3 f7 ff ff       	jmp    8010644f <alltraps>

80106c7c <vector93>:
.globl vector93
vector93:
  pushl $0
80106c7c:	6a 00                	push   $0x0
  pushl $93
80106c7e:	6a 5d                	push   $0x5d
  jmp alltraps
80106c80:	e9 ca f7 ff ff       	jmp    8010644f <alltraps>

80106c85 <vector94>:
.globl vector94
vector94:
  pushl $0
80106c85:	6a 00                	push   $0x0
  pushl $94
80106c87:	6a 5e                	push   $0x5e
  jmp alltraps
80106c89:	e9 c1 f7 ff ff       	jmp    8010644f <alltraps>

80106c8e <vector95>:
.globl vector95
vector95:
  pushl $0
80106c8e:	6a 00                	push   $0x0
  pushl $95
80106c90:	6a 5f                	push   $0x5f
  jmp alltraps
80106c92:	e9 b8 f7 ff ff       	jmp    8010644f <alltraps>

80106c97 <vector96>:
.globl vector96
vector96:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $96
80106c99:	6a 60                	push   $0x60
  jmp alltraps
80106c9b:	e9 af f7 ff ff       	jmp    8010644f <alltraps>

80106ca0 <vector97>:
.globl vector97
vector97:
  pushl $0
80106ca0:	6a 00                	push   $0x0
  pushl $97
80106ca2:	6a 61                	push   $0x61
  jmp alltraps
80106ca4:	e9 a6 f7 ff ff       	jmp    8010644f <alltraps>

80106ca9 <vector98>:
.globl vector98
vector98:
  pushl $0
80106ca9:	6a 00                	push   $0x0
  pushl $98
80106cab:	6a 62                	push   $0x62
  jmp alltraps
80106cad:	e9 9d f7 ff ff       	jmp    8010644f <alltraps>

80106cb2 <vector99>:
.globl vector99
vector99:
  pushl $0
80106cb2:	6a 00                	push   $0x0
  pushl $99
80106cb4:	6a 63                	push   $0x63
  jmp alltraps
80106cb6:	e9 94 f7 ff ff       	jmp    8010644f <alltraps>

80106cbb <vector100>:
.globl vector100
vector100:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $100
80106cbd:	6a 64                	push   $0x64
  jmp alltraps
80106cbf:	e9 8b f7 ff ff       	jmp    8010644f <alltraps>

80106cc4 <vector101>:
.globl vector101
vector101:
  pushl $0
80106cc4:	6a 00                	push   $0x0
  pushl $101
80106cc6:	6a 65                	push   $0x65
  jmp alltraps
80106cc8:	e9 82 f7 ff ff       	jmp    8010644f <alltraps>

80106ccd <vector102>:
.globl vector102
vector102:
  pushl $0
80106ccd:	6a 00                	push   $0x0
  pushl $102
80106ccf:	6a 66                	push   $0x66
  jmp alltraps
80106cd1:	e9 79 f7 ff ff       	jmp    8010644f <alltraps>

80106cd6 <vector103>:
.globl vector103
vector103:
  pushl $0
80106cd6:	6a 00                	push   $0x0
  pushl $103
80106cd8:	6a 67                	push   $0x67
  jmp alltraps
80106cda:	e9 70 f7 ff ff       	jmp    8010644f <alltraps>

80106cdf <vector104>:
.globl vector104
vector104:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $104
80106ce1:	6a 68                	push   $0x68
  jmp alltraps
80106ce3:	e9 67 f7 ff ff       	jmp    8010644f <alltraps>

80106ce8 <vector105>:
.globl vector105
vector105:
  pushl $0
80106ce8:	6a 00                	push   $0x0
  pushl $105
80106cea:	6a 69                	push   $0x69
  jmp alltraps
80106cec:	e9 5e f7 ff ff       	jmp    8010644f <alltraps>

80106cf1 <vector106>:
.globl vector106
vector106:
  pushl $0
80106cf1:	6a 00                	push   $0x0
  pushl $106
80106cf3:	6a 6a                	push   $0x6a
  jmp alltraps
80106cf5:	e9 55 f7 ff ff       	jmp    8010644f <alltraps>

80106cfa <vector107>:
.globl vector107
vector107:
  pushl $0
80106cfa:	6a 00                	push   $0x0
  pushl $107
80106cfc:	6a 6b                	push   $0x6b
  jmp alltraps
80106cfe:	e9 4c f7 ff ff       	jmp    8010644f <alltraps>

80106d03 <vector108>:
.globl vector108
vector108:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $108
80106d05:	6a 6c                	push   $0x6c
  jmp alltraps
80106d07:	e9 43 f7 ff ff       	jmp    8010644f <alltraps>

80106d0c <vector109>:
.globl vector109
vector109:
  pushl $0
80106d0c:	6a 00                	push   $0x0
  pushl $109
80106d0e:	6a 6d                	push   $0x6d
  jmp alltraps
80106d10:	e9 3a f7 ff ff       	jmp    8010644f <alltraps>

80106d15 <vector110>:
.globl vector110
vector110:
  pushl $0
80106d15:	6a 00                	push   $0x0
  pushl $110
80106d17:	6a 6e                	push   $0x6e
  jmp alltraps
80106d19:	e9 31 f7 ff ff       	jmp    8010644f <alltraps>

80106d1e <vector111>:
.globl vector111
vector111:
  pushl $0
80106d1e:	6a 00                	push   $0x0
  pushl $111
80106d20:	6a 6f                	push   $0x6f
  jmp alltraps
80106d22:	e9 28 f7 ff ff       	jmp    8010644f <alltraps>

80106d27 <vector112>:
.globl vector112
vector112:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $112
80106d29:	6a 70                	push   $0x70
  jmp alltraps
80106d2b:	e9 1f f7 ff ff       	jmp    8010644f <alltraps>

80106d30 <vector113>:
.globl vector113
vector113:
  pushl $0
80106d30:	6a 00                	push   $0x0
  pushl $113
80106d32:	6a 71                	push   $0x71
  jmp alltraps
80106d34:	e9 16 f7 ff ff       	jmp    8010644f <alltraps>

80106d39 <vector114>:
.globl vector114
vector114:
  pushl $0
80106d39:	6a 00                	push   $0x0
  pushl $114
80106d3b:	6a 72                	push   $0x72
  jmp alltraps
80106d3d:	e9 0d f7 ff ff       	jmp    8010644f <alltraps>

80106d42 <vector115>:
.globl vector115
vector115:
  pushl $0
80106d42:	6a 00                	push   $0x0
  pushl $115
80106d44:	6a 73                	push   $0x73
  jmp alltraps
80106d46:	e9 04 f7 ff ff       	jmp    8010644f <alltraps>

80106d4b <vector116>:
.globl vector116
vector116:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $116
80106d4d:	6a 74                	push   $0x74
  jmp alltraps
80106d4f:	e9 fb f6 ff ff       	jmp    8010644f <alltraps>

80106d54 <vector117>:
.globl vector117
vector117:
  pushl $0
80106d54:	6a 00                	push   $0x0
  pushl $117
80106d56:	6a 75                	push   $0x75
  jmp alltraps
80106d58:	e9 f2 f6 ff ff       	jmp    8010644f <alltraps>

80106d5d <vector118>:
.globl vector118
vector118:
  pushl $0
80106d5d:	6a 00                	push   $0x0
  pushl $118
80106d5f:	6a 76                	push   $0x76
  jmp alltraps
80106d61:	e9 e9 f6 ff ff       	jmp    8010644f <alltraps>

80106d66 <vector119>:
.globl vector119
vector119:
  pushl $0
80106d66:	6a 00                	push   $0x0
  pushl $119
80106d68:	6a 77                	push   $0x77
  jmp alltraps
80106d6a:	e9 e0 f6 ff ff       	jmp    8010644f <alltraps>

80106d6f <vector120>:
.globl vector120
vector120:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $120
80106d71:	6a 78                	push   $0x78
  jmp alltraps
80106d73:	e9 d7 f6 ff ff       	jmp    8010644f <alltraps>

80106d78 <vector121>:
.globl vector121
vector121:
  pushl $0
80106d78:	6a 00                	push   $0x0
  pushl $121
80106d7a:	6a 79                	push   $0x79
  jmp alltraps
80106d7c:	e9 ce f6 ff ff       	jmp    8010644f <alltraps>

80106d81 <vector122>:
.globl vector122
vector122:
  pushl $0
80106d81:	6a 00                	push   $0x0
  pushl $122
80106d83:	6a 7a                	push   $0x7a
  jmp alltraps
80106d85:	e9 c5 f6 ff ff       	jmp    8010644f <alltraps>

80106d8a <vector123>:
.globl vector123
vector123:
  pushl $0
80106d8a:	6a 00                	push   $0x0
  pushl $123
80106d8c:	6a 7b                	push   $0x7b
  jmp alltraps
80106d8e:	e9 bc f6 ff ff       	jmp    8010644f <alltraps>

80106d93 <vector124>:
.globl vector124
vector124:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $124
80106d95:	6a 7c                	push   $0x7c
  jmp alltraps
80106d97:	e9 b3 f6 ff ff       	jmp    8010644f <alltraps>

80106d9c <vector125>:
.globl vector125
vector125:
  pushl $0
80106d9c:	6a 00                	push   $0x0
  pushl $125
80106d9e:	6a 7d                	push   $0x7d
  jmp alltraps
80106da0:	e9 aa f6 ff ff       	jmp    8010644f <alltraps>

80106da5 <vector126>:
.globl vector126
vector126:
  pushl $0
80106da5:	6a 00                	push   $0x0
  pushl $126
80106da7:	6a 7e                	push   $0x7e
  jmp alltraps
80106da9:	e9 a1 f6 ff ff       	jmp    8010644f <alltraps>

80106dae <vector127>:
.globl vector127
vector127:
  pushl $0
80106dae:	6a 00                	push   $0x0
  pushl $127
80106db0:	6a 7f                	push   $0x7f
  jmp alltraps
80106db2:	e9 98 f6 ff ff       	jmp    8010644f <alltraps>

80106db7 <vector128>:
.globl vector128
vector128:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $128
80106db9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106dbe:	e9 8c f6 ff ff       	jmp    8010644f <alltraps>

80106dc3 <vector129>:
.globl vector129
vector129:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $129
80106dc5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106dca:	e9 80 f6 ff ff       	jmp    8010644f <alltraps>

80106dcf <vector130>:
.globl vector130
vector130:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $130
80106dd1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106dd6:	e9 74 f6 ff ff       	jmp    8010644f <alltraps>

80106ddb <vector131>:
.globl vector131
vector131:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $131
80106ddd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106de2:	e9 68 f6 ff ff       	jmp    8010644f <alltraps>

80106de7 <vector132>:
.globl vector132
vector132:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $132
80106de9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106dee:	e9 5c f6 ff ff       	jmp    8010644f <alltraps>

80106df3 <vector133>:
.globl vector133
vector133:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $133
80106df5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106dfa:	e9 50 f6 ff ff       	jmp    8010644f <alltraps>

80106dff <vector134>:
.globl vector134
vector134:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $134
80106e01:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106e06:	e9 44 f6 ff ff       	jmp    8010644f <alltraps>

80106e0b <vector135>:
.globl vector135
vector135:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $135
80106e0d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106e12:	e9 38 f6 ff ff       	jmp    8010644f <alltraps>

80106e17 <vector136>:
.globl vector136
vector136:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $136
80106e19:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106e1e:	e9 2c f6 ff ff       	jmp    8010644f <alltraps>

80106e23 <vector137>:
.globl vector137
vector137:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $137
80106e25:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106e2a:	e9 20 f6 ff ff       	jmp    8010644f <alltraps>

80106e2f <vector138>:
.globl vector138
vector138:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $138
80106e31:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106e36:	e9 14 f6 ff ff       	jmp    8010644f <alltraps>

80106e3b <vector139>:
.globl vector139
vector139:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $139
80106e3d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106e42:	e9 08 f6 ff ff       	jmp    8010644f <alltraps>

80106e47 <vector140>:
.globl vector140
vector140:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $140
80106e49:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106e4e:	e9 fc f5 ff ff       	jmp    8010644f <alltraps>

80106e53 <vector141>:
.globl vector141
vector141:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $141
80106e55:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106e5a:	e9 f0 f5 ff ff       	jmp    8010644f <alltraps>

80106e5f <vector142>:
.globl vector142
vector142:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $142
80106e61:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106e66:	e9 e4 f5 ff ff       	jmp    8010644f <alltraps>

80106e6b <vector143>:
.globl vector143
vector143:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $143
80106e6d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106e72:	e9 d8 f5 ff ff       	jmp    8010644f <alltraps>

80106e77 <vector144>:
.globl vector144
vector144:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $144
80106e79:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106e7e:	e9 cc f5 ff ff       	jmp    8010644f <alltraps>

80106e83 <vector145>:
.globl vector145
vector145:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $145
80106e85:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106e8a:	e9 c0 f5 ff ff       	jmp    8010644f <alltraps>

80106e8f <vector146>:
.globl vector146
vector146:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $146
80106e91:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106e96:	e9 b4 f5 ff ff       	jmp    8010644f <alltraps>

80106e9b <vector147>:
.globl vector147
vector147:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $147
80106e9d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106ea2:	e9 a8 f5 ff ff       	jmp    8010644f <alltraps>

80106ea7 <vector148>:
.globl vector148
vector148:
  pushl $0
80106ea7:	6a 00                	push   $0x0
  pushl $148
80106ea9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106eae:	e9 9c f5 ff ff       	jmp    8010644f <alltraps>

80106eb3 <vector149>:
.globl vector149
vector149:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $149
80106eb5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106eba:	e9 90 f5 ff ff       	jmp    8010644f <alltraps>

80106ebf <vector150>:
.globl vector150
vector150:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $150
80106ec1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106ec6:	e9 84 f5 ff ff       	jmp    8010644f <alltraps>

80106ecb <vector151>:
.globl vector151
vector151:
  pushl $0
80106ecb:	6a 00                	push   $0x0
  pushl $151
80106ecd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106ed2:	e9 78 f5 ff ff       	jmp    8010644f <alltraps>

80106ed7 <vector152>:
.globl vector152
vector152:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $152
80106ed9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106ede:	e9 6c f5 ff ff       	jmp    8010644f <alltraps>

80106ee3 <vector153>:
.globl vector153
vector153:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $153
80106ee5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106eea:	e9 60 f5 ff ff       	jmp    8010644f <alltraps>

80106eef <vector154>:
.globl vector154
vector154:
  pushl $0
80106eef:	6a 00                	push   $0x0
  pushl $154
80106ef1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106ef6:	e9 54 f5 ff ff       	jmp    8010644f <alltraps>

80106efb <vector155>:
.globl vector155
vector155:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $155
80106efd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106f02:	e9 48 f5 ff ff       	jmp    8010644f <alltraps>

80106f07 <vector156>:
.globl vector156
vector156:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $156
80106f09:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106f0e:	e9 3c f5 ff ff       	jmp    8010644f <alltraps>

80106f13 <vector157>:
.globl vector157
vector157:
  pushl $0
80106f13:	6a 00                	push   $0x0
  pushl $157
80106f15:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106f1a:	e9 30 f5 ff ff       	jmp    8010644f <alltraps>

80106f1f <vector158>:
.globl vector158
vector158:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $158
80106f21:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106f26:	e9 24 f5 ff ff       	jmp    8010644f <alltraps>

80106f2b <vector159>:
.globl vector159
vector159:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $159
80106f2d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106f32:	e9 18 f5 ff ff       	jmp    8010644f <alltraps>

80106f37 <vector160>:
.globl vector160
vector160:
  pushl $0
80106f37:	6a 00                	push   $0x0
  pushl $160
80106f39:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106f3e:	e9 0c f5 ff ff       	jmp    8010644f <alltraps>

80106f43 <vector161>:
.globl vector161
vector161:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $161
80106f45:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106f4a:	e9 00 f5 ff ff       	jmp    8010644f <alltraps>

80106f4f <vector162>:
.globl vector162
vector162:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $162
80106f51:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106f56:	e9 f4 f4 ff ff       	jmp    8010644f <alltraps>

80106f5b <vector163>:
.globl vector163
vector163:
  pushl $0
80106f5b:	6a 00                	push   $0x0
  pushl $163
80106f5d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106f62:	e9 e8 f4 ff ff       	jmp    8010644f <alltraps>

80106f67 <vector164>:
.globl vector164
vector164:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $164
80106f69:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106f6e:	e9 dc f4 ff ff       	jmp    8010644f <alltraps>

80106f73 <vector165>:
.globl vector165
vector165:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $165
80106f75:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106f7a:	e9 d0 f4 ff ff       	jmp    8010644f <alltraps>

80106f7f <vector166>:
.globl vector166
vector166:
  pushl $0
80106f7f:	6a 00                	push   $0x0
  pushl $166
80106f81:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106f86:	e9 c4 f4 ff ff       	jmp    8010644f <alltraps>

80106f8b <vector167>:
.globl vector167
vector167:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $167
80106f8d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106f92:	e9 b8 f4 ff ff       	jmp    8010644f <alltraps>

80106f97 <vector168>:
.globl vector168
vector168:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $168
80106f99:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106f9e:	e9 ac f4 ff ff       	jmp    8010644f <alltraps>

80106fa3 <vector169>:
.globl vector169
vector169:
  pushl $0
80106fa3:	6a 00                	push   $0x0
  pushl $169
80106fa5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106faa:	e9 a0 f4 ff ff       	jmp    8010644f <alltraps>

80106faf <vector170>:
.globl vector170
vector170:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $170
80106fb1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106fb6:	e9 94 f4 ff ff       	jmp    8010644f <alltraps>

80106fbb <vector171>:
.globl vector171
vector171:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $171
80106fbd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106fc2:	e9 88 f4 ff ff       	jmp    8010644f <alltraps>

80106fc7 <vector172>:
.globl vector172
vector172:
  pushl $0
80106fc7:	6a 00                	push   $0x0
  pushl $172
80106fc9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106fce:	e9 7c f4 ff ff       	jmp    8010644f <alltraps>

80106fd3 <vector173>:
.globl vector173
vector173:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $173
80106fd5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106fda:	e9 70 f4 ff ff       	jmp    8010644f <alltraps>

80106fdf <vector174>:
.globl vector174
vector174:
  pushl $0
80106fdf:	6a 00                	push   $0x0
  pushl $174
80106fe1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106fe6:	e9 64 f4 ff ff       	jmp    8010644f <alltraps>

80106feb <vector175>:
.globl vector175
vector175:
  pushl $0
80106feb:	6a 00                	push   $0x0
  pushl $175
80106fed:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106ff2:	e9 58 f4 ff ff       	jmp    8010644f <alltraps>

80106ff7 <vector176>:
.globl vector176
vector176:
  pushl $0
80106ff7:	6a 00                	push   $0x0
  pushl $176
80106ff9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106ffe:	e9 4c f4 ff ff       	jmp    8010644f <alltraps>

80107003 <vector177>:
.globl vector177
vector177:
  pushl $0
80107003:	6a 00                	push   $0x0
  pushl $177
80107005:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010700a:	e9 40 f4 ff ff       	jmp    8010644f <alltraps>

8010700f <vector178>:
.globl vector178
vector178:
  pushl $0
8010700f:	6a 00                	push   $0x0
  pushl $178
80107011:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107016:	e9 34 f4 ff ff       	jmp    8010644f <alltraps>

8010701b <vector179>:
.globl vector179
vector179:
  pushl $0
8010701b:	6a 00                	push   $0x0
  pushl $179
8010701d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107022:	e9 28 f4 ff ff       	jmp    8010644f <alltraps>

80107027 <vector180>:
.globl vector180
vector180:
  pushl $0
80107027:	6a 00                	push   $0x0
  pushl $180
80107029:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010702e:	e9 1c f4 ff ff       	jmp    8010644f <alltraps>

80107033 <vector181>:
.globl vector181
vector181:
  pushl $0
80107033:	6a 00                	push   $0x0
  pushl $181
80107035:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010703a:	e9 10 f4 ff ff       	jmp    8010644f <alltraps>

8010703f <vector182>:
.globl vector182
vector182:
  pushl $0
8010703f:	6a 00                	push   $0x0
  pushl $182
80107041:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107046:	e9 04 f4 ff ff       	jmp    8010644f <alltraps>

8010704b <vector183>:
.globl vector183
vector183:
  pushl $0
8010704b:	6a 00                	push   $0x0
  pushl $183
8010704d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107052:	e9 f8 f3 ff ff       	jmp    8010644f <alltraps>

80107057 <vector184>:
.globl vector184
vector184:
  pushl $0
80107057:	6a 00                	push   $0x0
  pushl $184
80107059:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010705e:	e9 ec f3 ff ff       	jmp    8010644f <alltraps>

80107063 <vector185>:
.globl vector185
vector185:
  pushl $0
80107063:	6a 00                	push   $0x0
  pushl $185
80107065:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010706a:	e9 e0 f3 ff ff       	jmp    8010644f <alltraps>

8010706f <vector186>:
.globl vector186
vector186:
  pushl $0
8010706f:	6a 00                	push   $0x0
  pushl $186
80107071:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107076:	e9 d4 f3 ff ff       	jmp    8010644f <alltraps>

8010707b <vector187>:
.globl vector187
vector187:
  pushl $0
8010707b:	6a 00                	push   $0x0
  pushl $187
8010707d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107082:	e9 c8 f3 ff ff       	jmp    8010644f <alltraps>

80107087 <vector188>:
.globl vector188
vector188:
  pushl $0
80107087:	6a 00                	push   $0x0
  pushl $188
80107089:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010708e:	e9 bc f3 ff ff       	jmp    8010644f <alltraps>

80107093 <vector189>:
.globl vector189
vector189:
  pushl $0
80107093:	6a 00                	push   $0x0
  pushl $189
80107095:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010709a:	e9 b0 f3 ff ff       	jmp    8010644f <alltraps>

8010709f <vector190>:
.globl vector190
vector190:
  pushl $0
8010709f:	6a 00                	push   $0x0
  pushl $190
801070a1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801070a6:	e9 a4 f3 ff ff       	jmp    8010644f <alltraps>

801070ab <vector191>:
.globl vector191
vector191:
  pushl $0
801070ab:	6a 00                	push   $0x0
  pushl $191
801070ad:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801070b2:	e9 98 f3 ff ff       	jmp    8010644f <alltraps>

801070b7 <vector192>:
.globl vector192
vector192:
  pushl $0
801070b7:	6a 00                	push   $0x0
  pushl $192
801070b9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801070be:	e9 8c f3 ff ff       	jmp    8010644f <alltraps>

801070c3 <vector193>:
.globl vector193
vector193:
  pushl $0
801070c3:	6a 00                	push   $0x0
  pushl $193
801070c5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801070ca:	e9 80 f3 ff ff       	jmp    8010644f <alltraps>

801070cf <vector194>:
.globl vector194
vector194:
  pushl $0
801070cf:	6a 00                	push   $0x0
  pushl $194
801070d1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801070d6:	e9 74 f3 ff ff       	jmp    8010644f <alltraps>

801070db <vector195>:
.globl vector195
vector195:
  pushl $0
801070db:	6a 00                	push   $0x0
  pushl $195
801070dd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801070e2:	e9 68 f3 ff ff       	jmp    8010644f <alltraps>

801070e7 <vector196>:
.globl vector196
vector196:
  pushl $0
801070e7:	6a 00                	push   $0x0
  pushl $196
801070e9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801070ee:	e9 5c f3 ff ff       	jmp    8010644f <alltraps>

801070f3 <vector197>:
.globl vector197
vector197:
  pushl $0
801070f3:	6a 00                	push   $0x0
  pushl $197
801070f5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801070fa:	e9 50 f3 ff ff       	jmp    8010644f <alltraps>

801070ff <vector198>:
.globl vector198
vector198:
  pushl $0
801070ff:	6a 00                	push   $0x0
  pushl $198
80107101:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107106:	e9 44 f3 ff ff       	jmp    8010644f <alltraps>

8010710b <vector199>:
.globl vector199
vector199:
  pushl $0
8010710b:	6a 00                	push   $0x0
  pushl $199
8010710d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107112:	e9 38 f3 ff ff       	jmp    8010644f <alltraps>

80107117 <vector200>:
.globl vector200
vector200:
  pushl $0
80107117:	6a 00                	push   $0x0
  pushl $200
80107119:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010711e:	e9 2c f3 ff ff       	jmp    8010644f <alltraps>

80107123 <vector201>:
.globl vector201
vector201:
  pushl $0
80107123:	6a 00                	push   $0x0
  pushl $201
80107125:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010712a:	e9 20 f3 ff ff       	jmp    8010644f <alltraps>

8010712f <vector202>:
.globl vector202
vector202:
  pushl $0
8010712f:	6a 00                	push   $0x0
  pushl $202
80107131:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107136:	e9 14 f3 ff ff       	jmp    8010644f <alltraps>

8010713b <vector203>:
.globl vector203
vector203:
  pushl $0
8010713b:	6a 00                	push   $0x0
  pushl $203
8010713d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107142:	e9 08 f3 ff ff       	jmp    8010644f <alltraps>

80107147 <vector204>:
.globl vector204
vector204:
  pushl $0
80107147:	6a 00                	push   $0x0
  pushl $204
80107149:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010714e:	e9 fc f2 ff ff       	jmp    8010644f <alltraps>

80107153 <vector205>:
.globl vector205
vector205:
  pushl $0
80107153:	6a 00                	push   $0x0
  pushl $205
80107155:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010715a:	e9 f0 f2 ff ff       	jmp    8010644f <alltraps>

8010715f <vector206>:
.globl vector206
vector206:
  pushl $0
8010715f:	6a 00                	push   $0x0
  pushl $206
80107161:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107166:	e9 e4 f2 ff ff       	jmp    8010644f <alltraps>

8010716b <vector207>:
.globl vector207
vector207:
  pushl $0
8010716b:	6a 00                	push   $0x0
  pushl $207
8010716d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107172:	e9 d8 f2 ff ff       	jmp    8010644f <alltraps>

80107177 <vector208>:
.globl vector208
vector208:
  pushl $0
80107177:	6a 00                	push   $0x0
  pushl $208
80107179:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010717e:	e9 cc f2 ff ff       	jmp    8010644f <alltraps>

80107183 <vector209>:
.globl vector209
vector209:
  pushl $0
80107183:	6a 00                	push   $0x0
  pushl $209
80107185:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010718a:	e9 c0 f2 ff ff       	jmp    8010644f <alltraps>

8010718f <vector210>:
.globl vector210
vector210:
  pushl $0
8010718f:	6a 00                	push   $0x0
  pushl $210
80107191:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107196:	e9 b4 f2 ff ff       	jmp    8010644f <alltraps>

8010719b <vector211>:
.globl vector211
vector211:
  pushl $0
8010719b:	6a 00                	push   $0x0
  pushl $211
8010719d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801071a2:	e9 a8 f2 ff ff       	jmp    8010644f <alltraps>

801071a7 <vector212>:
.globl vector212
vector212:
  pushl $0
801071a7:	6a 00                	push   $0x0
  pushl $212
801071a9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801071ae:	e9 9c f2 ff ff       	jmp    8010644f <alltraps>

801071b3 <vector213>:
.globl vector213
vector213:
  pushl $0
801071b3:	6a 00                	push   $0x0
  pushl $213
801071b5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801071ba:	e9 90 f2 ff ff       	jmp    8010644f <alltraps>

801071bf <vector214>:
.globl vector214
vector214:
  pushl $0
801071bf:	6a 00                	push   $0x0
  pushl $214
801071c1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801071c6:	e9 84 f2 ff ff       	jmp    8010644f <alltraps>

801071cb <vector215>:
.globl vector215
vector215:
  pushl $0
801071cb:	6a 00                	push   $0x0
  pushl $215
801071cd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801071d2:	e9 78 f2 ff ff       	jmp    8010644f <alltraps>

801071d7 <vector216>:
.globl vector216
vector216:
  pushl $0
801071d7:	6a 00                	push   $0x0
  pushl $216
801071d9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801071de:	e9 6c f2 ff ff       	jmp    8010644f <alltraps>

801071e3 <vector217>:
.globl vector217
vector217:
  pushl $0
801071e3:	6a 00                	push   $0x0
  pushl $217
801071e5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801071ea:	e9 60 f2 ff ff       	jmp    8010644f <alltraps>

801071ef <vector218>:
.globl vector218
vector218:
  pushl $0
801071ef:	6a 00                	push   $0x0
  pushl $218
801071f1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801071f6:	e9 54 f2 ff ff       	jmp    8010644f <alltraps>

801071fb <vector219>:
.globl vector219
vector219:
  pushl $0
801071fb:	6a 00                	push   $0x0
  pushl $219
801071fd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107202:	e9 48 f2 ff ff       	jmp    8010644f <alltraps>

80107207 <vector220>:
.globl vector220
vector220:
  pushl $0
80107207:	6a 00                	push   $0x0
  pushl $220
80107209:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010720e:	e9 3c f2 ff ff       	jmp    8010644f <alltraps>

80107213 <vector221>:
.globl vector221
vector221:
  pushl $0
80107213:	6a 00                	push   $0x0
  pushl $221
80107215:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010721a:	e9 30 f2 ff ff       	jmp    8010644f <alltraps>

8010721f <vector222>:
.globl vector222
vector222:
  pushl $0
8010721f:	6a 00                	push   $0x0
  pushl $222
80107221:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107226:	e9 24 f2 ff ff       	jmp    8010644f <alltraps>

8010722b <vector223>:
.globl vector223
vector223:
  pushl $0
8010722b:	6a 00                	push   $0x0
  pushl $223
8010722d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107232:	e9 18 f2 ff ff       	jmp    8010644f <alltraps>

80107237 <vector224>:
.globl vector224
vector224:
  pushl $0
80107237:	6a 00                	push   $0x0
  pushl $224
80107239:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010723e:	e9 0c f2 ff ff       	jmp    8010644f <alltraps>

80107243 <vector225>:
.globl vector225
vector225:
  pushl $0
80107243:	6a 00                	push   $0x0
  pushl $225
80107245:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010724a:	e9 00 f2 ff ff       	jmp    8010644f <alltraps>

8010724f <vector226>:
.globl vector226
vector226:
  pushl $0
8010724f:	6a 00                	push   $0x0
  pushl $226
80107251:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107256:	e9 f4 f1 ff ff       	jmp    8010644f <alltraps>

8010725b <vector227>:
.globl vector227
vector227:
  pushl $0
8010725b:	6a 00                	push   $0x0
  pushl $227
8010725d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107262:	e9 e8 f1 ff ff       	jmp    8010644f <alltraps>

80107267 <vector228>:
.globl vector228
vector228:
  pushl $0
80107267:	6a 00                	push   $0x0
  pushl $228
80107269:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010726e:	e9 dc f1 ff ff       	jmp    8010644f <alltraps>

80107273 <vector229>:
.globl vector229
vector229:
  pushl $0
80107273:	6a 00                	push   $0x0
  pushl $229
80107275:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010727a:	e9 d0 f1 ff ff       	jmp    8010644f <alltraps>

8010727f <vector230>:
.globl vector230
vector230:
  pushl $0
8010727f:	6a 00                	push   $0x0
  pushl $230
80107281:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107286:	e9 c4 f1 ff ff       	jmp    8010644f <alltraps>

8010728b <vector231>:
.globl vector231
vector231:
  pushl $0
8010728b:	6a 00                	push   $0x0
  pushl $231
8010728d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107292:	e9 b8 f1 ff ff       	jmp    8010644f <alltraps>

80107297 <vector232>:
.globl vector232
vector232:
  pushl $0
80107297:	6a 00                	push   $0x0
  pushl $232
80107299:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010729e:	e9 ac f1 ff ff       	jmp    8010644f <alltraps>

801072a3 <vector233>:
.globl vector233
vector233:
  pushl $0
801072a3:	6a 00                	push   $0x0
  pushl $233
801072a5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801072aa:	e9 a0 f1 ff ff       	jmp    8010644f <alltraps>

801072af <vector234>:
.globl vector234
vector234:
  pushl $0
801072af:	6a 00                	push   $0x0
  pushl $234
801072b1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801072b6:	e9 94 f1 ff ff       	jmp    8010644f <alltraps>

801072bb <vector235>:
.globl vector235
vector235:
  pushl $0
801072bb:	6a 00                	push   $0x0
  pushl $235
801072bd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801072c2:	e9 88 f1 ff ff       	jmp    8010644f <alltraps>

801072c7 <vector236>:
.globl vector236
vector236:
  pushl $0
801072c7:	6a 00                	push   $0x0
  pushl $236
801072c9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801072ce:	e9 7c f1 ff ff       	jmp    8010644f <alltraps>

801072d3 <vector237>:
.globl vector237
vector237:
  pushl $0
801072d3:	6a 00                	push   $0x0
  pushl $237
801072d5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801072da:	e9 70 f1 ff ff       	jmp    8010644f <alltraps>

801072df <vector238>:
.globl vector238
vector238:
  pushl $0
801072df:	6a 00                	push   $0x0
  pushl $238
801072e1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801072e6:	e9 64 f1 ff ff       	jmp    8010644f <alltraps>

801072eb <vector239>:
.globl vector239
vector239:
  pushl $0
801072eb:	6a 00                	push   $0x0
  pushl $239
801072ed:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801072f2:	e9 58 f1 ff ff       	jmp    8010644f <alltraps>

801072f7 <vector240>:
.globl vector240
vector240:
  pushl $0
801072f7:	6a 00                	push   $0x0
  pushl $240
801072f9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801072fe:	e9 4c f1 ff ff       	jmp    8010644f <alltraps>

80107303 <vector241>:
.globl vector241
vector241:
  pushl $0
80107303:	6a 00                	push   $0x0
  pushl $241
80107305:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010730a:	e9 40 f1 ff ff       	jmp    8010644f <alltraps>

8010730f <vector242>:
.globl vector242
vector242:
  pushl $0
8010730f:	6a 00                	push   $0x0
  pushl $242
80107311:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107316:	e9 34 f1 ff ff       	jmp    8010644f <alltraps>

8010731b <vector243>:
.globl vector243
vector243:
  pushl $0
8010731b:	6a 00                	push   $0x0
  pushl $243
8010731d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107322:	e9 28 f1 ff ff       	jmp    8010644f <alltraps>

80107327 <vector244>:
.globl vector244
vector244:
  pushl $0
80107327:	6a 00                	push   $0x0
  pushl $244
80107329:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010732e:	e9 1c f1 ff ff       	jmp    8010644f <alltraps>

80107333 <vector245>:
.globl vector245
vector245:
  pushl $0
80107333:	6a 00                	push   $0x0
  pushl $245
80107335:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010733a:	e9 10 f1 ff ff       	jmp    8010644f <alltraps>

8010733f <vector246>:
.globl vector246
vector246:
  pushl $0
8010733f:	6a 00                	push   $0x0
  pushl $246
80107341:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107346:	e9 04 f1 ff ff       	jmp    8010644f <alltraps>

8010734b <vector247>:
.globl vector247
vector247:
  pushl $0
8010734b:	6a 00                	push   $0x0
  pushl $247
8010734d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107352:	e9 f8 f0 ff ff       	jmp    8010644f <alltraps>

80107357 <vector248>:
.globl vector248
vector248:
  pushl $0
80107357:	6a 00                	push   $0x0
  pushl $248
80107359:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010735e:	e9 ec f0 ff ff       	jmp    8010644f <alltraps>

80107363 <vector249>:
.globl vector249
vector249:
  pushl $0
80107363:	6a 00                	push   $0x0
  pushl $249
80107365:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010736a:	e9 e0 f0 ff ff       	jmp    8010644f <alltraps>

8010736f <vector250>:
.globl vector250
vector250:
  pushl $0
8010736f:	6a 00                	push   $0x0
  pushl $250
80107371:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107376:	e9 d4 f0 ff ff       	jmp    8010644f <alltraps>

8010737b <vector251>:
.globl vector251
vector251:
  pushl $0
8010737b:	6a 00                	push   $0x0
  pushl $251
8010737d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107382:	e9 c8 f0 ff ff       	jmp    8010644f <alltraps>

80107387 <vector252>:
.globl vector252
vector252:
  pushl $0
80107387:	6a 00                	push   $0x0
  pushl $252
80107389:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010738e:	e9 bc f0 ff ff       	jmp    8010644f <alltraps>

80107393 <vector253>:
.globl vector253
vector253:
  pushl $0
80107393:	6a 00                	push   $0x0
  pushl $253
80107395:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010739a:	e9 b0 f0 ff ff       	jmp    8010644f <alltraps>

8010739f <vector254>:
.globl vector254
vector254:
  pushl $0
8010739f:	6a 00                	push   $0x0
  pushl $254
801073a1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801073a6:	e9 a4 f0 ff ff       	jmp    8010644f <alltraps>

801073ab <vector255>:
.globl vector255
vector255:
  pushl $0
801073ab:	6a 00                	push   $0x0
  pushl $255
801073ad:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801073b2:	e9 98 f0 ff ff       	jmp    8010644f <alltraps>
801073b7:	66 90                	xchg   %ax,%ax
801073b9:	66 90                	xchg   %ax,%ax
801073bb:	66 90                	xchg   %ax,%ax
801073bd:	66 90                	xchg   %ax,%ax
801073bf:	90                   	nop

801073c0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801073c0:	55                   	push   %ebp
801073c1:	89 e5                	mov    %esp,%ebp
801073c3:	57                   	push   %edi
801073c4:	56                   	push   %esi
801073c5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801073c6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
801073cc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801073d2:	83 ec 1c             	sub    $0x1c,%esp
801073d5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801073d8:	39 d3                	cmp    %edx,%ebx
801073da:	73 49                	jae    80107425 <deallocuvm.part.0+0x65>
801073dc:	89 c7                	mov    %eax,%edi
801073de:	eb 0c                	jmp    801073ec <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801073e0:	83 c0 01             	add    $0x1,%eax
801073e3:	c1 e0 16             	shl    $0x16,%eax
801073e6:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
801073e8:	39 da                	cmp    %ebx,%edx
801073ea:	76 39                	jbe    80107425 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
801073ec:	89 d8                	mov    %ebx,%eax
801073ee:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801073f1:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
801073f4:	f6 c1 01             	test   $0x1,%cl
801073f7:	74 e7                	je     801073e0 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
801073f9:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801073fb:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107401:	c1 ee 0a             	shr    $0xa,%esi
80107404:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
8010740a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80107411:	85 f6                	test   %esi,%esi
80107413:	74 cb                	je     801073e0 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80107415:	8b 06                	mov    (%esi),%eax
80107417:	a8 01                	test   $0x1,%al
80107419:	75 15                	jne    80107430 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
8010741b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107421:	39 da                	cmp    %ebx,%edx
80107423:	77 c7                	ja     801073ec <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107425:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107428:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010742b:	5b                   	pop    %ebx
8010742c:	5e                   	pop    %esi
8010742d:	5f                   	pop    %edi
8010742e:	5d                   	pop    %ebp
8010742f:	c3                   	ret    
      if(pa == 0)
80107430:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107435:	74 25                	je     8010745c <deallocuvm.part.0+0x9c>
      kfree(v);
80107437:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010743a:	05 00 00 00 80       	add    $0x80000000,%eax
8010743f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107442:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80107448:	50                   	push   %eax
80107449:	e8 e2 b0 ff ff       	call   80102530 <kfree>
      *pte = 0;
8010744e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80107454:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107457:	83 c4 10             	add    $0x10,%esp
8010745a:	eb 8c                	jmp    801073e8 <deallocuvm.part.0+0x28>
        panic("kfree");
8010745c:	83 ec 0c             	sub    $0xc,%esp
8010745f:	68 2e 80 10 80       	push   $0x8010802e
80107464:	e8 17 8f ff ff       	call   80100380 <panic>
80107469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107470 <mappages>:
{
80107470:	55                   	push   %ebp
80107471:	89 e5                	mov    %esp,%ebp
80107473:	57                   	push   %edi
80107474:	56                   	push   %esi
80107475:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107476:	89 d3                	mov    %edx,%ebx
80107478:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010747e:	83 ec 1c             	sub    $0x1c,%esp
80107481:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107484:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107488:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010748d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107490:	8b 45 08             	mov    0x8(%ebp),%eax
80107493:	29 d8                	sub    %ebx,%eax
80107495:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107498:	eb 3d                	jmp    801074d7 <mappages+0x67>
8010749a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801074a0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801074a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801074a7:	c1 ea 0a             	shr    $0xa,%edx
801074aa:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801074b0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801074b7:	85 c0                	test   %eax,%eax
801074b9:	74 75                	je     80107530 <mappages+0xc0>
    if(*pte & PTE_P)
801074bb:	f6 00 01             	testb  $0x1,(%eax)
801074be:	0f 85 86 00 00 00    	jne    8010754a <mappages+0xda>
    *pte = pa | perm | PTE_P;
801074c4:	0b 75 0c             	or     0xc(%ebp),%esi
801074c7:	83 ce 01             	or     $0x1,%esi
801074ca:	89 30                	mov    %esi,(%eax)
    if(a == last)
801074cc:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
801074cf:	74 6f                	je     80107540 <mappages+0xd0>
    a += PGSIZE;
801074d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
801074d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
801074da:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801074dd:	8d 34 18             	lea    (%eax,%ebx,1),%esi
801074e0:	89 d8                	mov    %ebx,%eax
801074e2:	c1 e8 16             	shr    $0x16,%eax
801074e5:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
801074e8:	8b 07                	mov    (%edi),%eax
801074ea:	a8 01                	test   $0x1,%al
801074ec:	75 b2                	jne    801074a0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801074ee:	e8 fd b1 ff ff       	call   801026f0 <kalloc>
801074f3:	85 c0                	test   %eax,%eax
801074f5:	74 39                	je     80107530 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
801074f7:	83 ec 04             	sub    $0x4,%esp
801074fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
801074fd:	68 00 10 00 00       	push   $0x1000
80107502:	6a 00                	push   $0x0
80107504:	50                   	push   %eax
80107505:	e8 56 dd ff ff       	call   80105260 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010750a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
8010750d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107510:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80107516:	83 c8 07             	or     $0x7,%eax
80107519:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
8010751b:	89 d8                	mov    %ebx,%eax
8010751d:	c1 e8 0a             	shr    $0xa,%eax
80107520:	25 fc 0f 00 00       	and    $0xffc,%eax
80107525:	01 d0                	add    %edx,%eax
80107527:	eb 92                	jmp    801074bb <mappages+0x4b>
80107529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80107530:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107533:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107538:	5b                   	pop    %ebx
80107539:	5e                   	pop    %esi
8010753a:	5f                   	pop    %edi
8010753b:	5d                   	pop    %ebp
8010753c:	c3                   	ret    
8010753d:	8d 76 00             	lea    0x0(%esi),%esi
80107540:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107543:	31 c0                	xor    %eax,%eax
}
80107545:	5b                   	pop    %ebx
80107546:	5e                   	pop    %esi
80107547:	5f                   	pop    %edi
80107548:	5d                   	pop    %ebp
80107549:	c3                   	ret    
      panic("remap");
8010754a:	83 ec 0c             	sub    $0xc,%esp
8010754d:	68 70 88 10 80       	push   $0x80108870
80107552:	e8 29 8e ff ff       	call   80100380 <panic>
80107557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010755e:	66 90                	xchg   %ax,%ax

80107560 <seginit>:
{
80107560:	55                   	push   %ebp
80107561:	89 e5                	mov    %esp,%ebp
80107563:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107566:	e8 a5 c4 ff ff       	call   80103a10 <cpuid>
  pd[0] = size-1;
8010756b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107570:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107576:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010757a:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
80107581:	ff 00 00 
80107584:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
8010758b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010758e:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
80107595:	ff 00 00 
80107598:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
8010759f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801075a2:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
801075a9:	ff 00 00 
801075ac:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
801075b3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801075b6:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
801075bd:	ff 00 00 
801075c0:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
801075c7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801075ca:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
801075cf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801075d3:	c1 e8 10             	shr    $0x10,%eax
801075d6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801075da:	8d 45 f2             	lea    -0xe(%ebp),%eax
801075dd:	0f 01 10             	lgdtl  (%eax)
}
801075e0:	c9                   	leave  
801075e1:	c3                   	ret    
801075e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801075f0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801075f0:	a1 e4 63 11 80       	mov    0x801163e4,%eax
801075f5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801075fa:	0f 22 d8             	mov    %eax,%cr3
}
801075fd:	c3                   	ret    
801075fe:	66 90                	xchg   %ax,%ax

80107600 <switchuvm>:
{
80107600:	55                   	push   %ebp
80107601:	89 e5                	mov    %esp,%ebp
80107603:	57                   	push   %edi
80107604:	56                   	push   %esi
80107605:	53                   	push   %ebx
80107606:	83 ec 1c             	sub    $0x1c,%esp
80107609:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010760c:	85 f6                	test   %esi,%esi
8010760e:	0f 84 cb 00 00 00    	je     801076df <switchuvm+0xdf>
  if(p->kstack == 0)
80107614:	8b 46 08             	mov    0x8(%esi),%eax
80107617:	85 c0                	test   %eax,%eax
80107619:	0f 84 da 00 00 00    	je     801076f9 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010761f:	8b 46 04             	mov    0x4(%esi),%eax
80107622:	85 c0                	test   %eax,%eax
80107624:	0f 84 c2 00 00 00    	je     801076ec <switchuvm+0xec>
  pushcli();
8010762a:	e8 21 da ff ff       	call   80105050 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010762f:	e8 7c c3 ff ff       	call   801039b0 <mycpu>
80107634:	89 c3                	mov    %eax,%ebx
80107636:	e8 75 c3 ff ff       	call   801039b0 <mycpu>
8010763b:	89 c7                	mov    %eax,%edi
8010763d:	e8 6e c3 ff ff       	call   801039b0 <mycpu>
80107642:	83 c7 08             	add    $0x8,%edi
80107645:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107648:	e8 63 c3 ff ff       	call   801039b0 <mycpu>
8010764d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107650:	ba 67 00 00 00       	mov    $0x67,%edx
80107655:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010765c:	83 c0 08             	add    $0x8,%eax
8010765f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107666:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010766b:	83 c1 08             	add    $0x8,%ecx
8010766e:	c1 e8 18             	shr    $0x18,%eax
80107671:	c1 e9 10             	shr    $0x10,%ecx
80107674:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010767a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107680:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107685:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010768c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107691:	e8 1a c3 ff ff       	call   801039b0 <mycpu>
80107696:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010769d:	e8 0e c3 ff ff       	call   801039b0 <mycpu>
801076a2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801076a6:	8b 5e 08             	mov    0x8(%esi),%ebx
801076a9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801076af:	e8 fc c2 ff ff       	call   801039b0 <mycpu>
801076b4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801076b7:	e8 f4 c2 ff ff       	call   801039b0 <mycpu>
801076bc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801076c0:	b8 28 00 00 00       	mov    $0x28,%eax
801076c5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801076c8:	8b 46 04             	mov    0x4(%esi),%eax
801076cb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801076d0:	0f 22 d8             	mov    %eax,%cr3
}
801076d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076d6:	5b                   	pop    %ebx
801076d7:	5e                   	pop    %esi
801076d8:	5f                   	pop    %edi
801076d9:	5d                   	pop    %ebp
  popcli();
801076da:	e9 c1 d9 ff ff       	jmp    801050a0 <popcli>
    panic("switchuvm: no process");
801076df:	83 ec 0c             	sub    $0xc,%esp
801076e2:	68 76 88 10 80       	push   $0x80108876
801076e7:	e8 94 8c ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
801076ec:	83 ec 0c             	sub    $0xc,%esp
801076ef:	68 a1 88 10 80       	push   $0x801088a1
801076f4:	e8 87 8c ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
801076f9:	83 ec 0c             	sub    $0xc,%esp
801076fc:	68 8c 88 10 80       	push   $0x8010888c
80107701:	e8 7a 8c ff ff       	call   80100380 <panic>
80107706:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010770d:	8d 76 00             	lea    0x0(%esi),%esi

80107710 <inituvm>:
{
80107710:	55                   	push   %ebp
80107711:	89 e5                	mov    %esp,%ebp
80107713:	57                   	push   %edi
80107714:	56                   	push   %esi
80107715:	53                   	push   %ebx
80107716:	83 ec 1c             	sub    $0x1c,%esp
80107719:	8b 45 0c             	mov    0xc(%ebp),%eax
8010771c:	8b 75 10             	mov    0x10(%ebp),%esi
8010771f:	8b 7d 08             	mov    0x8(%ebp),%edi
80107722:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107725:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010772b:	77 4b                	ja     80107778 <inituvm+0x68>
  mem = kalloc();
8010772d:	e8 be af ff ff       	call   801026f0 <kalloc>
  memset(mem, 0, PGSIZE);
80107732:	83 ec 04             	sub    $0x4,%esp
80107735:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010773a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010773c:	6a 00                	push   $0x0
8010773e:	50                   	push   %eax
8010773f:	e8 1c db ff ff       	call   80105260 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107744:	58                   	pop    %eax
80107745:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010774b:	5a                   	pop    %edx
8010774c:	6a 06                	push   $0x6
8010774e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107753:	31 d2                	xor    %edx,%edx
80107755:	50                   	push   %eax
80107756:	89 f8                	mov    %edi,%eax
80107758:	e8 13 fd ff ff       	call   80107470 <mappages>
  memmove(mem, init, sz);
8010775d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107760:	89 75 10             	mov    %esi,0x10(%ebp)
80107763:	83 c4 10             	add    $0x10,%esp
80107766:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107769:	89 45 0c             	mov    %eax,0xc(%ebp)
}
8010776c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010776f:	5b                   	pop    %ebx
80107770:	5e                   	pop    %esi
80107771:	5f                   	pop    %edi
80107772:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107773:	e9 88 db ff ff       	jmp    80105300 <memmove>
    panic("inituvm: more than a page");
80107778:	83 ec 0c             	sub    $0xc,%esp
8010777b:	68 b5 88 10 80       	push   $0x801088b5
80107780:	e8 fb 8b ff ff       	call   80100380 <panic>
80107785:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010778c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107790 <loaduvm>:
{
80107790:	55                   	push   %ebp
80107791:	89 e5                	mov    %esp,%ebp
80107793:	57                   	push   %edi
80107794:	56                   	push   %esi
80107795:	53                   	push   %ebx
80107796:	83 ec 1c             	sub    $0x1c,%esp
80107799:	8b 45 0c             	mov    0xc(%ebp),%eax
8010779c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
8010779f:	a9 ff 0f 00 00       	test   $0xfff,%eax
801077a4:	0f 85 bb 00 00 00    	jne    80107865 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
801077aa:	01 f0                	add    %esi,%eax
801077ac:	89 f3                	mov    %esi,%ebx
801077ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801077b1:	8b 45 14             	mov    0x14(%ebp),%eax
801077b4:	01 f0                	add    %esi,%eax
801077b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801077b9:	85 f6                	test   %esi,%esi
801077bb:	0f 84 87 00 00 00    	je     80107848 <loaduvm+0xb8>
801077c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
801077c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
801077cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
801077ce:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
801077d0:	89 c2                	mov    %eax,%edx
801077d2:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
801077d5:	8b 14 91             	mov    (%ecx,%edx,4),%edx
801077d8:	f6 c2 01             	test   $0x1,%dl
801077db:	75 13                	jne    801077f0 <loaduvm+0x60>
      panic("loaduvm: address should exist");
801077dd:	83 ec 0c             	sub    $0xc,%esp
801077e0:	68 cf 88 10 80       	push   $0x801088cf
801077e5:	e8 96 8b ff ff       	call   80100380 <panic>
801077ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801077f0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801077f3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801077f9:	25 fc 0f 00 00       	and    $0xffc,%eax
801077fe:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107805:	85 c0                	test   %eax,%eax
80107807:	74 d4                	je     801077dd <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107809:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010780b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010780e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107813:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107818:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010781e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107821:	29 d9                	sub    %ebx,%ecx
80107823:	05 00 00 00 80       	add    $0x80000000,%eax
80107828:	57                   	push   %edi
80107829:	51                   	push   %ecx
8010782a:	50                   	push   %eax
8010782b:	ff 75 10             	push   0x10(%ebp)
8010782e:	e8 cd a2 ff ff       	call   80101b00 <readi>
80107833:	83 c4 10             	add    $0x10,%esp
80107836:	39 f8                	cmp    %edi,%eax
80107838:	75 1e                	jne    80107858 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
8010783a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107840:	89 f0                	mov    %esi,%eax
80107842:	29 d8                	sub    %ebx,%eax
80107844:	39 c6                	cmp    %eax,%esi
80107846:	77 80                	ja     801077c8 <loaduvm+0x38>
}
80107848:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010784b:	31 c0                	xor    %eax,%eax
}
8010784d:	5b                   	pop    %ebx
8010784e:	5e                   	pop    %esi
8010784f:	5f                   	pop    %edi
80107850:	5d                   	pop    %ebp
80107851:	c3                   	ret    
80107852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107858:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010785b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107860:	5b                   	pop    %ebx
80107861:	5e                   	pop    %esi
80107862:	5f                   	pop    %edi
80107863:	5d                   	pop    %ebp
80107864:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80107865:	83 ec 0c             	sub    $0xc,%esp
80107868:	68 70 89 10 80       	push   $0x80108970
8010786d:	e8 0e 8b ff ff       	call   80100380 <panic>
80107872:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107880 <allocuvm>:
{
80107880:	55                   	push   %ebp
80107881:	89 e5                	mov    %esp,%ebp
80107883:	57                   	push   %edi
80107884:	56                   	push   %esi
80107885:	53                   	push   %ebx
80107886:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107889:	8b 45 10             	mov    0x10(%ebp),%eax
{
8010788c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
8010788f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107892:	85 c0                	test   %eax,%eax
80107894:	0f 88 b6 00 00 00    	js     80107950 <allocuvm+0xd0>
  if(newsz < oldsz)
8010789a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
8010789d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801078a0:	0f 82 9a 00 00 00    	jb     80107940 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
801078a6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801078ac:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801078b2:	39 75 10             	cmp    %esi,0x10(%ebp)
801078b5:	77 44                	ja     801078fb <allocuvm+0x7b>
801078b7:	e9 87 00 00 00       	jmp    80107943 <allocuvm+0xc3>
801078bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
801078c0:	83 ec 04             	sub    $0x4,%esp
801078c3:	68 00 10 00 00       	push   $0x1000
801078c8:	6a 00                	push   $0x0
801078ca:	50                   	push   %eax
801078cb:	e8 90 d9 ff ff       	call   80105260 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801078d0:	58                   	pop    %eax
801078d1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801078d7:	5a                   	pop    %edx
801078d8:	6a 06                	push   $0x6
801078da:	b9 00 10 00 00       	mov    $0x1000,%ecx
801078df:	89 f2                	mov    %esi,%edx
801078e1:	50                   	push   %eax
801078e2:	89 f8                	mov    %edi,%eax
801078e4:	e8 87 fb ff ff       	call   80107470 <mappages>
801078e9:	83 c4 10             	add    $0x10,%esp
801078ec:	85 c0                	test   %eax,%eax
801078ee:	78 78                	js     80107968 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
801078f0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801078f6:	39 75 10             	cmp    %esi,0x10(%ebp)
801078f9:	76 48                	jbe    80107943 <allocuvm+0xc3>
    mem = kalloc();
801078fb:	e8 f0 ad ff ff       	call   801026f0 <kalloc>
80107900:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107902:	85 c0                	test   %eax,%eax
80107904:	75 ba                	jne    801078c0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107906:	83 ec 0c             	sub    $0xc,%esp
80107909:	68 ed 88 10 80       	push   $0x801088ed
8010790e:	e8 8d 8d ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107913:	8b 45 0c             	mov    0xc(%ebp),%eax
80107916:	83 c4 10             	add    $0x10,%esp
80107919:	39 45 10             	cmp    %eax,0x10(%ebp)
8010791c:	74 32                	je     80107950 <allocuvm+0xd0>
8010791e:	8b 55 10             	mov    0x10(%ebp),%edx
80107921:	89 c1                	mov    %eax,%ecx
80107923:	89 f8                	mov    %edi,%eax
80107925:	e8 96 fa ff ff       	call   801073c0 <deallocuvm.part.0>
      return 0;
8010792a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107931:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107934:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107937:	5b                   	pop    %ebx
80107938:	5e                   	pop    %esi
80107939:	5f                   	pop    %edi
8010793a:	5d                   	pop    %ebp
8010793b:	c3                   	ret    
8010793c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107940:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107943:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107946:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107949:	5b                   	pop    %ebx
8010794a:	5e                   	pop    %esi
8010794b:	5f                   	pop    %edi
8010794c:	5d                   	pop    %ebp
8010794d:	c3                   	ret    
8010794e:	66 90                	xchg   %ax,%ax
    return 0;
80107950:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107957:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010795a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010795d:	5b                   	pop    %ebx
8010795e:	5e                   	pop    %esi
8010795f:	5f                   	pop    %edi
80107960:	5d                   	pop    %ebp
80107961:	c3                   	ret    
80107962:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107968:	83 ec 0c             	sub    $0xc,%esp
8010796b:	68 05 89 10 80       	push   $0x80108905
80107970:	e8 2b 8d ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107975:	8b 45 0c             	mov    0xc(%ebp),%eax
80107978:	83 c4 10             	add    $0x10,%esp
8010797b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010797e:	74 0c                	je     8010798c <allocuvm+0x10c>
80107980:	8b 55 10             	mov    0x10(%ebp),%edx
80107983:	89 c1                	mov    %eax,%ecx
80107985:	89 f8                	mov    %edi,%eax
80107987:	e8 34 fa ff ff       	call   801073c0 <deallocuvm.part.0>
      kfree(mem);
8010798c:	83 ec 0c             	sub    $0xc,%esp
8010798f:	53                   	push   %ebx
80107990:	e8 9b ab ff ff       	call   80102530 <kfree>
      return 0;
80107995:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010799c:	83 c4 10             	add    $0x10,%esp
}
8010799f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801079a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079a5:	5b                   	pop    %ebx
801079a6:	5e                   	pop    %esi
801079a7:	5f                   	pop    %edi
801079a8:	5d                   	pop    %ebp
801079a9:	c3                   	ret    
801079aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801079b0 <deallocuvm>:
{
801079b0:	55                   	push   %ebp
801079b1:	89 e5                	mov    %esp,%ebp
801079b3:	8b 55 0c             	mov    0xc(%ebp),%edx
801079b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801079b9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801079bc:	39 d1                	cmp    %edx,%ecx
801079be:	73 10                	jae    801079d0 <deallocuvm+0x20>
}
801079c0:	5d                   	pop    %ebp
801079c1:	e9 fa f9 ff ff       	jmp    801073c0 <deallocuvm.part.0>
801079c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079cd:	8d 76 00             	lea    0x0(%esi),%esi
801079d0:	89 d0                	mov    %edx,%eax
801079d2:	5d                   	pop    %ebp
801079d3:	c3                   	ret    
801079d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801079df:	90                   	nop

801079e0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801079e0:	55                   	push   %ebp
801079e1:	89 e5                	mov    %esp,%ebp
801079e3:	57                   	push   %edi
801079e4:	56                   	push   %esi
801079e5:	53                   	push   %ebx
801079e6:	83 ec 0c             	sub    $0xc,%esp
801079e9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801079ec:	85 f6                	test   %esi,%esi
801079ee:	74 59                	je     80107a49 <freevm+0x69>
  if(newsz >= oldsz)
801079f0:	31 c9                	xor    %ecx,%ecx
801079f2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801079f7:	89 f0                	mov    %esi,%eax
801079f9:	89 f3                	mov    %esi,%ebx
801079fb:	e8 c0 f9 ff ff       	call   801073c0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107a00:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107a06:	eb 0f                	jmp    80107a17 <freevm+0x37>
80107a08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a0f:	90                   	nop
80107a10:	83 c3 04             	add    $0x4,%ebx
80107a13:	39 df                	cmp    %ebx,%edi
80107a15:	74 23                	je     80107a3a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107a17:	8b 03                	mov    (%ebx),%eax
80107a19:	a8 01                	test   $0x1,%al
80107a1b:	74 f3                	je     80107a10 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107a1d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107a22:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107a25:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107a28:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107a2d:	50                   	push   %eax
80107a2e:	e8 fd aa ff ff       	call   80102530 <kfree>
80107a33:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107a36:	39 df                	cmp    %ebx,%edi
80107a38:	75 dd                	jne    80107a17 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107a3a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107a3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a40:	5b                   	pop    %ebx
80107a41:	5e                   	pop    %esi
80107a42:	5f                   	pop    %edi
80107a43:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107a44:	e9 e7 aa ff ff       	jmp    80102530 <kfree>
    panic("freevm: no pgdir");
80107a49:	83 ec 0c             	sub    $0xc,%esp
80107a4c:	68 21 89 10 80       	push   $0x80108921
80107a51:	e8 2a 89 ff ff       	call   80100380 <panic>
80107a56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a5d:	8d 76 00             	lea    0x0(%esi),%esi

80107a60 <setupkvm>:
{
80107a60:	55                   	push   %ebp
80107a61:	89 e5                	mov    %esp,%ebp
80107a63:	56                   	push   %esi
80107a64:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107a65:	e8 86 ac ff ff       	call   801026f0 <kalloc>
80107a6a:	89 c6                	mov    %eax,%esi
80107a6c:	85 c0                	test   %eax,%eax
80107a6e:	74 42                	je     80107ab2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107a70:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107a73:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107a78:	68 00 10 00 00       	push   $0x1000
80107a7d:	6a 00                	push   $0x0
80107a7f:	50                   	push   %eax
80107a80:	e8 db d7 ff ff       	call   80105260 <memset>
80107a85:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107a88:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107a8b:	83 ec 08             	sub    $0x8,%esp
80107a8e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107a91:	ff 73 0c             	push   0xc(%ebx)
80107a94:	8b 13                	mov    (%ebx),%edx
80107a96:	50                   	push   %eax
80107a97:	29 c1                	sub    %eax,%ecx
80107a99:	89 f0                	mov    %esi,%eax
80107a9b:	e8 d0 f9 ff ff       	call   80107470 <mappages>
80107aa0:	83 c4 10             	add    $0x10,%esp
80107aa3:	85 c0                	test   %eax,%eax
80107aa5:	78 19                	js     80107ac0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107aa7:	83 c3 10             	add    $0x10,%ebx
80107aaa:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107ab0:	75 d6                	jne    80107a88 <setupkvm+0x28>
}
80107ab2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107ab5:	89 f0                	mov    %esi,%eax
80107ab7:	5b                   	pop    %ebx
80107ab8:	5e                   	pop    %esi
80107ab9:	5d                   	pop    %ebp
80107aba:	c3                   	ret    
80107abb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107abf:	90                   	nop
      freevm(pgdir);
80107ac0:	83 ec 0c             	sub    $0xc,%esp
80107ac3:	56                   	push   %esi
      return 0;
80107ac4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107ac6:	e8 15 ff ff ff       	call   801079e0 <freevm>
      return 0;
80107acb:	83 c4 10             	add    $0x10,%esp
}
80107ace:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107ad1:	89 f0                	mov    %esi,%eax
80107ad3:	5b                   	pop    %ebx
80107ad4:	5e                   	pop    %esi
80107ad5:	5d                   	pop    %ebp
80107ad6:	c3                   	ret    
80107ad7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107ade:	66 90                	xchg   %ax,%ax

80107ae0 <kvmalloc>:
{
80107ae0:	55                   	push   %ebp
80107ae1:	89 e5                	mov    %esp,%ebp
80107ae3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107ae6:	e8 75 ff ff ff       	call   80107a60 <setupkvm>
80107aeb:	a3 e4 63 11 80       	mov    %eax,0x801163e4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107af0:	05 00 00 00 80       	add    $0x80000000,%eax
80107af5:	0f 22 d8             	mov    %eax,%cr3
}
80107af8:	c9                   	leave  
80107af9:	c3                   	ret    
80107afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107b00 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107b00:	55                   	push   %ebp
80107b01:	89 e5                	mov    %esp,%ebp
80107b03:	83 ec 08             	sub    $0x8,%esp
80107b06:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107b09:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107b0c:	89 c1                	mov    %eax,%ecx
80107b0e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107b11:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107b14:	f6 c2 01             	test   $0x1,%dl
80107b17:	75 17                	jne    80107b30 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107b19:	83 ec 0c             	sub    $0xc,%esp
80107b1c:	68 32 89 10 80       	push   $0x80108932
80107b21:	e8 5a 88 ff ff       	call   80100380 <panic>
80107b26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b2d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107b30:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107b33:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107b39:	25 fc 0f 00 00       	and    $0xffc,%eax
80107b3e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107b45:	85 c0                	test   %eax,%eax
80107b47:	74 d0                	je     80107b19 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107b49:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107b4c:	c9                   	leave  
80107b4d:	c3                   	ret    
80107b4e:	66 90                	xchg   %ax,%ax

80107b50 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107b50:	55                   	push   %ebp
80107b51:	89 e5                	mov    %esp,%ebp
80107b53:	57                   	push   %edi
80107b54:	56                   	push   %esi
80107b55:	53                   	push   %ebx
80107b56:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107b59:	e8 02 ff ff ff       	call   80107a60 <setupkvm>
80107b5e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107b61:	85 c0                	test   %eax,%eax
80107b63:	0f 84 bd 00 00 00    	je     80107c26 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107b69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107b6c:	85 c9                	test   %ecx,%ecx
80107b6e:	0f 84 b2 00 00 00    	je     80107c26 <copyuvm+0xd6>
80107b74:	31 f6                	xor    %esi,%esi
80107b76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b7d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107b80:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107b83:	89 f0                	mov    %esi,%eax
80107b85:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107b88:	8b 04 81             	mov    (%ecx,%eax,4),%eax
80107b8b:	a8 01                	test   $0x1,%al
80107b8d:	75 11                	jne    80107ba0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80107b8f:	83 ec 0c             	sub    $0xc,%esp
80107b92:	68 3c 89 10 80       	push   $0x8010893c
80107b97:	e8 e4 87 ff ff       	call   80100380 <panic>
80107b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107ba0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107ba2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107ba7:	c1 ea 0a             	shr    $0xa,%edx
80107baa:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107bb0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107bb7:	85 c0                	test   %eax,%eax
80107bb9:	74 d4                	je     80107b8f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
80107bbb:	8b 00                	mov    (%eax),%eax
80107bbd:	a8 01                	test   $0x1,%al
80107bbf:	0f 84 9f 00 00 00    	je     80107c64 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107bc5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107bc7:	25 ff 0f 00 00       	and    $0xfff,%eax
80107bcc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107bcf:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107bd5:	e8 16 ab ff ff       	call   801026f0 <kalloc>
80107bda:	89 c3                	mov    %eax,%ebx
80107bdc:	85 c0                	test   %eax,%eax
80107bde:	74 64                	je     80107c44 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107be0:	83 ec 04             	sub    $0x4,%esp
80107be3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107be9:	68 00 10 00 00       	push   $0x1000
80107bee:	57                   	push   %edi
80107bef:	50                   	push   %eax
80107bf0:	e8 0b d7 ff ff       	call   80105300 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107bf5:	58                   	pop    %eax
80107bf6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107bfc:	5a                   	pop    %edx
80107bfd:	ff 75 e4             	push   -0x1c(%ebp)
80107c00:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107c05:	89 f2                	mov    %esi,%edx
80107c07:	50                   	push   %eax
80107c08:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107c0b:	e8 60 f8 ff ff       	call   80107470 <mappages>
80107c10:	83 c4 10             	add    $0x10,%esp
80107c13:	85 c0                	test   %eax,%eax
80107c15:	78 21                	js     80107c38 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107c17:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107c1d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107c20:	0f 87 5a ff ff ff    	ja     80107b80 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107c26:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107c29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c2c:	5b                   	pop    %ebx
80107c2d:	5e                   	pop    %esi
80107c2e:	5f                   	pop    %edi
80107c2f:	5d                   	pop    %ebp
80107c30:	c3                   	ret    
80107c31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107c38:	83 ec 0c             	sub    $0xc,%esp
80107c3b:	53                   	push   %ebx
80107c3c:	e8 ef a8 ff ff       	call   80102530 <kfree>
      goto bad;
80107c41:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107c44:	83 ec 0c             	sub    $0xc,%esp
80107c47:	ff 75 e0             	push   -0x20(%ebp)
80107c4a:	e8 91 fd ff ff       	call   801079e0 <freevm>
  return 0;
80107c4f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107c56:	83 c4 10             	add    $0x10,%esp
}
80107c59:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107c5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c5f:	5b                   	pop    %ebx
80107c60:	5e                   	pop    %esi
80107c61:	5f                   	pop    %edi
80107c62:	5d                   	pop    %ebp
80107c63:	c3                   	ret    
      panic("copyuvm: page not present");
80107c64:	83 ec 0c             	sub    $0xc,%esp
80107c67:	68 56 89 10 80       	push   $0x80108956
80107c6c:	e8 0f 87 ff ff       	call   80100380 <panic>
80107c71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c7f:	90                   	nop

80107c80 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107c80:	55                   	push   %ebp
80107c81:	89 e5                	mov    %esp,%ebp
80107c83:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107c86:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107c89:	89 c1                	mov    %eax,%ecx
80107c8b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107c8e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107c91:	f6 c2 01             	test   $0x1,%dl
80107c94:	0f 84 00 01 00 00    	je     80107d9a <uva2ka.cold>
  return &pgtab[PTX(va)];
80107c9a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107c9d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107ca3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107ca4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107ca9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107cb0:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107cb2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107cb7:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107cba:	05 00 00 00 80       	add    $0x80000000,%eax
80107cbf:	83 fa 05             	cmp    $0x5,%edx
80107cc2:	ba 00 00 00 00       	mov    $0x0,%edx
80107cc7:	0f 45 c2             	cmovne %edx,%eax
}
80107cca:	c3                   	ret    
80107ccb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107ccf:	90                   	nop

80107cd0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107cd0:	55                   	push   %ebp
80107cd1:	89 e5                	mov    %esp,%ebp
80107cd3:	57                   	push   %edi
80107cd4:	56                   	push   %esi
80107cd5:	53                   	push   %ebx
80107cd6:	83 ec 0c             	sub    $0xc,%esp
80107cd9:	8b 75 14             	mov    0x14(%ebp),%esi
80107cdc:	8b 45 0c             	mov    0xc(%ebp),%eax
80107cdf:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107ce2:	85 f6                	test   %esi,%esi
80107ce4:	75 51                	jne    80107d37 <copyout+0x67>
80107ce6:	e9 a5 00 00 00       	jmp    80107d90 <copyout+0xc0>
80107ceb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107cef:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107cf0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107cf6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
80107cfc:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107d02:	74 75                	je     80107d79 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107d04:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107d06:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107d09:	29 c3                	sub    %eax,%ebx
80107d0b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107d11:	39 f3                	cmp    %esi,%ebx
80107d13:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107d16:	29 f8                	sub    %edi,%eax
80107d18:	83 ec 04             	sub    $0x4,%esp
80107d1b:	01 c1                	add    %eax,%ecx
80107d1d:	53                   	push   %ebx
80107d1e:	52                   	push   %edx
80107d1f:	51                   	push   %ecx
80107d20:	e8 db d5 ff ff       	call   80105300 <memmove>
    len -= n;
    buf += n;
80107d25:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107d28:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
80107d2e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107d31:	01 da                	add    %ebx,%edx
  while(len > 0){
80107d33:	29 de                	sub    %ebx,%esi
80107d35:	74 59                	je     80107d90 <copyout+0xc0>
  if(*pde & PTE_P){
80107d37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
80107d3a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107d3c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
80107d3e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107d41:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107d47:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
80107d4a:	f6 c1 01             	test   $0x1,%cl
80107d4d:	0f 84 4e 00 00 00    	je     80107da1 <copyout.cold>
  return &pgtab[PTX(va)];
80107d53:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107d55:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107d5b:	c1 eb 0c             	shr    $0xc,%ebx
80107d5e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107d64:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
80107d6b:	89 d9                	mov    %ebx,%ecx
80107d6d:	83 e1 05             	and    $0x5,%ecx
80107d70:	83 f9 05             	cmp    $0x5,%ecx
80107d73:	0f 84 77 ff ff ff    	je     80107cf0 <copyout+0x20>
  }
  return 0;
}
80107d79:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107d7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107d81:	5b                   	pop    %ebx
80107d82:	5e                   	pop    %esi
80107d83:	5f                   	pop    %edi
80107d84:	5d                   	pop    %ebp
80107d85:	c3                   	ret    
80107d86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d8d:	8d 76 00             	lea    0x0(%esi),%esi
80107d90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107d93:	31 c0                	xor    %eax,%eax
}
80107d95:	5b                   	pop    %ebx
80107d96:	5e                   	pop    %esi
80107d97:	5f                   	pop    %edi
80107d98:	5d                   	pop    %ebp
80107d99:	c3                   	ret    

80107d9a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80107d9a:	a1 00 00 00 00       	mov    0x0,%eax
80107d9f:	0f 0b                	ud2    

80107da1 <copyout.cold>:
80107da1:	a1 00 00 00 00       	mov    0x0,%eax
80107da6:	0f 0b                	ud2    
