
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
80100028:	bc f0 69 11 80       	mov    $0x801169f0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 c0 30 10 80       	mov    $0x801030c0,%eax
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
8010004c:	68 40 7c 10 80       	push   $0x80107c40
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 05 4e 00 00       	call   80104e60 <initlock>
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
80100092:	68 47 7c 10 80       	push   $0x80107c47
80100097:	50                   	push   %eax
80100098:	e8 93 4c 00 00       	call   80104d30 <initsleeplock>
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
801000e4:	e8 47 4f 00 00       	call   80105030 <acquire>
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
80100162:	e8 69 4e 00 00       	call   80104fd0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 fe 4b 00 00       	call   80104d70 <acquiresleep>
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
8010018c:	e8 af 21 00 00       	call   80102340 <iderw>
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
801001a1:	68 4e 7c 10 80       	push   $0x80107c4e
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
801001be:	e8 4d 4c 00 00       	call   80104e10 <holdingsleep>
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
801001d4:	e9 67 21 00 00       	jmp    80102340 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 5f 7c 10 80       	push   $0x80107c5f
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
801001ff:	e8 0c 4c 00 00       	call   80104e10 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 bc 4b 00 00       	call   80104dd0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 10 4e 00 00       	call   80105030 <acquire>
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
8010026c:	e9 5f 4d 00 00       	jmp    80104fd0 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 66 7c 10 80       	push   $0x80107c66
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
80100294:	e8 27 16 00 00       	call   801018c0 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 8b 4d 00 00       	call   80105030 <acquire>
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
801002cd:	e8 3e 41 00 00       	call   80104410 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 79 37 00 00       	call   80103a60 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 d5 4c 00 00       	call   80104fd0 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 dc 14 00 00       	call   801017e0 <ilock>
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
8010034c:	e8 7f 4c 00 00       	call   80104fd0 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 86 14 00 00       	call   801017e0 <ilock>
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
80100399:	e8 b2 25 00 00       	call   80102950 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 6d 7c 10 80       	push   $0x80107c6d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 4c 82 10 80 	movl   $0x8010824c,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 b3 4a 00 00       	call   80104e80 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 81 7c 10 80       	push   $0x80107c81
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
8010041a:	e8 41 63 00 00       	call   80106760 <uartputc>
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
80100505:	e8 56 62 00 00       	call   80106760 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 4a 62 00 00       	call   80106760 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 3e 62 00 00       	call   80106760 <uartputc>
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
80100551:	e8 3a 4c 00 00       	call   80105190 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 85 4b 00 00       	call   801050f0 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 85 7c 10 80       	push   $0x80107c85
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
8010059f:	e8 1c 13 00 00       	call   801018c0 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005ab:	e8 80 4a 00 00       	call   80105030 <acquire>
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
801005e4:	e8 e7 49 00 00       	call   80104fd0 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 ee 11 00 00       	call   801017e0 <ilock>

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
80100636:	0f b6 92 b0 7c 10 80 	movzbl -0x7fef8350(%edx),%edx
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
801007e8:	e8 43 48 00 00       	call   80105030 <acquire>
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
80100838:	bf 98 7c 10 80       	mov    $0x80107c98,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ff 10 80       	push   $0x8010ff20
8010085b:	e8 70 47 00 00       	call   80104fd0 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 9f 7c 10 80       	push   $0x80107c9f
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
80100893:	e8 98 47 00 00       	call   80105030 <acquire>
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
801009d0:	e8 fb 45 00 00       	call   80104fd0 <release>
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
80100a0e:	e9 fd 3b 00 00       	jmp    80104610 <procdump>
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
80100a44:	e8 87 3a 00 00       	call   801044d0 <wakeup>
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
80100a66:	68 a8 7c 10 80       	push   $0x80107ca8
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 eb 43 00 00       	call   80104e60 <initlock>

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
80100a99:	e8 42 1a 00 00       	call   801024e0 <ioapicenable>
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
80100abc:	e8 9f 2f 00 00       	call   80103a60 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 f4 22 00 00       	call   80102dc0 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 29 16 00 00       	call   80102100 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 5e 03 00 00    	je     80100e40 <exec+0x390>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 f3 0c 00 00       	call   801017e0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 f2 0f 00 00       	call   80101af0 <readi>
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
80100b0a:	e8 61 0f 00 00       	call   80101a70 <iunlockput>
    end_op();
80100b0f:	e8 1c 23 00 00       	call   80102e30 <end_op>
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
80100b34:	e8 b7 6d 00 00       	call   801078f0 <setupkvm>
80100b39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b3f:	85 c0                	test   %eax,%eax
80100b41:	74 c3                	je     80100b06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4a:	00 
80100b4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b51:	0f 84 08 03 00 00    	je     80100e5f <exec+0x3af>
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
80100ba3:	e8 68 6b 00 00       	call   80107710 <allocuvm>
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
80100bd9:	e8 42 6a 00 00       	call   80107620 <loaduvm>
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
80100c01:	e8 ea 0e 00 00       	call   80101af0 <readi>
80100c06:	83 c4 10             	add    $0x10,%esp
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	0f 84 5e ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c1b:	e8 50 6c 00 00       	call   80107870 <freevm>
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
80100c4c:	e8 1f 0e 00 00       	call   80101a70 <iunlockput>
  end_op();
80100c51:	e8 da 21 00 00       	call   80102e30 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 a9 6a 00 00       	call   80107710 <allocuvm>
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
80100c83:	e8 08 6d 00 00       	call   80107990 <clearpteu>
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
80100cd3:	e8 18 46 00 00       	call   801052f0 <strlen>
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
80100ce7:	e8 04 46 00 00       	call   801052f0 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 63 6e 00 00       	call   80107b60 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 5a 6b 00 00       	call   80107870 <freevm>
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
80100d65:	e8 f6 6d 00 00       	call   80107b60 <copyout>
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
80100d9f:	e8 0c 45 00 00       	call   801052b0 <safestrcpy>
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
80100dd5:	e8 b6 66 00 00       	call   80107490 <switchuvm>
  freevm(oldpgdir);
80100dda:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100de0:	89 04 24             	mov    %eax,(%esp)
80100de3:	e8 88 6a 00 00       	call   80107870 <freevm>
  if(strncmp(curproc->name,"sh",3) != 0  && strncmp(curproc->name ,"init",5) != 0 && curproc->queue != CLASS1){
80100de8:	83 c4 0c             	add    $0xc,%esp
80100deb:	6a 03                	push   $0x3
80100ded:	68 cd 7c 10 80       	push   $0x80107ccd
80100df2:	53                   	push   %ebx
80100df3:	e8 08 44 00 00       	call   80105200 <strncmp>
80100df8:	83 c4 10             	add    $0x10,%esp
80100dfb:	85 c0                	test   %eax,%eax
80100dfd:	75 07                	jne    80100e06 <exec+0x356>
  return 0;
80100dff:	31 c0                	xor    %eax,%eax
80100e01:	e9 16 fd ff ff       	jmp    80100b1c <exec+0x6c>
  if(strncmp(curproc->name,"sh",3) != 0  && strncmp(curproc->name ,"init",5) != 0 && curproc->queue != CLASS1){
80100e06:	83 ec 04             	sub    $0x4,%esp
80100e09:	6a 05                	push   $0x5
80100e0b:	68 d0 7c 10 80       	push   $0x80107cd0
80100e10:	53                   	push   %ebx
80100e11:	e8 ea 43 00 00       	call   80105200 <strncmp>
80100e16:	83 c4 10             	add    $0x10,%esp
80100e19:	85 c0                	test   %eax,%eax
80100e1b:	74 e2                	je     80100dff <exec+0x34f>
80100e1d:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100e23:	83 78 7c 00          	cmpl   $0x0,0x7c(%eax)
80100e27:	74 d6                	je     80100dff <exec+0x34f>
    curproc->queue = CLASS2_FCFS ;
80100e29:	c7 40 7c 02 00 00 00 	movl   $0x2,0x7c(%eax)
  return 0;
80100e30:	31 c0                	xor    %eax,%eax
80100e32:	e9 e5 fc ff ff       	jmp    80100b1c <exec+0x6c>
80100e37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100e3e:	66 90                	xchg   %ax,%ax
    end_op();
80100e40:	e8 eb 1f 00 00       	call   80102e30 <end_op>
    cprintf("exec: fail\n");
80100e45:	83 ec 0c             	sub    $0xc,%esp
80100e48:	68 c1 7c 10 80       	push   $0x80107cc1
80100e4d:	e8 4e f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100e52:	83 c4 10             	add    $0x10,%esp
80100e55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e5a:	e9 bd fc ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e5f:	be 00 20 00 00       	mov    $0x2000,%esi
80100e64:	31 ff                	xor    %edi,%edi
80100e66:	e9 dd fd ff ff       	jmp    80100c48 <exec+0x198>
80100e6b:	66 90                	xchg   %ax,%ax
80100e6d:	66 90                	xchg   %ax,%ax
80100e6f:	90                   	nop

80100e70 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e70:	55                   	push   %ebp
80100e71:	89 e5                	mov    %esp,%ebp
80100e73:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e76:	68 d5 7c 10 80       	push   $0x80107cd5
80100e7b:	68 60 ff 10 80       	push   $0x8010ff60
80100e80:	e8 db 3f 00 00       	call   80104e60 <initlock>
}
80100e85:	83 c4 10             	add    $0x10,%esp
80100e88:	c9                   	leave  
80100e89:	c3                   	ret    
80100e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e90 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e90:	55                   	push   %ebp
80100e91:	89 e5                	mov    %esp,%ebp
80100e93:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e94:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100e99:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e9c:	68 60 ff 10 80       	push   $0x8010ff60
80100ea1:	e8 8a 41 00 00       	call   80105030 <acquire>
80100ea6:	83 c4 10             	add    $0x10,%esp
80100ea9:	eb 10                	jmp    80100ebb <filealloc+0x2b>
80100eab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100eaf:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100eb0:	83 c3 18             	add    $0x18,%ebx
80100eb3:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100eb9:	74 25                	je     80100ee0 <filealloc+0x50>
    if(f->ref == 0){
80100ebb:	8b 43 04             	mov    0x4(%ebx),%eax
80100ebe:	85 c0                	test   %eax,%eax
80100ec0:	75 ee                	jne    80100eb0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100ec2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100ec5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100ecc:	68 60 ff 10 80       	push   $0x8010ff60
80100ed1:	e8 fa 40 00 00       	call   80104fd0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100ed6:	89 d8                	mov    %ebx,%eax
      return f;
80100ed8:	83 c4 10             	add    $0x10,%esp
}
80100edb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ede:	c9                   	leave  
80100edf:	c3                   	ret    
  release(&ftable.lock);
80100ee0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100ee3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100ee5:	68 60 ff 10 80       	push   $0x8010ff60
80100eea:	e8 e1 40 00 00       	call   80104fd0 <release>
}
80100eef:	89 d8                	mov    %ebx,%eax
  return 0;
80100ef1:	83 c4 10             	add    $0x10,%esp
}
80100ef4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ef7:	c9                   	leave  
80100ef8:	c3                   	ret    
80100ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f00 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	53                   	push   %ebx
80100f04:	83 ec 10             	sub    $0x10,%esp
80100f07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100f0a:	68 60 ff 10 80       	push   $0x8010ff60
80100f0f:	e8 1c 41 00 00       	call   80105030 <acquire>
  if(f->ref < 1)
80100f14:	8b 43 04             	mov    0x4(%ebx),%eax
80100f17:	83 c4 10             	add    $0x10,%esp
80100f1a:	85 c0                	test   %eax,%eax
80100f1c:	7e 1a                	jle    80100f38 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100f1e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100f21:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100f24:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100f27:	68 60 ff 10 80       	push   $0x8010ff60
80100f2c:	e8 9f 40 00 00       	call   80104fd0 <release>
  return f;
}
80100f31:	89 d8                	mov    %ebx,%eax
80100f33:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f36:	c9                   	leave  
80100f37:	c3                   	ret    
    panic("filedup");
80100f38:	83 ec 0c             	sub    $0xc,%esp
80100f3b:	68 dc 7c 10 80       	push   $0x80107cdc
80100f40:	e8 3b f4 ff ff       	call   80100380 <panic>
80100f45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f50 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	57                   	push   %edi
80100f54:	56                   	push   %esi
80100f55:	53                   	push   %ebx
80100f56:	83 ec 28             	sub    $0x28,%esp
80100f59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f5c:	68 60 ff 10 80       	push   $0x8010ff60
80100f61:	e8 ca 40 00 00       	call   80105030 <acquire>
  if(f->ref < 1)
80100f66:	8b 53 04             	mov    0x4(%ebx),%edx
80100f69:	83 c4 10             	add    $0x10,%esp
80100f6c:	85 d2                	test   %edx,%edx
80100f6e:	0f 8e a5 00 00 00    	jle    80101019 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f74:	83 ea 01             	sub    $0x1,%edx
80100f77:	89 53 04             	mov    %edx,0x4(%ebx)
80100f7a:	75 44                	jne    80100fc0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f7c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f80:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f83:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f85:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f8b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f8e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f91:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f94:	68 60 ff 10 80       	push   $0x8010ff60
  ff = *f;
80100f99:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f9c:	e8 2f 40 00 00       	call   80104fd0 <release>

  if(ff.type == FD_PIPE)
80100fa1:	83 c4 10             	add    $0x10,%esp
80100fa4:	83 ff 01             	cmp    $0x1,%edi
80100fa7:	74 57                	je     80101000 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100fa9:	83 ff 02             	cmp    $0x2,%edi
80100fac:	74 2a                	je     80100fd8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100fae:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb1:	5b                   	pop    %ebx
80100fb2:	5e                   	pop    %esi
80100fb3:	5f                   	pop    %edi
80100fb4:	5d                   	pop    %ebp
80100fb5:	c3                   	ret    
80100fb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fbd:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100fc0:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80100fc7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fca:	5b                   	pop    %ebx
80100fcb:	5e                   	pop    %esi
80100fcc:	5f                   	pop    %edi
80100fcd:	5d                   	pop    %ebp
    release(&ftable.lock);
80100fce:	e9 fd 3f 00 00       	jmp    80104fd0 <release>
80100fd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100fd7:	90                   	nop
    begin_op();
80100fd8:	e8 e3 1d 00 00       	call   80102dc0 <begin_op>
    iput(ff.ip);
80100fdd:	83 ec 0c             	sub    $0xc,%esp
80100fe0:	ff 75 e0             	push   -0x20(%ebp)
80100fe3:	e8 28 09 00 00       	call   80101910 <iput>
    end_op();
80100fe8:	83 c4 10             	add    $0x10,%esp
}
80100feb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fee:	5b                   	pop    %ebx
80100fef:	5e                   	pop    %esi
80100ff0:	5f                   	pop    %edi
80100ff1:	5d                   	pop    %ebp
    end_op();
80100ff2:	e9 39 1e 00 00       	jmp    80102e30 <end_op>
80100ff7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100ffe:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80101000:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101004:	83 ec 08             	sub    $0x8,%esp
80101007:	53                   	push   %ebx
80101008:	56                   	push   %esi
80101009:	e8 82 25 00 00       	call   80103590 <pipeclose>
8010100e:	83 c4 10             	add    $0x10,%esp
}
80101011:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101014:	5b                   	pop    %ebx
80101015:	5e                   	pop    %esi
80101016:	5f                   	pop    %edi
80101017:	5d                   	pop    %ebp
80101018:	c3                   	ret    
    panic("fileclose");
80101019:	83 ec 0c             	sub    $0xc,%esp
8010101c:	68 e4 7c 10 80       	push   $0x80107ce4
80101021:	e8 5a f3 ff ff       	call   80100380 <panic>
80101026:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010102d:	8d 76 00             	lea    0x0(%esi),%esi

80101030 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101030:	55                   	push   %ebp
80101031:	89 e5                	mov    %esp,%ebp
80101033:	53                   	push   %ebx
80101034:	83 ec 04             	sub    $0x4,%esp
80101037:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010103a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010103d:	75 31                	jne    80101070 <filestat+0x40>
    ilock(f->ip);
8010103f:	83 ec 0c             	sub    $0xc,%esp
80101042:	ff 73 10             	push   0x10(%ebx)
80101045:	e8 96 07 00 00       	call   801017e0 <ilock>
    stati(f->ip, st);
8010104a:	58                   	pop    %eax
8010104b:	5a                   	pop    %edx
8010104c:	ff 75 0c             	push   0xc(%ebp)
8010104f:	ff 73 10             	push   0x10(%ebx)
80101052:	e8 69 0a 00 00       	call   80101ac0 <stati>
    iunlock(f->ip);
80101057:	59                   	pop    %ecx
80101058:	ff 73 10             	push   0x10(%ebx)
8010105b:	e8 60 08 00 00       	call   801018c0 <iunlock>
    return 0;
  }
  return -1;
}
80101060:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101063:	83 c4 10             	add    $0x10,%esp
80101066:	31 c0                	xor    %eax,%eax
}
80101068:	c9                   	leave  
80101069:	c3                   	ret    
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101070:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101073:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101078:	c9                   	leave  
80101079:	c3                   	ret    
8010107a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101080 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101080:	55                   	push   %ebp
80101081:	89 e5                	mov    %esp,%ebp
80101083:	57                   	push   %edi
80101084:	56                   	push   %esi
80101085:	53                   	push   %ebx
80101086:	83 ec 0c             	sub    $0xc,%esp
80101089:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010108c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010108f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101092:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101096:	74 60                	je     801010f8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101098:	8b 03                	mov    (%ebx),%eax
8010109a:	83 f8 01             	cmp    $0x1,%eax
8010109d:	74 41                	je     801010e0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010109f:	83 f8 02             	cmp    $0x2,%eax
801010a2:	75 5b                	jne    801010ff <fileread+0x7f>
    ilock(f->ip);
801010a4:	83 ec 0c             	sub    $0xc,%esp
801010a7:	ff 73 10             	push   0x10(%ebx)
801010aa:	e8 31 07 00 00       	call   801017e0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801010af:	57                   	push   %edi
801010b0:	ff 73 14             	push   0x14(%ebx)
801010b3:	56                   	push   %esi
801010b4:	ff 73 10             	push   0x10(%ebx)
801010b7:	e8 34 0a 00 00       	call   80101af0 <readi>
801010bc:	83 c4 20             	add    $0x20,%esp
801010bf:	89 c6                	mov    %eax,%esi
801010c1:	85 c0                	test   %eax,%eax
801010c3:	7e 03                	jle    801010c8 <fileread+0x48>
      f->off += r;
801010c5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801010c8:	83 ec 0c             	sub    $0xc,%esp
801010cb:	ff 73 10             	push   0x10(%ebx)
801010ce:	e8 ed 07 00 00       	call   801018c0 <iunlock>
    return r;
801010d3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801010d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d9:	89 f0                	mov    %esi,%eax
801010db:	5b                   	pop    %ebx
801010dc:	5e                   	pop    %esi
801010dd:	5f                   	pop    %edi
801010de:	5d                   	pop    %ebp
801010df:	c3                   	ret    
    return piperead(f->pipe, addr, n);
801010e0:	8b 43 0c             	mov    0xc(%ebx),%eax
801010e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	5b                   	pop    %ebx
801010ea:	5e                   	pop    %esi
801010eb:	5f                   	pop    %edi
801010ec:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010ed:	e9 3e 26 00 00       	jmp    80103730 <piperead>
801010f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010f8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010fd:	eb d7                	jmp    801010d6 <fileread+0x56>
  panic("fileread");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 ee 7c 10 80       	push   $0x80107cee
80101107:	e8 74 f2 ff ff       	call   80100380 <panic>
8010110c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101110 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	57                   	push   %edi
80101114:	56                   	push   %esi
80101115:	53                   	push   %ebx
80101116:	83 ec 1c             	sub    $0x1c,%esp
80101119:	8b 45 0c             	mov    0xc(%ebp),%eax
8010111c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010111f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101122:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101125:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101129:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010112c:	0f 84 bd 00 00 00    	je     801011ef <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
80101132:	8b 03                	mov    (%ebx),%eax
80101134:	83 f8 01             	cmp    $0x1,%eax
80101137:	0f 84 bf 00 00 00    	je     801011fc <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010113d:	83 f8 02             	cmp    $0x2,%eax
80101140:	0f 85 c8 00 00 00    	jne    8010120e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101146:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101149:	31 f6                	xor    %esi,%esi
    while(i < n){
8010114b:	85 c0                	test   %eax,%eax
8010114d:	7f 30                	jg     8010117f <filewrite+0x6f>
8010114f:	e9 94 00 00 00       	jmp    801011e8 <filewrite+0xd8>
80101154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101158:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010115b:	83 ec 0c             	sub    $0xc,%esp
8010115e:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101161:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101164:	e8 57 07 00 00       	call   801018c0 <iunlock>
      end_op();
80101169:	e8 c2 1c 00 00       	call   80102e30 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010116e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101171:	83 c4 10             	add    $0x10,%esp
80101174:	39 c7                	cmp    %eax,%edi
80101176:	75 5c                	jne    801011d4 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101178:	01 fe                	add    %edi,%esi
    while(i < n){
8010117a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010117d:	7e 69                	jle    801011e8 <filewrite+0xd8>
      int n1 = n - i;
8010117f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101182:	b8 00 06 00 00       	mov    $0x600,%eax
80101187:	29 f7                	sub    %esi,%edi
80101189:	39 c7                	cmp    %eax,%edi
8010118b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010118e:	e8 2d 1c 00 00       	call   80102dc0 <begin_op>
      ilock(f->ip);
80101193:	83 ec 0c             	sub    $0xc,%esp
80101196:	ff 73 10             	push   0x10(%ebx)
80101199:	e8 42 06 00 00       	call   801017e0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010119e:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011a1:	57                   	push   %edi
801011a2:	ff 73 14             	push   0x14(%ebx)
801011a5:	01 f0                	add    %esi,%eax
801011a7:	50                   	push   %eax
801011a8:	ff 73 10             	push   0x10(%ebx)
801011ab:	e8 40 0a 00 00       	call   80101bf0 <writei>
801011b0:	83 c4 20             	add    $0x20,%esp
801011b3:	85 c0                	test   %eax,%eax
801011b5:	7f a1                	jg     80101158 <filewrite+0x48>
      iunlock(f->ip);
801011b7:	83 ec 0c             	sub    $0xc,%esp
801011ba:	ff 73 10             	push   0x10(%ebx)
801011bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011c0:	e8 fb 06 00 00       	call   801018c0 <iunlock>
      end_op();
801011c5:	e8 66 1c 00 00       	call   80102e30 <end_op>
      if(r < 0)
801011ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801011cd:	83 c4 10             	add    $0x10,%esp
801011d0:	85 c0                	test   %eax,%eax
801011d2:	75 1b                	jne    801011ef <filewrite+0xdf>
        panic("short filewrite");
801011d4:	83 ec 0c             	sub    $0xc,%esp
801011d7:	68 f7 7c 10 80       	push   $0x80107cf7
801011dc:	e8 9f f1 ff ff       	call   80100380 <panic>
801011e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
801011e8:	89 f0                	mov    %esi,%eax
801011ea:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
801011ed:	74 05                	je     801011f4 <filewrite+0xe4>
801011ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801011f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011f7:	5b                   	pop    %ebx
801011f8:	5e                   	pop    %esi
801011f9:	5f                   	pop    %edi
801011fa:	5d                   	pop    %ebp
801011fb:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801011fc:	8b 43 0c             	mov    0xc(%ebx),%eax
801011ff:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101202:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101205:	5b                   	pop    %ebx
80101206:	5e                   	pop    %esi
80101207:	5f                   	pop    %edi
80101208:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101209:	e9 22 24 00 00       	jmp    80103630 <pipewrite>
  panic("filewrite");
8010120e:	83 ec 0c             	sub    $0xc,%esp
80101211:	68 fd 7c 10 80       	push   $0x80107cfd
80101216:	e8 65 f1 ff ff       	call   80100380 <panic>
8010121b:	66 90                	xchg   %ax,%ax
8010121d:	66 90                	xchg   %ax,%ax
8010121f:	90                   	nop

80101220 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101220:	55                   	push   %ebp
80101221:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101223:	89 d0                	mov    %edx,%eax
80101225:	c1 e8 0c             	shr    $0xc,%eax
80101228:	03 05 cc 25 11 80    	add    0x801125cc,%eax
{
8010122e:	89 e5                	mov    %esp,%ebp
80101230:	56                   	push   %esi
80101231:	53                   	push   %ebx
80101232:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101234:	83 ec 08             	sub    $0x8,%esp
80101237:	50                   	push   %eax
80101238:	51                   	push   %ecx
80101239:	e8 92 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010123e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101240:	c1 fb 03             	sar    $0x3,%ebx
80101243:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101246:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101248:	83 e1 07             	and    $0x7,%ecx
8010124b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101250:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101256:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101258:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010125d:	85 c1                	test   %eax,%ecx
8010125f:	74 23                	je     80101284 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101261:	f7 d0                	not    %eax
  log_write(bp);
80101263:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101266:	21 c8                	and    %ecx,%eax
80101268:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010126c:	56                   	push   %esi
8010126d:	e8 2e 1d 00 00       	call   80102fa0 <log_write>
  brelse(bp);
80101272:	89 34 24             	mov    %esi,(%esp)
80101275:	e8 76 ef ff ff       	call   801001f0 <brelse>
}
8010127a:	83 c4 10             	add    $0x10,%esp
8010127d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101280:	5b                   	pop    %ebx
80101281:	5e                   	pop    %esi
80101282:	5d                   	pop    %ebp
80101283:	c3                   	ret    
    panic("freeing free block");
80101284:	83 ec 0c             	sub    $0xc,%esp
80101287:	68 07 7d 10 80       	push   $0x80107d07
8010128c:	e8 ef f0 ff ff       	call   80100380 <panic>
80101291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101298:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010129f:	90                   	nop

801012a0 <balloc>:
{
801012a0:	55                   	push   %ebp
801012a1:	89 e5                	mov    %esp,%ebp
801012a3:	57                   	push   %edi
801012a4:	56                   	push   %esi
801012a5:	53                   	push   %ebx
801012a6:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
801012a9:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
801012af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801012b2:	85 c9                	test   %ecx,%ecx
801012b4:	0f 84 87 00 00 00    	je     80101341 <balloc+0xa1>
801012ba:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801012c1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801012c4:	83 ec 08             	sub    $0x8,%esp
801012c7:	89 f0                	mov    %esi,%eax
801012c9:	c1 f8 0c             	sar    $0xc,%eax
801012cc:	03 05 cc 25 11 80    	add    0x801125cc,%eax
801012d2:	50                   	push   %eax
801012d3:	ff 75 d8             	push   -0x28(%ebp)
801012d6:	e8 f5 ed ff ff       	call   801000d0 <bread>
801012db:	83 c4 10             	add    $0x10,%esp
801012de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012e1:	a1 b4 25 11 80       	mov    0x801125b4,%eax
801012e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801012e9:	31 c0                	xor    %eax,%eax
801012eb:	eb 2f                	jmp    8010131c <balloc+0x7c>
801012ed:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801012f0:	89 c1                	mov    %eax,%ecx
801012f2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801012fa:	83 e1 07             	and    $0x7,%ecx
801012fd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012ff:	89 c1                	mov    %eax,%ecx
80101301:	c1 f9 03             	sar    $0x3,%ecx
80101304:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101309:	89 fa                	mov    %edi,%edx
8010130b:	85 df                	test   %ebx,%edi
8010130d:	74 41                	je     80101350 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010130f:	83 c0 01             	add    $0x1,%eax
80101312:	83 c6 01             	add    $0x1,%esi
80101315:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010131a:	74 05                	je     80101321 <balloc+0x81>
8010131c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010131f:	77 cf                	ja     801012f0 <balloc+0x50>
    brelse(bp);
80101321:	83 ec 0c             	sub    $0xc,%esp
80101324:	ff 75 e4             	push   -0x1c(%ebp)
80101327:	e8 c4 ee ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010132c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101333:	83 c4 10             	add    $0x10,%esp
80101336:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101339:	39 05 b4 25 11 80    	cmp    %eax,0x801125b4
8010133f:	77 80                	ja     801012c1 <balloc+0x21>
  panic("balloc: out of blocks");
80101341:	83 ec 0c             	sub    $0xc,%esp
80101344:	68 1a 7d 10 80       	push   $0x80107d1a
80101349:	e8 32 f0 ff ff       	call   80100380 <panic>
8010134e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101350:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101353:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101356:	09 da                	or     %ebx,%edx
80101358:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010135c:	57                   	push   %edi
8010135d:	e8 3e 1c 00 00       	call   80102fa0 <log_write>
        brelse(bp);
80101362:	89 3c 24             	mov    %edi,(%esp)
80101365:	e8 86 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010136a:	58                   	pop    %eax
8010136b:	5a                   	pop    %edx
8010136c:	56                   	push   %esi
8010136d:	ff 75 d8             	push   -0x28(%ebp)
80101370:	e8 5b ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101375:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101378:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010137a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010137d:	68 00 02 00 00       	push   $0x200
80101382:	6a 00                	push   $0x0
80101384:	50                   	push   %eax
80101385:	e8 66 3d 00 00       	call   801050f0 <memset>
  log_write(bp);
8010138a:	89 1c 24             	mov    %ebx,(%esp)
8010138d:	e8 0e 1c 00 00       	call   80102fa0 <log_write>
  brelse(bp);
80101392:	89 1c 24             	mov    %ebx,(%esp)
80101395:	e8 56 ee ff ff       	call   801001f0 <brelse>
}
8010139a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010139d:	89 f0                	mov    %esi,%eax
8010139f:	5b                   	pop    %ebx
801013a0:	5e                   	pop    %esi
801013a1:	5f                   	pop    %edi
801013a2:	5d                   	pop    %ebp
801013a3:	c3                   	ret    
801013a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013af:	90                   	nop

801013b0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801013b0:	55                   	push   %ebp
801013b1:	89 e5                	mov    %esp,%ebp
801013b3:	57                   	push   %edi
801013b4:	89 c7                	mov    %eax,%edi
801013b6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801013b7:	31 f6                	xor    %esi,%esi
{
801013b9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013ba:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
801013bf:	83 ec 28             	sub    $0x28,%esp
801013c2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801013c5:	68 60 09 11 80       	push   $0x80110960
801013ca:	e8 61 3c 00 00       	call   80105030 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
801013d2:	83 c4 10             	add    $0x10,%esp
801013d5:	eb 1b                	jmp    801013f2 <iget+0x42>
801013d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013de:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013e0:	39 3b                	cmp    %edi,(%ebx)
801013e2:	74 6c                	je     80101450 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013e4:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013ea:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801013f0:	73 26                	jae    80101418 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f2:	8b 43 08             	mov    0x8(%ebx),%eax
801013f5:	85 c0                	test   %eax,%eax
801013f7:	7f e7                	jg     801013e0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801013f9:	85 f6                	test   %esi,%esi
801013fb:	75 e7                	jne    801013e4 <iget+0x34>
801013fd:	85 c0                	test   %eax,%eax
801013ff:	75 76                	jne    80101477 <iget+0xc7>
80101401:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101403:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101409:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
8010140f:	72 e1                	jb     801013f2 <iget+0x42>
80101411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101418:	85 f6                	test   %esi,%esi
8010141a:	74 79                	je     80101495 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010141c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010141f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101421:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101424:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010142b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101432:	68 60 09 11 80       	push   $0x80110960
80101437:	e8 94 3b 00 00       	call   80104fd0 <release>

  return ip;
8010143c:	83 c4 10             	add    $0x10,%esp
}
8010143f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101442:	89 f0                	mov    %esi,%eax
80101444:	5b                   	pop    %ebx
80101445:	5e                   	pop    %esi
80101446:	5f                   	pop    %edi
80101447:	5d                   	pop    %ebp
80101448:	c3                   	ret    
80101449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101450:	39 53 04             	cmp    %edx,0x4(%ebx)
80101453:	75 8f                	jne    801013e4 <iget+0x34>
      release(&icache.lock);
80101455:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101458:	83 c0 01             	add    $0x1,%eax
      return ip;
8010145b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010145d:	68 60 09 11 80       	push   $0x80110960
      ip->ref++;
80101462:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101465:	e8 66 3b 00 00       	call   80104fd0 <release>
      return ip;
8010146a:	83 c4 10             	add    $0x10,%esp
}
8010146d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101470:	89 f0                	mov    %esi,%eax
80101472:	5b                   	pop    %ebx
80101473:	5e                   	pop    %esi
80101474:	5f                   	pop    %edi
80101475:	5d                   	pop    %ebp
80101476:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101477:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010147d:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101483:	73 10                	jae    80101495 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101485:	8b 43 08             	mov    0x8(%ebx),%eax
80101488:	85 c0                	test   %eax,%eax
8010148a:	0f 8f 50 ff ff ff    	jg     801013e0 <iget+0x30>
80101490:	e9 68 ff ff ff       	jmp    801013fd <iget+0x4d>
    panic("iget: no inodes");
80101495:	83 ec 0c             	sub    $0xc,%esp
80101498:	68 30 7d 10 80       	push   $0x80107d30
8010149d:	e8 de ee ff ff       	call   80100380 <panic>
801014a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801014b0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801014b0:	55                   	push   %ebp
801014b1:	89 e5                	mov    %esp,%ebp
801014b3:	57                   	push   %edi
801014b4:	56                   	push   %esi
801014b5:	89 c6                	mov    %eax,%esi
801014b7:	53                   	push   %ebx
801014b8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801014bb:	83 fa 0b             	cmp    $0xb,%edx
801014be:	0f 86 8c 00 00 00    	jbe    80101550 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801014c4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801014c7:	83 fb 7f             	cmp    $0x7f,%ebx
801014ca:	0f 87 a2 00 00 00    	ja     80101572 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801014d0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801014d6:	85 c0                	test   %eax,%eax
801014d8:	74 5e                	je     80101538 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801014da:	83 ec 08             	sub    $0x8,%esp
801014dd:	50                   	push   %eax
801014de:	ff 36                	push   (%esi)
801014e0:	e8 eb eb ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801014e5:	83 c4 10             	add    $0x10,%esp
801014e8:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
801014ec:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
801014ee:	8b 3b                	mov    (%ebx),%edi
801014f0:	85 ff                	test   %edi,%edi
801014f2:	74 1c                	je     80101510 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801014f4:	83 ec 0c             	sub    $0xc,%esp
801014f7:	52                   	push   %edx
801014f8:	e8 f3 ec ff ff       	call   801001f0 <brelse>
801014fd:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101500:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101503:	89 f8                	mov    %edi,%eax
80101505:	5b                   	pop    %ebx
80101506:	5e                   	pop    %esi
80101507:	5f                   	pop    %edi
80101508:	5d                   	pop    %ebp
80101509:	c3                   	ret    
8010150a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101510:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101513:	8b 06                	mov    (%esi),%eax
80101515:	e8 86 fd ff ff       	call   801012a0 <balloc>
      log_write(bp);
8010151a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010151d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101520:	89 03                	mov    %eax,(%ebx)
80101522:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101524:	52                   	push   %edx
80101525:	e8 76 1a 00 00       	call   80102fa0 <log_write>
8010152a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010152d:	83 c4 10             	add    $0x10,%esp
80101530:	eb c2                	jmp    801014f4 <bmap+0x44>
80101532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101538:	8b 06                	mov    (%esi),%eax
8010153a:	e8 61 fd ff ff       	call   801012a0 <balloc>
8010153f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101545:	eb 93                	jmp    801014da <bmap+0x2a>
80101547:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010154e:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
80101550:	8d 5a 14             	lea    0x14(%edx),%ebx
80101553:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101557:	85 ff                	test   %edi,%edi
80101559:	75 a5                	jne    80101500 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010155b:	8b 00                	mov    (%eax),%eax
8010155d:	e8 3e fd ff ff       	call   801012a0 <balloc>
80101562:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101566:	89 c7                	mov    %eax,%edi
}
80101568:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010156b:	5b                   	pop    %ebx
8010156c:	89 f8                	mov    %edi,%eax
8010156e:	5e                   	pop    %esi
8010156f:	5f                   	pop    %edi
80101570:	5d                   	pop    %ebp
80101571:	c3                   	ret    
  panic("bmap: out of range");
80101572:	83 ec 0c             	sub    $0xc,%esp
80101575:	68 40 7d 10 80       	push   $0x80107d40
8010157a:	e8 01 ee ff ff       	call   80100380 <panic>
8010157f:	90                   	nop

80101580 <readsb>:
{
80101580:	55                   	push   %ebp
80101581:	89 e5                	mov    %esp,%ebp
80101583:	56                   	push   %esi
80101584:	53                   	push   %ebx
80101585:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101588:	83 ec 08             	sub    $0x8,%esp
8010158b:	6a 01                	push   $0x1
8010158d:	ff 75 08             	push   0x8(%ebp)
80101590:	e8 3b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101595:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101598:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010159a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010159d:	6a 1c                	push   $0x1c
8010159f:	50                   	push   %eax
801015a0:	56                   	push   %esi
801015a1:	e8 ea 3b 00 00       	call   80105190 <memmove>
  brelse(bp);
801015a6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801015a9:	83 c4 10             	add    $0x10,%esp
}
801015ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015af:	5b                   	pop    %ebx
801015b0:	5e                   	pop    %esi
801015b1:	5d                   	pop    %ebp
  brelse(bp);
801015b2:	e9 39 ec ff ff       	jmp    801001f0 <brelse>
801015b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015be:	66 90                	xchg   %ax,%ax

801015c0 <iinit>:
{
801015c0:	55                   	push   %ebp
801015c1:	89 e5                	mov    %esp,%ebp
801015c3:	53                   	push   %ebx
801015c4:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
801015c9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801015cc:	68 53 7d 10 80       	push   $0x80107d53
801015d1:	68 60 09 11 80       	push   $0x80110960
801015d6:	e8 85 38 00 00       	call   80104e60 <initlock>
  for(i = 0; i < NINODE; i++) {
801015db:	83 c4 10             	add    $0x10,%esp
801015de:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801015e0:	83 ec 08             	sub    $0x8,%esp
801015e3:	68 5a 7d 10 80       	push   $0x80107d5a
801015e8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801015e9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801015ef:	e8 3c 37 00 00       	call   80104d30 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015f4:	83 c4 10             	add    $0x10,%esp
801015f7:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
801015fd:	75 e1                	jne    801015e0 <iinit+0x20>
  bp = bread(dev, 1);
801015ff:	83 ec 08             	sub    $0x8,%esp
80101602:	6a 01                	push   $0x1
80101604:	ff 75 08             	push   0x8(%ebp)
80101607:	e8 c4 ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010160c:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010160f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101611:	8d 40 5c             	lea    0x5c(%eax),%eax
80101614:	6a 1c                	push   $0x1c
80101616:	50                   	push   %eax
80101617:	68 b4 25 11 80       	push   $0x801125b4
8010161c:	e8 6f 3b 00 00       	call   80105190 <memmove>
  brelse(bp);
80101621:	89 1c 24             	mov    %ebx,(%esp)
80101624:	e8 c7 eb ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101629:	ff 35 cc 25 11 80    	push   0x801125cc
8010162f:	ff 35 c8 25 11 80    	push   0x801125c8
80101635:	ff 35 c4 25 11 80    	push   0x801125c4
8010163b:	ff 35 c0 25 11 80    	push   0x801125c0
80101641:	ff 35 bc 25 11 80    	push   0x801125bc
80101647:	ff 35 b8 25 11 80    	push   0x801125b8
8010164d:	ff 35 b4 25 11 80    	push   0x801125b4
80101653:	68 c0 7d 10 80       	push   $0x80107dc0
80101658:	e8 43 f0 ff ff       	call   801006a0 <cprintf>
}
8010165d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101660:	83 c4 30             	add    $0x30,%esp
80101663:	c9                   	leave  
80101664:	c3                   	ret    
80101665:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010166c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101670 <ialloc>:
{
80101670:	55                   	push   %ebp
80101671:	89 e5                	mov    %esp,%ebp
80101673:	57                   	push   %edi
80101674:	56                   	push   %esi
80101675:	53                   	push   %ebx
80101676:	83 ec 1c             	sub    $0x1c,%esp
80101679:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010167c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
80101683:	8b 75 08             	mov    0x8(%ebp),%esi
80101686:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101689:	0f 86 91 00 00 00    	jbe    80101720 <ialloc+0xb0>
8010168f:	bf 01 00 00 00       	mov    $0x1,%edi
80101694:	eb 21                	jmp    801016b7 <ialloc+0x47>
80101696:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010169d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801016a0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801016a3:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
801016a6:	53                   	push   %ebx
801016a7:	e8 44 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801016ac:	83 c4 10             	add    $0x10,%esp
801016af:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
801016b5:	73 69                	jae    80101720 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801016b7:	89 f8                	mov    %edi,%eax
801016b9:	83 ec 08             	sub    $0x8,%esp
801016bc:	c1 e8 03             	shr    $0x3,%eax
801016bf:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801016c5:	50                   	push   %eax
801016c6:	56                   	push   %esi
801016c7:	e8 04 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
801016cc:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801016cf:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
801016d1:	89 f8                	mov    %edi,%eax
801016d3:	83 e0 07             	and    $0x7,%eax
801016d6:	c1 e0 06             	shl    $0x6,%eax
801016d9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801016dd:	66 83 39 00          	cmpw   $0x0,(%ecx)
801016e1:	75 bd                	jne    801016a0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016e3:	83 ec 04             	sub    $0x4,%esp
801016e6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016e9:	6a 40                	push   $0x40
801016eb:	6a 00                	push   $0x0
801016ed:	51                   	push   %ecx
801016ee:	e8 fd 39 00 00       	call   801050f0 <memset>
      dip->type = type;
801016f3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016f7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016fa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016fd:	89 1c 24             	mov    %ebx,(%esp)
80101700:	e8 9b 18 00 00       	call   80102fa0 <log_write>
      brelse(bp);
80101705:	89 1c 24             	mov    %ebx,(%esp)
80101708:	e8 e3 ea ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010170d:	83 c4 10             	add    $0x10,%esp
}
80101710:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101713:	89 fa                	mov    %edi,%edx
}
80101715:	5b                   	pop    %ebx
      return iget(dev, inum);
80101716:	89 f0                	mov    %esi,%eax
}
80101718:	5e                   	pop    %esi
80101719:	5f                   	pop    %edi
8010171a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010171b:	e9 90 fc ff ff       	jmp    801013b0 <iget>
  panic("ialloc: no inodes");
80101720:	83 ec 0c             	sub    $0xc,%esp
80101723:	68 60 7d 10 80       	push   $0x80107d60
80101728:	e8 53 ec ff ff       	call   80100380 <panic>
8010172d:	8d 76 00             	lea    0x0(%esi),%esi

80101730 <iupdate>:
{
80101730:	55                   	push   %ebp
80101731:	89 e5                	mov    %esp,%ebp
80101733:	56                   	push   %esi
80101734:	53                   	push   %ebx
80101735:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101738:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010173b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010173e:	83 ec 08             	sub    $0x8,%esp
80101741:	c1 e8 03             	shr    $0x3,%eax
80101744:	03 05 c8 25 11 80    	add    0x801125c8,%eax
8010174a:	50                   	push   %eax
8010174b:	ff 73 a4             	push   -0x5c(%ebx)
8010174e:	e8 7d e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101753:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101757:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010175a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010175c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010175f:	83 e0 07             	and    $0x7,%eax
80101762:	c1 e0 06             	shl    $0x6,%eax
80101765:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101769:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010176c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101770:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101773:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101777:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010177b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010177f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101783:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101787:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010178a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010178d:	6a 34                	push   $0x34
8010178f:	53                   	push   %ebx
80101790:	50                   	push   %eax
80101791:	e8 fa 39 00 00       	call   80105190 <memmove>
  log_write(bp);
80101796:	89 34 24             	mov    %esi,(%esp)
80101799:	e8 02 18 00 00       	call   80102fa0 <log_write>
  brelse(bp);
8010179e:	89 75 08             	mov    %esi,0x8(%ebp)
801017a1:	83 c4 10             	add    $0x10,%esp
}
801017a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017a7:	5b                   	pop    %ebx
801017a8:	5e                   	pop    %esi
801017a9:	5d                   	pop    %ebp
  brelse(bp);
801017aa:	e9 41 ea ff ff       	jmp    801001f0 <brelse>
801017af:	90                   	nop

801017b0 <idup>:
{
801017b0:	55                   	push   %ebp
801017b1:	89 e5                	mov    %esp,%ebp
801017b3:	53                   	push   %ebx
801017b4:	83 ec 10             	sub    $0x10,%esp
801017b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801017ba:	68 60 09 11 80       	push   $0x80110960
801017bf:	e8 6c 38 00 00       	call   80105030 <acquire>
  ip->ref++;
801017c4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017c8:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801017cf:	e8 fc 37 00 00       	call   80104fd0 <release>
}
801017d4:	89 d8                	mov    %ebx,%eax
801017d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017d9:	c9                   	leave  
801017da:	c3                   	ret    
801017db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801017df:	90                   	nop

801017e0 <ilock>:
{
801017e0:	55                   	push   %ebp
801017e1:	89 e5                	mov    %esp,%ebp
801017e3:	56                   	push   %esi
801017e4:	53                   	push   %ebx
801017e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017e8:	85 db                	test   %ebx,%ebx
801017ea:	0f 84 b7 00 00 00    	je     801018a7 <ilock+0xc7>
801017f0:	8b 53 08             	mov    0x8(%ebx),%edx
801017f3:	85 d2                	test   %edx,%edx
801017f5:	0f 8e ac 00 00 00    	jle    801018a7 <ilock+0xc7>
  acquiresleep(&ip->lock);
801017fb:	83 ec 0c             	sub    $0xc,%esp
801017fe:	8d 43 0c             	lea    0xc(%ebx),%eax
80101801:	50                   	push   %eax
80101802:	e8 69 35 00 00       	call   80104d70 <acquiresleep>
  if(ip->valid == 0){
80101807:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010180a:	83 c4 10             	add    $0x10,%esp
8010180d:	85 c0                	test   %eax,%eax
8010180f:	74 0f                	je     80101820 <ilock+0x40>
}
80101811:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101814:	5b                   	pop    %ebx
80101815:	5e                   	pop    %esi
80101816:	5d                   	pop    %ebp
80101817:	c3                   	ret    
80101818:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010181f:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101820:	8b 43 04             	mov    0x4(%ebx),%eax
80101823:	83 ec 08             	sub    $0x8,%esp
80101826:	c1 e8 03             	shr    $0x3,%eax
80101829:	03 05 c8 25 11 80    	add    0x801125c8,%eax
8010182f:	50                   	push   %eax
80101830:	ff 33                	push   (%ebx)
80101832:	e8 99 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101837:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010183a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010183c:	8b 43 04             	mov    0x4(%ebx),%eax
8010183f:	83 e0 07             	and    $0x7,%eax
80101842:	c1 e0 06             	shl    $0x6,%eax
80101845:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101849:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010184c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010184f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101853:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101857:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010185b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010185f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101863:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101867:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010186b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010186e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101871:	6a 34                	push   $0x34
80101873:	50                   	push   %eax
80101874:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101877:	50                   	push   %eax
80101878:	e8 13 39 00 00       	call   80105190 <memmove>
    brelse(bp);
8010187d:	89 34 24             	mov    %esi,(%esp)
80101880:	e8 6b e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101885:	83 c4 10             	add    $0x10,%esp
80101888:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010188d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101894:	0f 85 77 ff ff ff    	jne    80101811 <ilock+0x31>
      panic("ilock: no type");
8010189a:	83 ec 0c             	sub    $0xc,%esp
8010189d:	68 78 7d 10 80       	push   $0x80107d78
801018a2:	e8 d9 ea ff ff       	call   80100380 <panic>
    panic("ilock");
801018a7:	83 ec 0c             	sub    $0xc,%esp
801018aa:	68 72 7d 10 80       	push   $0x80107d72
801018af:	e8 cc ea ff ff       	call   80100380 <panic>
801018b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018bf:	90                   	nop

801018c0 <iunlock>:
{
801018c0:	55                   	push   %ebp
801018c1:	89 e5                	mov    %esp,%ebp
801018c3:	56                   	push   %esi
801018c4:	53                   	push   %ebx
801018c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801018c8:	85 db                	test   %ebx,%ebx
801018ca:	74 28                	je     801018f4 <iunlock+0x34>
801018cc:	83 ec 0c             	sub    $0xc,%esp
801018cf:	8d 73 0c             	lea    0xc(%ebx),%esi
801018d2:	56                   	push   %esi
801018d3:	e8 38 35 00 00       	call   80104e10 <holdingsleep>
801018d8:	83 c4 10             	add    $0x10,%esp
801018db:	85 c0                	test   %eax,%eax
801018dd:	74 15                	je     801018f4 <iunlock+0x34>
801018df:	8b 43 08             	mov    0x8(%ebx),%eax
801018e2:	85 c0                	test   %eax,%eax
801018e4:	7e 0e                	jle    801018f4 <iunlock+0x34>
  releasesleep(&ip->lock);
801018e6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801018e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018ec:	5b                   	pop    %ebx
801018ed:	5e                   	pop    %esi
801018ee:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801018ef:	e9 dc 34 00 00       	jmp    80104dd0 <releasesleep>
    panic("iunlock");
801018f4:	83 ec 0c             	sub    $0xc,%esp
801018f7:	68 87 7d 10 80       	push   $0x80107d87
801018fc:	e8 7f ea ff ff       	call   80100380 <panic>
80101901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101908:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010190f:	90                   	nop

80101910 <iput>:
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	57                   	push   %edi
80101914:	56                   	push   %esi
80101915:	53                   	push   %ebx
80101916:	83 ec 28             	sub    $0x28,%esp
80101919:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010191c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010191f:	57                   	push   %edi
80101920:	e8 4b 34 00 00       	call   80104d70 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101925:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101928:	83 c4 10             	add    $0x10,%esp
8010192b:	85 d2                	test   %edx,%edx
8010192d:	74 07                	je     80101936 <iput+0x26>
8010192f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101934:	74 32                	je     80101968 <iput+0x58>
  releasesleep(&ip->lock);
80101936:	83 ec 0c             	sub    $0xc,%esp
80101939:	57                   	push   %edi
8010193a:	e8 91 34 00 00       	call   80104dd0 <releasesleep>
  acquire(&icache.lock);
8010193f:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101946:	e8 e5 36 00 00       	call   80105030 <acquire>
  ip->ref--;
8010194b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010194f:	83 c4 10             	add    $0x10,%esp
80101952:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
80101959:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010195c:	5b                   	pop    %ebx
8010195d:	5e                   	pop    %esi
8010195e:	5f                   	pop    %edi
8010195f:	5d                   	pop    %ebp
  release(&icache.lock);
80101960:	e9 6b 36 00 00       	jmp    80104fd0 <release>
80101965:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101968:	83 ec 0c             	sub    $0xc,%esp
8010196b:	68 60 09 11 80       	push   $0x80110960
80101970:	e8 bb 36 00 00       	call   80105030 <acquire>
    int r = ip->ref;
80101975:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101978:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010197f:	e8 4c 36 00 00       	call   80104fd0 <release>
    if(r == 1){
80101984:	83 c4 10             	add    $0x10,%esp
80101987:	83 fe 01             	cmp    $0x1,%esi
8010198a:	75 aa                	jne    80101936 <iput+0x26>
8010198c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101992:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101995:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101998:	89 cf                	mov    %ecx,%edi
8010199a:	eb 0b                	jmp    801019a7 <iput+0x97>
8010199c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801019a0:	83 c6 04             	add    $0x4,%esi
801019a3:	39 fe                	cmp    %edi,%esi
801019a5:	74 19                	je     801019c0 <iput+0xb0>
    if(ip->addrs[i]){
801019a7:	8b 16                	mov    (%esi),%edx
801019a9:	85 d2                	test   %edx,%edx
801019ab:	74 f3                	je     801019a0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801019ad:	8b 03                	mov    (%ebx),%eax
801019af:	e8 6c f8 ff ff       	call   80101220 <bfree>
      ip->addrs[i] = 0;
801019b4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801019ba:	eb e4                	jmp    801019a0 <iput+0x90>
801019bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801019c0:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801019c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019c9:	85 c0                	test   %eax,%eax
801019cb:	75 2d                	jne    801019fa <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801019cd:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801019d0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801019d7:	53                   	push   %ebx
801019d8:	e8 53 fd ff ff       	call   80101730 <iupdate>
      ip->type = 0;
801019dd:	31 c0                	xor    %eax,%eax
801019df:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801019e3:	89 1c 24             	mov    %ebx,(%esp)
801019e6:	e8 45 fd ff ff       	call   80101730 <iupdate>
      ip->valid = 0;
801019eb:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801019f2:	83 c4 10             	add    $0x10,%esp
801019f5:	e9 3c ff ff ff       	jmp    80101936 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801019fa:	83 ec 08             	sub    $0x8,%esp
801019fd:	50                   	push   %eax
801019fe:	ff 33                	push   (%ebx)
80101a00:	e8 cb e6 ff ff       	call   801000d0 <bread>
80101a05:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a08:	83 c4 10             	add    $0x10,%esp
80101a0b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101a11:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101a14:	8d 70 5c             	lea    0x5c(%eax),%esi
80101a17:	89 cf                	mov    %ecx,%edi
80101a19:	eb 0c                	jmp    80101a27 <iput+0x117>
80101a1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a1f:	90                   	nop
80101a20:	83 c6 04             	add    $0x4,%esi
80101a23:	39 f7                	cmp    %esi,%edi
80101a25:	74 0f                	je     80101a36 <iput+0x126>
      if(a[j])
80101a27:	8b 16                	mov    (%esi),%edx
80101a29:	85 d2                	test   %edx,%edx
80101a2b:	74 f3                	je     80101a20 <iput+0x110>
        bfree(ip->dev, a[j]);
80101a2d:	8b 03                	mov    (%ebx),%eax
80101a2f:	e8 ec f7 ff ff       	call   80101220 <bfree>
80101a34:	eb ea                	jmp    80101a20 <iput+0x110>
    brelse(bp);
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	ff 75 e4             	push   -0x1c(%ebp)
80101a3c:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a3f:	e8 ac e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a44:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a4a:	8b 03                	mov    (%ebx),%eax
80101a4c:	e8 cf f7 ff ff       	call   80101220 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a51:	83 c4 10             	add    $0x10,%esp
80101a54:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a5b:	00 00 00 
80101a5e:	e9 6a ff ff ff       	jmp    801019cd <iput+0xbd>
80101a63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a70 <iunlockput>:
{
80101a70:	55                   	push   %ebp
80101a71:	89 e5                	mov    %esp,%ebp
80101a73:	56                   	push   %esi
80101a74:	53                   	push   %ebx
80101a75:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a78:	85 db                	test   %ebx,%ebx
80101a7a:	74 34                	je     80101ab0 <iunlockput+0x40>
80101a7c:	83 ec 0c             	sub    $0xc,%esp
80101a7f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a82:	56                   	push   %esi
80101a83:	e8 88 33 00 00       	call   80104e10 <holdingsleep>
80101a88:	83 c4 10             	add    $0x10,%esp
80101a8b:	85 c0                	test   %eax,%eax
80101a8d:	74 21                	je     80101ab0 <iunlockput+0x40>
80101a8f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a92:	85 c0                	test   %eax,%eax
80101a94:	7e 1a                	jle    80101ab0 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a96:	83 ec 0c             	sub    $0xc,%esp
80101a99:	56                   	push   %esi
80101a9a:	e8 31 33 00 00       	call   80104dd0 <releasesleep>
  iput(ip);
80101a9f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101aa2:	83 c4 10             	add    $0x10,%esp
}
80101aa5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101aa8:	5b                   	pop    %ebx
80101aa9:	5e                   	pop    %esi
80101aaa:	5d                   	pop    %ebp
  iput(ip);
80101aab:	e9 60 fe ff ff       	jmp    80101910 <iput>
    panic("iunlock");
80101ab0:	83 ec 0c             	sub    $0xc,%esp
80101ab3:	68 87 7d 10 80       	push   $0x80107d87
80101ab8:	e8 c3 e8 ff ff       	call   80100380 <panic>
80101abd:	8d 76 00             	lea    0x0(%esi),%esi

80101ac0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101ac0:	55                   	push   %ebp
80101ac1:	89 e5                	mov    %esp,%ebp
80101ac3:	8b 55 08             	mov    0x8(%ebp),%edx
80101ac6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101ac9:	8b 0a                	mov    (%edx),%ecx
80101acb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101ace:	8b 4a 04             	mov    0x4(%edx),%ecx
80101ad1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101ad4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101ad8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101adb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101adf:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101ae3:	8b 52 58             	mov    0x58(%edx),%edx
80101ae6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101ae9:	5d                   	pop    %ebp
80101aea:	c3                   	ret    
80101aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aef:	90                   	nop

80101af0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101af0:	55                   	push   %ebp
80101af1:	89 e5                	mov    %esp,%ebp
80101af3:	57                   	push   %edi
80101af4:	56                   	push   %esi
80101af5:	53                   	push   %ebx
80101af6:	83 ec 1c             	sub    $0x1c,%esp
80101af9:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101afc:	8b 45 08             	mov    0x8(%ebp),%eax
80101aff:	8b 75 10             	mov    0x10(%ebp),%esi
80101b02:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101b05:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b08:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b0d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b10:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101b13:	0f 84 a7 00 00 00    	je     80101bc0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101b19:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b1c:	8b 40 58             	mov    0x58(%eax),%eax
80101b1f:	39 c6                	cmp    %eax,%esi
80101b21:	0f 87 ba 00 00 00    	ja     80101be1 <readi+0xf1>
80101b27:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b2a:	31 c9                	xor    %ecx,%ecx
80101b2c:	89 da                	mov    %ebx,%edx
80101b2e:	01 f2                	add    %esi,%edx
80101b30:	0f 92 c1             	setb   %cl
80101b33:	89 cf                	mov    %ecx,%edi
80101b35:	0f 82 a6 00 00 00    	jb     80101be1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101b3b:	89 c1                	mov    %eax,%ecx
80101b3d:	29 f1                	sub    %esi,%ecx
80101b3f:	39 d0                	cmp    %edx,%eax
80101b41:	0f 43 cb             	cmovae %ebx,%ecx
80101b44:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b47:	85 c9                	test   %ecx,%ecx
80101b49:	74 67                	je     80101bb2 <readi+0xc2>
80101b4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b4f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b50:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b53:	89 f2                	mov    %esi,%edx
80101b55:	c1 ea 09             	shr    $0x9,%edx
80101b58:	89 d8                	mov    %ebx,%eax
80101b5a:	e8 51 f9 ff ff       	call   801014b0 <bmap>
80101b5f:	83 ec 08             	sub    $0x8,%esp
80101b62:	50                   	push   %eax
80101b63:	ff 33                	push   (%ebx)
80101b65:	e8 66 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b6a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b6d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b72:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b74:	89 f0                	mov    %esi,%eax
80101b76:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b7b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b7d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b80:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b82:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b86:	39 d9                	cmp    %ebx,%ecx
80101b88:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b8b:	83 c4 0c             	add    $0xc,%esp
80101b8e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b8f:	01 df                	add    %ebx,%edi
80101b91:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b93:	50                   	push   %eax
80101b94:	ff 75 e0             	push   -0x20(%ebp)
80101b97:	e8 f4 35 00 00       	call   80105190 <memmove>
    brelse(bp);
80101b9c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b9f:	89 14 24             	mov    %edx,(%esp)
80101ba2:	e8 49 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ba7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101baa:	83 c4 10             	add    $0x10,%esp
80101bad:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101bb0:	77 9e                	ja     80101b50 <readi+0x60>
  }
  return n;
80101bb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101bb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bb8:	5b                   	pop    %ebx
80101bb9:	5e                   	pop    %esi
80101bba:	5f                   	pop    %edi
80101bbb:	5d                   	pop    %ebp
80101bbc:	c3                   	ret    
80101bbd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101bc0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101bc4:	66 83 f8 09          	cmp    $0x9,%ax
80101bc8:	77 17                	ja     80101be1 <readi+0xf1>
80101bca:	8b 04 c5 00 09 11 80 	mov    -0x7feef700(,%eax,8),%eax
80101bd1:	85 c0                	test   %eax,%eax
80101bd3:	74 0c                	je     80101be1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101bd5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101bd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bdb:	5b                   	pop    %ebx
80101bdc:	5e                   	pop    %esi
80101bdd:	5f                   	pop    %edi
80101bde:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101bdf:	ff e0                	jmp    *%eax
      return -1;
80101be1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101be6:	eb cd                	jmp    80101bb5 <readi+0xc5>
80101be8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bef:	90                   	nop

80101bf0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101bf0:	55                   	push   %ebp
80101bf1:	89 e5                	mov    %esp,%ebp
80101bf3:	57                   	push   %edi
80101bf4:	56                   	push   %esi
80101bf5:	53                   	push   %ebx
80101bf6:	83 ec 1c             	sub    $0x1c,%esp
80101bf9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bfc:	8b 75 0c             	mov    0xc(%ebp),%esi
80101bff:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c02:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101c07:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101c0a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c0d:	8b 75 10             	mov    0x10(%ebp),%esi
80101c10:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101c13:	0f 84 b7 00 00 00    	je     80101cd0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101c19:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c1c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c1f:	0f 87 e7 00 00 00    	ja     80101d0c <writei+0x11c>
80101c25:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101c28:	31 d2                	xor    %edx,%edx
80101c2a:	89 f8                	mov    %edi,%eax
80101c2c:	01 f0                	add    %esi,%eax
80101c2e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101c31:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101c36:	0f 87 d0 00 00 00    	ja     80101d0c <writei+0x11c>
80101c3c:	85 d2                	test   %edx,%edx
80101c3e:	0f 85 c8 00 00 00    	jne    80101d0c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c44:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101c4b:	85 ff                	test   %edi,%edi
80101c4d:	74 72                	je     80101cc1 <writei+0xd1>
80101c4f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c50:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101c53:	89 f2                	mov    %esi,%edx
80101c55:	c1 ea 09             	shr    $0x9,%edx
80101c58:	89 f8                	mov    %edi,%eax
80101c5a:	e8 51 f8 ff ff       	call   801014b0 <bmap>
80101c5f:	83 ec 08             	sub    $0x8,%esp
80101c62:	50                   	push   %eax
80101c63:	ff 37                	push   (%edi)
80101c65:	e8 66 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c6a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c6f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c72:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c75:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c77:	89 f0                	mov    %esi,%eax
80101c79:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c7e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c80:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c84:	39 d9                	cmp    %ebx,%ecx
80101c86:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c89:	83 c4 0c             	add    $0xc,%esp
80101c8c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c8d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c8f:	ff 75 dc             	push   -0x24(%ebp)
80101c92:	50                   	push   %eax
80101c93:	e8 f8 34 00 00       	call   80105190 <memmove>
    log_write(bp);
80101c98:	89 3c 24             	mov    %edi,(%esp)
80101c9b:	e8 00 13 00 00       	call   80102fa0 <log_write>
    brelse(bp);
80101ca0:	89 3c 24             	mov    %edi,(%esp)
80101ca3:	e8 48 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ca8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101cab:	83 c4 10             	add    $0x10,%esp
80101cae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101cb1:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101cb4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101cb7:	77 97                	ja     80101c50 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101cb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101cbc:	3b 70 58             	cmp    0x58(%eax),%esi
80101cbf:	77 37                	ja     80101cf8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101cc1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101cc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cc7:	5b                   	pop    %ebx
80101cc8:	5e                   	pop    %esi
80101cc9:	5f                   	pop    %edi
80101cca:	5d                   	pop    %ebp
80101ccb:	c3                   	ret    
80101ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101cd0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101cd4:	66 83 f8 09          	cmp    $0x9,%ax
80101cd8:	77 32                	ja     80101d0c <writei+0x11c>
80101cda:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101ce1:	85 c0                	test   %eax,%eax
80101ce3:	74 27                	je     80101d0c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101ce5:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101ce8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ceb:	5b                   	pop    %ebx
80101cec:	5e                   	pop    %esi
80101ced:	5f                   	pop    %edi
80101cee:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101cef:	ff e0                	jmp    *%eax
80101cf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101cf8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101cfb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101cfe:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101d01:	50                   	push   %eax
80101d02:	e8 29 fa ff ff       	call   80101730 <iupdate>
80101d07:	83 c4 10             	add    $0x10,%esp
80101d0a:	eb b5                	jmp    80101cc1 <writei+0xd1>
      return -1;
80101d0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d11:	eb b1                	jmp    80101cc4 <writei+0xd4>
80101d13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101d20 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101d20:	55                   	push   %ebp
80101d21:	89 e5                	mov    %esp,%ebp
80101d23:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101d26:	6a 0e                	push   $0xe
80101d28:	ff 75 0c             	push   0xc(%ebp)
80101d2b:	ff 75 08             	push   0x8(%ebp)
80101d2e:	e8 cd 34 00 00       	call   80105200 <strncmp>
}
80101d33:	c9                   	leave  
80101d34:	c3                   	ret    
80101d35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101d40 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101d40:	55                   	push   %ebp
80101d41:	89 e5                	mov    %esp,%ebp
80101d43:	57                   	push   %edi
80101d44:	56                   	push   %esi
80101d45:	53                   	push   %ebx
80101d46:	83 ec 1c             	sub    $0x1c,%esp
80101d49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d4c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d51:	0f 85 85 00 00 00    	jne    80101ddc <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d57:	8b 53 58             	mov    0x58(%ebx),%edx
80101d5a:	31 ff                	xor    %edi,%edi
80101d5c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d5f:	85 d2                	test   %edx,%edx
80101d61:	74 3e                	je     80101da1 <dirlookup+0x61>
80101d63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d67:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d68:	6a 10                	push   $0x10
80101d6a:	57                   	push   %edi
80101d6b:	56                   	push   %esi
80101d6c:	53                   	push   %ebx
80101d6d:	e8 7e fd ff ff       	call   80101af0 <readi>
80101d72:	83 c4 10             	add    $0x10,%esp
80101d75:	83 f8 10             	cmp    $0x10,%eax
80101d78:	75 55                	jne    80101dcf <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d7a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d7f:	74 18                	je     80101d99 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d81:	83 ec 04             	sub    $0x4,%esp
80101d84:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d87:	6a 0e                	push   $0xe
80101d89:	50                   	push   %eax
80101d8a:	ff 75 0c             	push   0xc(%ebp)
80101d8d:	e8 6e 34 00 00       	call   80105200 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d92:	83 c4 10             	add    $0x10,%esp
80101d95:	85 c0                	test   %eax,%eax
80101d97:	74 17                	je     80101db0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d99:	83 c7 10             	add    $0x10,%edi
80101d9c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d9f:	72 c7                	jb     80101d68 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101da1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101da4:	31 c0                	xor    %eax,%eax
}
80101da6:	5b                   	pop    %ebx
80101da7:	5e                   	pop    %esi
80101da8:	5f                   	pop    %edi
80101da9:	5d                   	pop    %ebp
80101daa:	c3                   	ret    
80101dab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101daf:	90                   	nop
      if(poff)
80101db0:	8b 45 10             	mov    0x10(%ebp),%eax
80101db3:	85 c0                	test   %eax,%eax
80101db5:	74 05                	je     80101dbc <dirlookup+0x7c>
        *poff = off;
80101db7:	8b 45 10             	mov    0x10(%ebp),%eax
80101dba:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101dbc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101dc0:	8b 03                	mov    (%ebx),%eax
80101dc2:	e8 e9 f5 ff ff       	call   801013b0 <iget>
}
80101dc7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dca:	5b                   	pop    %ebx
80101dcb:	5e                   	pop    %esi
80101dcc:	5f                   	pop    %edi
80101dcd:	5d                   	pop    %ebp
80101dce:	c3                   	ret    
      panic("dirlookup read");
80101dcf:	83 ec 0c             	sub    $0xc,%esp
80101dd2:	68 a1 7d 10 80       	push   $0x80107da1
80101dd7:	e8 a4 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101ddc:	83 ec 0c             	sub    $0xc,%esp
80101ddf:	68 8f 7d 10 80       	push   $0x80107d8f
80101de4:	e8 97 e5 ff ff       	call   80100380 <panic>
80101de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101df0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101df0:	55                   	push   %ebp
80101df1:	89 e5                	mov    %esp,%ebp
80101df3:	57                   	push   %edi
80101df4:	56                   	push   %esi
80101df5:	53                   	push   %ebx
80101df6:	89 c3                	mov    %eax,%ebx
80101df8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101dfb:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101dfe:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e01:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101e04:	0f 84 64 01 00 00    	je     80101f6e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101e0a:	e8 51 1c 00 00       	call   80103a60 <myproc>
  acquire(&icache.lock);
80101e0f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101e12:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101e15:	68 60 09 11 80       	push   $0x80110960
80101e1a:	e8 11 32 00 00       	call   80105030 <acquire>
  ip->ref++;
80101e1f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101e23:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101e2a:	e8 a1 31 00 00       	call   80104fd0 <release>
80101e2f:	83 c4 10             	add    $0x10,%esp
80101e32:	eb 07                	jmp    80101e3b <namex+0x4b>
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e38:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e3b:	0f b6 03             	movzbl (%ebx),%eax
80101e3e:	3c 2f                	cmp    $0x2f,%al
80101e40:	74 f6                	je     80101e38 <namex+0x48>
  if(*path == 0)
80101e42:	84 c0                	test   %al,%al
80101e44:	0f 84 06 01 00 00    	je     80101f50 <namex+0x160>
  while(*path != '/' && *path != 0)
80101e4a:	0f b6 03             	movzbl (%ebx),%eax
80101e4d:	84 c0                	test   %al,%al
80101e4f:	0f 84 10 01 00 00    	je     80101f65 <namex+0x175>
80101e55:	89 df                	mov    %ebx,%edi
80101e57:	3c 2f                	cmp    $0x2f,%al
80101e59:	0f 84 06 01 00 00    	je     80101f65 <namex+0x175>
80101e5f:	90                   	nop
80101e60:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e64:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e67:	3c 2f                	cmp    $0x2f,%al
80101e69:	74 04                	je     80101e6f <namex+0x7f>
80101e6b:	84 c0                	test   %al,%al
80101e6d:	75 f1                	jne    80101e60 <namex+0x70>
  len = path - s;
80101e6f:	89 f8                	mov    %edi,%eax
80101e71:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e73:	83 f8 0d             	cmp    $0xd,%eax
80101e76:	0f 8e ac 00 00 00    	jle    80101f28 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e7c:	83 ec 04             	sub    $0x4,%esp
80101e7f:	6a 0e                	push   $0xe
80101e81:	53                   	push   %ebx
    path++;
80101e82:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e84:	ff 75 e4             	push   -0x1c(%ebp)
80101e87:	e8 04 33 00 00       	call   80105190 <memmove>
80101e8c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e8f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e92:	75 0c                	jne    80101ea0 <namex+0xb0>
80101e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e98:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e9b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e9e:	74 f8                	je     80101e98 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101ea0:	83 ec 0c             	sub    $0xc,%esp
80101ea3:	56                   	push   %esi
80101ea4:	e8 37 f9 ff ff       	call   801017e0 <ilock>
    if(ip->type != T_DIR){
80101ea9:	83 c4 10             	add    $0x10,%esp
80101eac:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101eb1:	0f 85 cd 00 00 00    	jne    80101f84 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101eb7:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101eba:	85 c0                	test   %eax,%eax
80101ebc:	74 09                	je     80101ec7 <namex+0xd7>
80101ebe:	80 3b 00             	cmpb   $0x0,(%ebx)
80101ec1:	0f 84 22 01 00 00    	je     80101fe9 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101ec7:	83 ec 04             	sub    $0x4,%esp
80101eca:	6a 00                	push   $0x0
80101ecc:	ff 75 e4             	push   -0x1c(%ebp)
80101ecf:	56                   	push   %esi
80101ed0:	e8 6b fe ff ff       	call   80101d40 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ed5:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101ed8:	83 c4 10             	add    $0x10,%esp
80101edb:	89 c7                	mov    %eax,%edi
80101edd:	85 c0                	test   %eax,%eax
80101edf:	0f 84 e1 00 00 00    	je     80101fc6 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ee5:	83 ec 0c             	sub    $0xc,%esp
80101ee8:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101eeb:	52                   	push   %edx
80101eec:	e8 1f 2f 00 00       	call   80104e10 <holdingsleep>
80101ef1:	83 c4 10             	add    $0x10,%esp
80101ef4:	85 c0                	test   %eax,%eax
80101ef6:	0f 84 30 01 00 00    	je     8010202c <namex+0x23c>
80101efc:	8b 56 08             	mov    0x8(%esi),%edx
80101eff:	85 d2                	test   %edx,%edx
80101f01:	0f 8e 25 01 00 00    	jle    8010202c <namex+0x23c>
  releasesleep(&ip->lock);
80101f07:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101f0a:	83 ec 0c             	sub    $0xc,%esp
80101f0d:	52                   	push   %edx
80101f0e:	e8 bd 2e 00 00       	call   80104dd0 <releasesleep>
  iput(ip);
80101f13:	89 34 24             	mov    %esi,(%esp)
80101f16:	89 fe                	mov    %edi,%esi
80101f18:	e8 f3 f9 ff ff       	call   80101910 <iput>
80101f1d:	83 c4 10             	add    $0x10,%esp
80101f20:	e9 16 ff ff ff       	jmp    80101e3b <namex+0x4b>
80101f25:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101f28:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101f2b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101f2e:	83 ec 04             	sub    $0x4,%esp
80101f31:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101f34:	50                   	push   %eax
80101f35:	53                   	push   %ebx
    name[len] = 0;
80101f36:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101f38:	ff 75 e4             	push   -0x1c(%ebp)
80101f3b:	e8 50 32 00 00       	call   80105190 <memmove>
    name[len] = 0;
80101f40:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101f43:	83 c4 10             	add    $0x10,%esp
80101f46:	c6 02 00             	movb   $0x0,(%edx)
80101f49:	e9 41 ff ff ff       	jmp    80101e8f <namex+0x9f>
80101f4e:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101f50:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f53:	85 c0                	test   %eax,%eax
80101f55:	0f 85 be 00 00 00    	jne    80102019 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f5e:	89 f0                	mov    %esi,%eax
80101f60:	5b                   	pop    %ebx
80101f61:	5e                   	pop    %esi
80101f62:	5f                   	pop    %edi
80101f63:	5d                   	pop    %ebp
80101f64:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101f65:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f68:	89 df                	mov    %ebx,%edi
80101f6a:	31 c0                	xor    %eax,%eax
80101f6c:	eb c0                	jmp    80101f2e <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f6e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f73:	b8 01 00 00 00       	mov    $0x1,%eax
80101f78:	e8 33 f4 ff ff       	call   801013b0 <iget>
80101f7d:	89 c6                	mov    %eax,%esi
80101f7f:	e9 b7 fe ff ff       	jmp    80101e3b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f84:	83 ec 0c             	sub    $0xc,%esp
80101f87:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f8a:	53                   	push   %ebx
80101f8b:	e8 80 2e 00 00       	call   80104e10 <holdingsleep>
80101f90:	83 c4 10             	add    $0x10,%esp
80101f93:	85 c0                	test   %eax,%eax
80101f95:	0f 84 91 00 00 00    	je     8010202c <namex+0x23c>
80101f9b:	8b 46 08             	mov    0x8(%esi),%eax
80101f9e:	85 c0                	test   %eax,%eax
80101fa0:	0f 8e 86 00 00 00    	jle    8010202c <namex+0x23c>
  releasesleep(&ip->lock);
80101fa6:	83 ec 0c             	sub    $0xc,%esp
80101fa9:	53                   	push   %ebx
80101faa:	e8 21 2e 00 00       	call   80104dd0 <releasesleep>
  iput(ip);
80101faf:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101fb2:	31 f6                	xor    %esi,%esi
  iput(ip);
80101fb4:	e8 57 f9 ff ff       	call   80101910 <iput>
      return 0;
80101fb9:	83 c4 10             	add    $0x10,%esp
}
80101fbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fbf:	89 f0                	mov    %esi,%eax
80101fc1:	5b                   	pop    %ebx
80101fc2:	5e                   	pop    %esi
80101fc3:	5f                   	pop    %edi
80101fc4:	5d                   	pop    %ebp
80101fc5:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101fc6:	83 ec 0c             	sub    $0xc,%esp
80101fc9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101fcc:	52                   	push   %edx
80101fcd:	e8 3e 2e 00 00       	call   80104e10 <holdingsleep>
80101fd2:	83 c4 10             	add    $0x10,%esp
80101fd5:	85 c0                	test   %eax,%eax
80101fd7:	74 53                	je     8010202c <namex+0x23c>
80101fd9:	8b 4e 08             	mov    0x8(%esi),%ecx
80101fdc:	85 c9                	test   %ecx,%ecx
80101fde:	7e 4c                	jle    8010202c <namex+0x23c>
  releasesleep(&ip->lock);
80101fe0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101fe3:	83 ec 0c             	sub    $0xc,%esp
80101fe6:	52                   	push   %edx
80101fe7:	eb c1                	jmp    80101faa <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101fe9:	83 ec 0c             	sub    $0xc,%esp
80101fec:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101fef:	53                   	push   %ebx
80101ff0:	e8 1b 2e 00 00       	call   80104e10 <holdingsleep>
80101ff5:	83 c4 10             	add    $0x10,%esp
80101ff8:	85 c0                	test   %eax,%eax
80101ffa:	74 30                	je     8010202c <namex+0x23c>
80101ffc:	8b 7e 08             	mov    0x8(%esi),%edi
80101fff:	85 ff                	test   %edi,%edi
80102001:	7e 29                	jle    8010202c <namex+0x23c>
  releasesleep(&ip->lock);
80102003:	83 ec 0c             	sub    $0xc,%esp
80102006:	53                   	push   %ebx
80102007:	e8 c4 2d 00 00       	call   80104dd0 <releasesleep>
}
8010200c:	83 c4 10             	add    $0x10,%esp
}
8010200f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102012:	89 f0                	mov    %esi,%eax
80102014:	5b                   	pop    %ebx
80102015:	5e                   	pop    %esi
80102016:	5f                   	pop    %edi
80102017:	5d                   	pop    %ebp
80102018:	c3                   	ret    
    iput(ip);
80102019:	83 ec 0c             	sub    $0xc,%esp
8010201c:	56                   	push   %esi
    return 0;
8010201d:	31 f6                	xor    %esi,%esi
    iput(ip);
8010201f:	e8 ec f8 ff ff       	call   80101910 <iput>
    return 0;
80102024:	83 c4 10             	add    $0x10,%esp
80102027:	e9 2f ff ff ff       	jmp    80101f5b <namex+0x16b>
    panic("iunlock");
8010202c:	83 ec 0c             	sub    $0xc,%esp
8010202f:	68 87 7d 10 80       	push   $0x80107d87
80102034:	e8 47 e3 ff ff       	call   80100380 <panic>
80102039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102040 <dirlink>:
{
80102040:	55                   	push   %ebp
80102041:	89 e5                	mov    %esp,%ebp
80102043:	57                   	push   %edi
80102044:	56                   	push   %esi
80102045:	53                   	push   %ebx
80102046:	83 ec 20             	sub    $0x20,%esp
80102049:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010204c:	6a 00                	push   $0x0
8010204e:	ff 75 0c             	push   0xc(%ebp)
80102051:	53                   	push   %ebx
80102052:	e8 e9 fc ff ff       	call   80101d40 <dirlookup>
80102057:	83 c4 10             	add    $0x10,%esp
8010205a:	85 c0                	test   %eax,%eax
8010205c:	75 67                	jne    801020c5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010205e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102061:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102064:	85 ff                	test   %edi,%edi
80102066:	74 29                	je     80102091 <dirlink+0x51>
80102068:	31 ff                	xor    %edi,%edi
8010206a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010206d:	eb 09                	jmp    80102078 <dirlink+0x38>
8010206f:	90                   	nop
80102070:	83 c7 10             	add    $0x10,%edi
80102073:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102076:	73 19                	jae    80102091 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102078:	6a 10                	push   $0x10
8010207a:	57                   	push   %edi
8010207b:	56                   	push   %esi
8010207c:	53                   	push   %ebx
8010207d:	e8 6e fa ff ff       	call   80101af0 <readi>
80102082:	83 c4 10             	add    $0x10,%esp
80102085:	83 f8 10             	cmp    $0x10,%eax
80102088:	75 4e                	jne    801020d8 <dirlink+0x98>
    if(de.inum == 0)
8010208a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010208f:	75 df                	jne    80102070 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102091:	83 ec 04             	sub    $0x4,%esp
80102094:	8d 45 da             	lea    -0x26(%ebp),%eax
80102097:	6a 0e                	push   $0xe
80102099:	ff 75 0c             	push   0xc(%ebp)
8010209c:	50                   	push   %eax
8010209d:	e8 ae 31 00 00       	call   80105250 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020a2:	6a 10                	push   $0x10
  de.inum = inum;
801020a4:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020a7:	57                   	push   %edi
801020a8:	56                   	push   %esi
801020a9:	53                   	push   %ebx
  de.inum = inum;
801020aa:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020ae:	e8 3d fb ff ff       	call   80101bf0 <writei>
801020b3:	83 c4 20             	add    $0x20,%esp
801020b6:	83 f8 10             	cmp    $0x10,%eax
801020b9:	75 2a                	jne    801020e5 <dirlink+0xa5>
  return 0;
801020bb:	31 c0                	xor    %eax,%eax
}
801020bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020c0:	5b                   	pop    %ebx
801020c1:	5e                   	pop    %esi
801020c2:	5f                   	pop    %edi
801020c3:	5d                   	pop    %ebp
801020c4:	c3                   	ret    
    iput(ip);
801020c5:	83 ec 0c             	sub    $0xc,%esp
801020c8:	50                   	push   %eax
801020c9:	e8 42 f8 ff ff       	call   80101910 <iput>
    return -1;
801020ce:	83 c4 10             	add    $0x10,%esp
801020d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020d6:	eb e5                	jmp    801020bd <dirlink+0x7d>
      panic("dirlink read");
801020d8:	83 ec 0c             	sub    $0xc,%esp
801020db:	68 b0 7d 10 80       	push   $0x80107db0
801020e0:	e8 9b e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
801020e5:	83 ec 0c             	sub    $0xc,%esp
801020e8:	68 66 85 10 80       	push   $0x80108566
801020ed:	e8 8e e2 ff ff       	call   80100380 <panic>
801020f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102100 <namei>:

struct inode*
namei(char *path)
{
80102100:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102101:	31 d2                	xor    %edx,%edx
{
80102103:	89 e5                	mov    %esp,%ebp
80102105:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102108:	8b 45 08             	mov    0x8(%ebp),%eax
8010210b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010210e:	e8 dd fc ff ff       	call   80101df0 <namex>
}
80102113:	c9                   	leave  
80102114:	c3                   	ret    
80102115:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010211c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102120 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102120:	55                   	push   %ebp
  return namex(path, 1, name);
80102121:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102126:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102128:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010212b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010212e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010212f:	e9 bc fc ff ff       	jmp    80101df0 <namex>
80102134:	66 90                	xchg   %ax,%ax
80102136:	66 90                	xchg   %ax,%ax
80102138:	66 90                	xchg   %ax,%ax
8010213a:	66 90                	xchg   %ax,%ax
8010213c:	66 90                	xchg   %ax,%ax
8010213e:	66 90                	xchg   %ax,%ax

80102140 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102140:	55                   	push   %ebp
80102141:	89 e5                	mov    %esp,%ebp
80102143:	57                   	push   %edi
80102144:	56                   	push   %esi
80102145:	53                   	push   %ebx
80102146:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102149:	85 c0                	test   %eax,%eax
8010214b:	0f 84 b4 00 00 00    	je     80102205 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102151:	8b 70 08             	mov    0x8(%eax),%esi
80102154:	89 c3                	mov    %eax,%ebx
80102156:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010215c:	0f 87 96 00 00 00    	ja     801021f8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102162:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102167:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010216e:	66 90                	xchg   %ax,%ax
80102170:	89 ca                	mov    %ecx,%edx
80102172:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102173:	83 e0 c0             	and    $0xffffffc0,%eax
80102176:	3c 40                	cmp    $0x40,%al
80102178:	75 f6                	jne    80102170 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010217a:	31 ff                	xor    %edi,%edi
8010217c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102181:	89 f8                	mov    %edi,%eax
80102183:	ee                   	out    %al,(%dx)
80102184:	b8 01 00 00 00       	mov    $0x1,%eax
80102189:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010218e:	ee                   	out    %al,(%dx)
8010218f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102194:	89 f0                	mov    %esi,%eax
80102196:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102197:	89 f0                	mov    %esi,%eax
80102199:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010219e:	c1 f8 08             	sar    $0x8,%eax
801021a1:	ee                   	out    %al,(%dx)
801021a2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801021a7:	89 f8                	mov    %edi,%eax
801021a9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801021aa:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801021ae:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021b3:	c1 e0 04             	shl    $0x4,%eax
801021b6:	83 e0 10             	and    $0x10,%eax
801021b9:	83 c8 e0             	or     $0xffffffe0,%eax
801021bc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801021bd:	f6 03 04             	testb  $0x4,(%ebx)
801021c0:	75 16                	jne    801021d8 <idestart+0x98>
801021c2:	b8 20 00 00 00       	mov    $0x20,%eax
801021c7:	89 ca                	mov    %ecx,%edx
801021c9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801021ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021cd:	5b                   	pop    %ebx
801021ce:	5e                   	pop    %esi
801021cf:	5f                   	pop    %edi
801021d0:	5d                   	pop    %ebp
801021d1:	c3                   	ret    
801021d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801021d8:	b8 30 00 00 00       	mov    $0x30,%eax
801021dd:	89 ca                	mov    %ecx,%edx
801021df:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801021e0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801021e5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801021e8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021ed:	fc                   	cld    
801021ee:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801021f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021f3:	5b                   	pop    %ebx
801021f4:	5e                   	pop    %esi
801021f5:	5f                   	pop    %edi
801021f6:	5d                   	pop    %ebp
801021f7:	c3                   	ret    
    panic("incorrect blockno");
801021f8:	83 ec 0c             	sub    $0xc,%esp
801021fb:	68 1c 7e 10 80       	push   $0x80107e1c
80102200:	e8 7b e1 ff ff       	call   80100380 <panic>
    panic("idestart");
80102205:	83 ec 0c             	sub    $0xc,%esp
80102208:	68 13 7e 10 80       	push   $0x80107e13
8010220d:	e8 6e e1 ff ff       	call   80100380 <panic>
80102212:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102220 <ideinit>:
{
80102220:	55                   	push   %ebp
80102221:	89 e5                	mov    %esp,%ebp
80102223:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102226:	68 2e 7e 10 80       	push   $0x80107e2e
8010222b:	68 00 26 11 80       	push   $0x80112600
80102230:	e8 2b 2c 00 00       	call   80104e60 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102235:	58                   	pop    %eax
80102236:	a1 84 27 11 80       	mov    0x80112784,%eax
8010223b:	5a                   	pop    %edx
8010223c:	83 e8 01             	sub    $0x1,%eax
8010223f:	50                   	push   %eax
80102240:	6a 0e                	push   $0xe
80102242:	e8 99 02 00 00       	call   801024e0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102247:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010224a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010224f:	90                   	nop
80102250:	ec                   	in     (%dx),%al
80102251:	83 e0 c0             	and    $0xffffffc0,%eax
80102254:	3c 40                	cmp    $0x40,%al
80102256:	75 f8                	jne    80102250 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102258:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010225d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102262:	ee                   	out    %al,(%dx)
80102263:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102268:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010226d:	eb 06                	jmp    80102275 <ideinit+0x55>
8010226f:	90                   	nop
  for(i=0; i<1000; i++){
80102270:	83 e9 01             	sub    $0x1,%ecx
80102273:	74 0f                	je     80102284 <ideinit+0x64>
80102275:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102276:	84 c0                	test   %al,%al
80102278:	74 f6                	je     80102270 <ideinit+0x50>
      havedisk1 = 1;
8010227a:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
80102281:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102284:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102289:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010228e:	ee                   	out    %al,(%dx)
}
8010228f:	c9                   	leave  
80102290:	c3                   	ret    
80102291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102298:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010229f:	90                   	nop

801022a0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801022a0:	55                   	push   %ebp
801022a1:	89 e5                	mov    %esp,%ebp
801022a3:	57                   	push   %edi
801022a4:	56                   	push   %esi
801022a5:	53                   	push   %ebx
801022a6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801022a9:	68 00 26 11 80       	push   $0x80112600
801022ae:	e8 7d 2d 00 00       	call   80105030 <acquire>

  if((b = idequeue) == 0){
801022b3:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
801022b9:	83 c4 10             	add    $0x10,%esp
801022bc:	85 db                	test   %ebx,%ebx
801022be:	74 63                	je     80102323 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801022c0:	8b 43 58             	mov    0x58(%ebx),%eax
801022c3:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801022c8:	8b 33                	mov    (%ebx),%esi
801022ca:	f7 c6 04 00 00 00    	test   $0x4,%esi
801022d0:	75 2f                	jne    80102301 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022d2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022de:	66 90                	xchg   %ax,%ax
801022e0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022e1:	89 c1                	mov    %eax,%ecx
801022e3:	83 e1 c0             	and    $0xffffffc0,%ecx
801022e6:	80 f9 40             	cmp    $0x40,%cl
801022e9:	75 f5                	jne    801022e0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801022eb:	a8 21                	test   $0x21,%al
801022ed:	75 12                	jne    80102301 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801022ef:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801022f2:	b9 80 00 00 00       	mov    $0x80,%ecx
801022f7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022fc:	fc                   	cld    
801022fd:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801022ff:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102301:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102304:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102307:	83 ce 02             	or     $0x2,%esi
8010230a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010230c:	53                   	push   %ebx
8010230d:	e8 be 21 00 00       	call   801044d0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102312:	a1 e4 25 11 80       	mov    0x801125e4,%eax
80102317:	83 c4 10             	add    $0x10,%esp
8010231a:	85 c0                	test   %eax,%eax
8010231c:	74 05                	je     80102323 <ideintr+0x83>
    idestart(idequeue);
8010231e:	e8 1d fe ff ff       	call   80102140 <idestart>
    release(&idelock);
80102323:	83 ec 0c             	sub    $0xc,%esp
80102326:	68 00 26 11 80       	push   $0x80112600
8010232b:	e8 a0 2c 00 00       	call   80104fd0 <release>

  release(&idelock);
}
80102330:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102333:	5b                   	pop    %ebx
80102334:	5e                   	pop    %esi
80102335:	5f                   	pop    %edi
80102336:	5d                   	pop    %ebp
80102337:	c3                   	ret    
80102338:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010233f:	90                   	nop

80102340 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102340:	55                   	push   %ebp
80102341:	89 e5                	mov    %esp,%ebp
80102343:	53                   	push   %ebx
80102344:	83 ec 10             	sub    $0x10,%esp
80102347:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010234a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010234d:	50                   	push   %eax
8010234e:	e8 bd 2a 00 00       	call   80104e10 <holdingsleep>
80102353:	83 c4 10             	add    $0x10,%esp
80102356:	85 c0                	test   %eax,%eax
80102358:	0f 84 c3 00 00 00    	je     80102421 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010235e:	8b 03                	mov    (%ebx),%eax
80102360:	83 e0 06             	and    $0x6,%eax
80102363:	83 f8 02             	cmp    $0x2,%eax
80102366:	0f 84 a8 00 00 00    	je     80102414 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010236c:	8b 53 04             	mov    0x4(%ebx),%edx
8010236f:	85 d2                	test   %edx,%edx
80102371:	74 0d                	je     80102380 <iderw+0x40>
80102373:	a1 e0 25 11 80       	mov    0x801125e0,%eax
80102378:	85 c0                	test   %eax,%eax
8010237a:	0f 84 87 00 00 00    	je     80102407 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102380:	83 ec 0c             	sub    $0xc,%esp
80102383:	68 00 26 11 80       	push   $0x80112600
80102388:	e8 a3 2c 00 00       	call   80105030 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010238d:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
80102392:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102399:	83 c4 10             	add    $0x10,%esp
8010239c:	85 c0                	test   %eax,%eax
8010239e:	74 60                	je     80102400 <iderw+0xc0>
801023a0:	89 c2                	mov    %eax,%edx
801023a2:	8b 40 58             	mov    0x58(%eax),%eax
801023a5:	85 c0                	test   %eax,%eax
801023a7:	75 f7                	jne    801023a0 <iderw+0x60>
801023a9:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801023ac:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801023ae:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
801023b4:	74 3a                	je     801023f0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023b6:	8b 03                	mov    (%ebx),%eax
801023b8:	83 e0 06             	and    $0x6,%eax
801023bb:	83 f8 02             	cmp    $0x2,%eax
801023be:	74 1b                	je     801023db <iderw+0x9b>
    sleep(b, &idelock);
801023c0:	83 ec 08             	sub    $0x8,%esp
801023c3:	68 00 26 11 80       	push   $0x80112600
801023c8:	53                   	push   %ebx
801023c9:	e8 42 20 00 00       	call   80104410 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023ce:	8b 03                	mov    (%ebx),%eax
801023d0:	83 c4 10             	add    $0x10,%esp
801023d3:	83 e0 06             	and    $0x6,%eax
801023d6:	83 f8 02             	cmp    $0x2,%eax
801023d9:	75 e5                	jne    801023c0 <iderw+0x80>
  }


  release(&idelock);
801023db:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
801023e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023e5:	c9                   	leave  
  release(&idelock);
801023e6:	e9 e5 2b 00 00       	jmp    80104fd0 <release>
801023eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023ef:	90                   	nop
    idestart(b);
801023f0:	89 d8                	mov    %ebx,%eax
801023f2:	e8 49 fd ff ff       	call   80102140 <idestart>
801023f7:	eb bd                	jmp    801023b6 <iderw+0x76>
801023f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102400:	ba e4 25 11 80       	mov    $0x801125e4,%edx
80102405:	eb a5                	jmp    801023ac <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102407:	83 ec 0c             	sub    $0xc,%esp
8010240a:	68 5d 7e 10 80       	push   $0x80107e5d
8010240f:	e8 6c df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
80102414:	83 ec 0c             	sub    $0xc,%esp
80102417:	68 48 7e 10 80       	push   $0x80107e48
8010241c:	e8 5f df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
80102421:	83 ec 0c             	sub    $0xc,%esp
80102424:	68 32 7e 10 80       	push   $0x80107e32
80102429:	e8 52 df ff ff       	call   80100380 <panic>
8010242e:	66 90                	xchg   %ax,%ax

80102430 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102430:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102431:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
80102438:	00 c0 fe 
{
8010243b:	89 e5                	mov    %esp,%ebp
8010243d:	56                   	push   %esi
8010243e:	53                   	push   %ebx
  ioapic->reg = reg;
8010243f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102446:	00 00 00 
  return ioapic->data;
80102449:	8b 15 34 26 11 80    	mov    0x80112634,%edx
8010244f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102452:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102458:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010245e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102465:	c1 ee 10             	shr    $0x10,%esi
80102468:	89 f0                	mov    %esi,%eax
8010246a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010246d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102470:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102473:	39 c2                	cmp    %eax,%edx
80102475:	74 16                	je     8010248d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102477:	83 ec 0c             	sub    $0xc,%esp
8010247a:	68 7c 7e 10 80       	push   $0x80107e7c
8010247f:	e8 1c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102484:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010248a:	83 c4 10             	add    $0x10,%esp
8010248d:	83 c6 21             	add    $0x21,%esi
{
80102490:	ba 10 00 00 00       	mov    $0x10,%edx
80102495:	b8 20 00 00 00       	mov    $0x20,%eax
8010249a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
801024a0:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801024a2:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
801024a4:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
801024aa:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801024ad:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
801024b3:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
801024b6:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
801024b9:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
801024bc:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
801024be:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801024c4:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801024cb:	39 f0                	cmp    %esi,%eax
801024cd:	75 d1                	jne    801024a0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801024cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024d2:	5b                   	pop    %ebx
801024d3:	5e                   	pop    %esi
801024d4:	5d                   	pop    %ebp
801024d5:	c3                   	ret    
801024d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024dd:	8d 76 00             	lea    0x0(%esi),%esi

801024e0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801024e0:	55                   	push   %ebp
  ioapic->reg = reg;
801024e1:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
801024e7:	89 e5                	mov    %esp,%ebp
801024e9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801024ec:	8d 50 20             	lea    0x20(%eax),%edx
801024ef:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801024f3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024f5:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024fb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801024fe:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102501:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102504:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102506:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010250b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010250e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102511:	5d                   	pop    %ebp
80102512:	c3                   	ret    
80102513:	66 90                	xchg   %ax,%ax
80102515:	66 90                	xchg   %ax,%ax
80102517:	66 90                	xchg   %ax,%ax
80102519:	66 90                	xchg   %ax,%ax
8010251b:	66 90                	xchg   %ax,%ax
8010251d:	66 90                	xchg   %ax,%ax
8010251f:	90                   	nop

80102520 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102520:	55                   	push   %ebp
80102521:	89 e5                	mov    %esp,%ebp
80102523:	53                   	push   %ebx
80102524:	83 ec 04             	sub    $0x4,%esp
80102527:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010252a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102530:	75 76                	jne    801025a8 <kfree+0x88>
80102532:	81 fb f0 69 11 80    	cmp    $0x801169f0,%ebx
80102538:	72 6e                	jb     801025a8 <kfree+0x88>
8010253a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102540:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102545:	77 61                	ja     801025a8 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102547:	83 ec 04             	sub    $0x4,%esp
8010254a:	68 00 10 00 00       	push   $0x1000
8010254f:	6a 01                	push   $0x1
80102551:	53                   	push   %ebx
80102552:	e8 99 2b 00 00       	call   801050f0 <memset>

  if(kmem.use_lock)
80102557:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010255d:	83 c4 10             	add    $0x10,%esp
80102560:	85 d2                	test   %edx,%edx
80102562:	75 1c                	jne    80102580 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102564:	a1 78 26 11 80       	mov    0x80112678,%eax
80102569:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010256b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102570:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102576:	85 c0                	test   %eax,%eax
80102578:	75 1e                	jne    80102598 <kfree+0x78>
    release(&kmem.lock);
}
8010257a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010257d:	c9                   	leave  
8010257e:	c3                   	ret    
8010257f:	90                   	nop
    acquire(&kmem.lock);
80102580:	83 ec 0c             	sub    $0xc,%esp
80102583:	68 40 26 11 80       	push   $0x80112640
80102588:	e8 a3 2a 00 00       	call   80105030 <acquire>
8010258d:	83 c4 10             	add    $0x10,%esp
80102590:	eb d2                	jmp    80102564 <kfree+0x44>
80102592:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102598:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010259f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025a2:	c9                   	leave  
    release(&kmem.lock);
801025a3:	e9 28 2a 00 00       	jmp    80104fd0 <release>
    panic("kfree");
801025a8:	83 ec 0c             	sub    $0xc,%esp
801025ab:	68 ae 7e 10 80       	push   $0x80107eae
801025b0:	e8 cb dd ff ff       	call   80100380 <panic>
801025b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801025c0 <freerange>:
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025c4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025c7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ca:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025dd:	39 de                	cmp    %ebx,%esi
801025df:	72 23                	jb     80102604 <freerange+0x44>
801025e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025e8:	83 ec 0c             	sub    $0xc,%esp
801025eb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025f7:	50                   	push   %eax
801025f8:	e8 23 ff ff ff       	call   80102520 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025fd:	83 c4 10             	add    $0x10,%esp
80102600:	39 f3                	cmp    %esi,%ebx
80102602:	76 e4                	jbe    801025e8 <freerange+0x28>
}
80102604:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102607:	5b                   	pop    %ebx
80102608:	5e                   	pop    %esi
80102609:	5d                   	pop    %ebp
8010260a:	c3                   	ret    
8010260b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010260f:	90                   	nop

80102610 <kinit2>:
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102614:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102617:	8b 75 0c             	mov    0xc(%ebp),%esi
8010261a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010261b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102621:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102627:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010262d:	39 de                	cmp    %ebx,%esi
8010262f:	72 23                	jb     80102654 <kinit2+0x44>
80102631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102638:	83 ec 0c             	sub    $0xc,%esp
8010263b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102641:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102647:	50                   	push   %eax
80102648:	e8 d3 fe ff ff       	call   80102520 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010264d:	83 c4 10             	add    $0x10,%esp
80102650:	39 de                	cmp    %ebx,%esi
80102652:	73 e4                	jae    80102638 <kinit2+0x28>
  kmem.use_lock = 1;
80102654:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010265b:	00 00 00 
}
8010265e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102661:	5b                   	pop    %ebx
80102662:	5e                   	pop    %esi
80102663:	5d                   	pop    %ebp
80102664:	c3                   	ret    
80102665:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010266c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102670 <kinit1>:
{
80102670:	55                   	push   %ebp
80102671:	89 e5                	mov    %esp,%ebp
80102673:	56                   	push   %esi
80102674:	53                   	push   %ebx
80102675:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102678:	83 ec 08             	sub    $0x8,%esp
8010267b:	68 b4 7e 10 80       	push   $0x80107eb4
80102680:	68 40 26 11 80       	push   $0x80112640
80102685:	e8 d6 27 00 00       	call   80104e60 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010268a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010268d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102690:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102697:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010269a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026a0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026a6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026ac:	39 de                	cmp    %ebx,%esi
801026ae:	72 1c                	jb     801026cc <kinit1+0x5c>
    kfree(p);
801026b0:	83 ec 0c             	sub    $0xc,%esp
801026b3:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026b9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026bf:	50                   	push   %eax
801026c0:	e8 5b fe ff ff       	call   80102520 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026c5:	83 c4 10             	add    $0x10,%esp
801026c8:	39 de                	cmp    %ebx,%esi
801026ca:	73 e4                	jae    801026b0 <kinit1+0x40>
}
801026cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026cf:	5b                   	pop    %ebx
801026d0:	5e                   	pop    %esi
801026d1:	5d                   	pop    %ebp
801026d2:	c3                   	ret    
801026d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801026e0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801026e0:	a1 74 26 11 80       	mov    0x80112674,%eax
801026e5:	85 c0                	test   %eax,%eax
801026e7:	75 1f                	jne    80102708 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801026e9:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
801026ee:	85 c0                	test   %eax,%eax
801026f0:	74 0e                	je     80102700 <kalloc+0x20>
    kmem.freelist = r->next;
801026f2:	8b 10                	mov    (%eax),%edx
801026f4:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801026fa:	c3                   	ret    
801026fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026ff:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102700:	c3                   	ret    
80102701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102708:	55                   	push   %ebp
80102709:	89 e5                	mov    %esp,%ebp
8010270b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010270e:	68 40 26 11 80       	push   $0x80112640
80102713:	e8 18 29 00 00       	call   80105030 <acquire>
  r = kmem.freelist;
80102718:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(kmem.use_lock)
8010271d:	8b 15 74 26 11 80    	mov    0x80112674,%edx
  if(r)
80102723:	83 c4 10             	add    $0x10,%esp
80102726:	85 c0                	test   %eax,%eax
80102728:	74 08                	je     80102732 <kalloc+0x52>
    kmem.freelist = r->next;
8010272a:	8b 08                	mov    (%eax),%ecx
8010272c:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
80102732:	85 d2                	test   %edx,%edx
80102734:	74 16                	je     8010274c <kalloc+0x6c>
    release(&kmem.lock);
80102736:	83 ec 0c             	sub    $0xc,%esp
80102739:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010273c:	68 40 26 11 80       	push   $0x80112640
80102741:	e8 8a 28 00 00       	call   80104fd0 <release>
  return (char*)r;
80102746:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102749:	83 c4 10             	add    $0x10,%esp
}
8010274c:	c9                   	leave  
8010274d:	c3                   	ret    
8010274e:	66 90                	xchg   %ax,%ax

80102750 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102750:	ba 64 00 00 00       	mov    $0x64,%edx
80102755:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102756:	a8 01                	test   $0x1,%al
80102758:	0f 84 c2 00 00 00    	je     80102820 <kbdgetc+0xd0>
{
8010275e:	55                   	push   %ebp
8010275f:	ba 60 00 00 00       	mov    $0x60,%edx
80102764:	89 e5                	mov    %esp,%ebp
80102766:	53                   	push   %ebx
80102767:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102768:	8b 1d 7c 26 11 80    	mov    0x8011267c,%ebx
  data = inb(KBDATAP);
8010276e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102771:	3c e0                	cmp    $0xe0,%al
80102773:	74 5b                	je     801027d0 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102775:	89 da                	mov    %ebx,%edx
80102777:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010277a:	84 c0                	test   %al,%al
8010277c:	78 62                	js     801027e0 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010277e:	85 d2                	test   %edx,%edx
80102780:	74 09                	je     8010278b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102782:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102785:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102788:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010278b:	0f b6 91 e0 7f 10 80 	movzbl -0x7fef8020(%ecx),%edx
  shift ^= togglecode[data];
80102792:	0f b6 81 e0 7e 10 80 	movzbl -0x7fef8120(%ecx),%eax
  shift |= shiftcode[data];
80102799:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010279b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010279d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010279f:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  c = charcode[shift & (CTL | SHIFT)][data];
801027a5:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801027a8:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801027ab:	8b 04 85 c0 7e 10 80 	mov    -0x7fef8140(,%eax,4),%eax
801027b2:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801027b6:	74 0b                	je     801027c3 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
801027b8:	8d 50 9f             	lea    -0x61(%eax),%edx
801027bb:	83 fa 19             	cmp    $0x19,%edx
801027be:	77 48                	ja     80102808 <kbdgetc+0xb8>
      c += 'A' - 'a';
801027c0:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801027c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027c6:	c9                   	leave  
801027c7:	c3                   	ret    
801027c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027cf:	90                   	nop
    shift |= E0ESC;
801027d0:	83 cb 40             	or     $0x40,%ebx
    return 0;
801027d3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801027d5:	89 1d 7c 26 11 80    	mov    %ebx,0x8011267c
}
801027db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027de:	c9                   	leave  
801027df:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
801027e0:	83 e0 7f             	and    $0x7f,%eax
801027e3:	85 d2                	test   %edx,%edx
801027e5:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
801027e8:	0f b6 81 e0 7f 10 80 	movzbl -0x7fef8020(%ecx),%eax
801027ef:	83 c8 40             	or     $0x40,%eax
801027f2:	0f b6 c0             	movzbl %al,%eax
801027f5:	f7 d0                	not    %eax
801027f7:	21 d8                	and    %ebx,%eax
}
801027f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
801027fc:	a3 7c 26 11 80       	mov    %eax,0x8011267c
    return 0;
80102801:	31 c0                	xor    %eax,%eax
}
80102803:	c9                   	leave  
80102804:	c3                   	ret    
80102805:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102808:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010280b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010280e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102811:	c9                   	leave  
      c += 'a' - 'A';
80102812:	83 f9 1a             	cmp    $0x1a,%ecx
80102815:	0f 42 c2             	cmovb  %edx,%eax
}
80102818:	c3                   	ret    
80102819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102820:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102825:	c3                   	ret    
80102826:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010282d:	8d 76 00             	lea    0x0(%esi),%esi

80102830 <kbdintr>:

void
kbdintr(void)
{
80102830:	55                   	push   %ebp
80102831:	89 e5                	mov    %esp,%ebp
80102833:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102836:	68 50 27 10 80       	push   $0x80102750
8010283b:	e8 40 e0 ff ff       	call   80100880 <consoleintr>
}
80102840:	83 c4 10             	add    $0x10,%esp
80102843:	c9                   	leave  
80102844:	c3                   	ret    
80102845:	66 90                	xchg   %ax,%ax
80102847:	66 90                	xchg   %ax,%ax
80102849:	66 90                	xchg   %ax,%ax
8010284b:	66 90                	xchg   %ax,%ax
8010284d:	66 90                	xchg   %ax,%ax
8010284f:	90                   	nop

80102850 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102850:	a1 80 26 11 80       	mov    0x80112680,%eax
80102855:	85 c0                	test   %eax,%eax
80102857:	0f 84 cb 00 00 00    	je     80102928 <lapicinit+0xd8>
  lapic[index] = value;
8010285d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102864:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102867:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010286a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102871:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102874:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102877:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010287e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102881:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102884:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010288b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010288e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102891:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102898:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010289b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010289e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801028a5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028a8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801028ab:	8b 50 30             	mov    0x30(%eax),%edx
801028ae:	c1 ea 10             	shr    $0x10,%edx
801028b1:	81 e2 fc 00 00 00    	and    $0xfc,%edx
801028b7:	75 77                	jne    80102930 <lapicinit+0xe0>
  lapic[index] = value;
801028b9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801028c0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028c6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028cd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028d0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028d3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028da:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028dd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028e0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028e7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028ea:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ed:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801028f4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028f7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028fa:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102901:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102904:	8b 50 20             	mov    0x20(%eax),%edx
80102907:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010290e:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102910:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102916:	80 e6 10             	and    $0x10,%dh
80102919:	75 f5                	jne    80102910 <lapicinit+0xc0>
  lapic[index] = value;
8010291b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102922:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102925:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102928:	c3                   	ret    
80102929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102930:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102937:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010293a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010293d:	e9 77 ff ff ff       	jmp    801028b9 <lapicinit+0x69>
80102942:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102950 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102950:	a1 80 26 11 80       	mov    0x80112680,%eax
80102955:	85 c0                	test   %eax,%eax
80102957:	74 07                	je     80102960 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102959:	8b 40 20             	mov    0x20(%eax),%eax
8010295c:	c1 e8 18             	shr    $0x18,%eax
8010295f:	c3                   	ret    
    return 0;
80102960:	31 c0                	xor    %eax,%eax
}
80102962:	c3                   	ret    
80102963:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010296a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102970 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102970:	a1 80 26 11 80       	mov    0x80112680,%eax
80102975:	85 c0                	test   %eax,%eax
80102977:	74 0d                	je     80102986 <lapiceoi+0x16>
  lapic[index] = value;
80102979:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102980:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102983:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102986:	c3                   	ret    
80102987:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010298e:	66 90                	xchg   %ax,%ax

80102990 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102990:	c3                   	ret    
80102991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102998:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010299f:	90                   	nop

801029a0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801029a0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029a1:	b8 0f 00 00 00       	mov    $0xf,%eax
801029a6:	ba 70 00 00 00       	mov    $0x70,%edx
801029ab:	89 e5                	mov    %esp,%ebp
801029ad:	53                   	push   %ebx
801029ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801029b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801029b4:	ee                   	out    %al,(%dx)
801029b5:	b8 0a 00 00 00       	mov    $0xa,%eax
801029ba:	ba 71 00 00 00       	mov    $0x71,%edx
801029bf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801029c0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801029c2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801029c5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801029cb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801029cd:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
801029d0:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
801029d2:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
801029d5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801029d8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801029de:	a1 80 26 11 80       	mov    0x80112680,%eax
801029e3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029e9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029ec:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801029f3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029f6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029f9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102a00:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a03:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a06:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a0c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a0f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a15:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a18:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a1e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a21:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a27:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102a2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a2d:	c9                   	leave  
80102a2e:	c3                   	ret    
80102a2f:	90                   	nop

80102a30 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102a30:	55                   	push   %ebp
80102a31:	b8 0b 00 00 00       	mov    $0xb,%eax
80102a36:	ba 70 00 00 00       	mov    $0x70,%edx
80102a3b:	89 e5                	mov    %esp,%ebp
80102a3d:	57                   	push   %edi
80102a3e:	56                   	push   %esi
80102a3f:	53                   	push   %ebx
80102a40:	83 ec 4c             	sub    $0x4c,%esp
80102a43:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a44:	ba 71 00 00 00       	mov    $0x71,%edx
80102a49:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102a4a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a4d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102a52:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a55:	8d 76 00             	lea    0x0(%esi),%esi
80102a58:	31 c0                	xor    %eax,%eax
80102a5a:	89 da                	mov    %ebx,%edx
80102a5c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a5d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a62:	89 ca                	mov    %ecx,%edx
80102a64:	ec                   	in     (%dx),%al
80102a65:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a68:	89 da                	mov    %ebx,%edx
80102a6a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a6f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a70:	89 ca                	mov    %ecx,%edx
80102a72:	ec                   	in     (%dx),%al
80102a73:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a76:	89 da                	mov    %ebx,%edx
80102a78:	b8 04 00 00 00       	mov    $0x4,%eax
80102a7d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a7e:	89 ca                	mov    %ecx,%edx
80102a80:	ec                   	in     (%dx),%al
80102a81:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a84:	89 da                	mov    %ebx,%edx
80102a86:	b8 07 00 00 00       	mov    $0x7,%eax
80102a8b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8c:	89 ca                	mov    %ecx,%edx
80102a8e:	ec                   	in     (%dx),%al
80102a8f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a92:	89 da                	mov    %ebx,%edx
80102a94:	b8 08 00 00 00       	mov    $0x8,%eax
80102a99:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9a:	89 ca                	mov    %ecx,%edx
80102a9c:	ec                   	in     (%dx),%al
80102a9d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a9f:	89 da                	mov    %ebx,%edx
80102aa1:	b8 09 00 00 00       	mov    $0x9,%eax
80102aa6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa7:	89 ca                	mov    %ecx,%edx
80102aa9:	ec                   	in     (%dx),%al
80102aaa:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aac:	89 da                	mov    %ebx,%edx
80102aae:	b8 0a 00 00 00       	mov    $0xa,%eax
80102ab3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ab4:	89 ca                	mov    %ecx,%edx
80102ab6:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102ab7:	84 c0                	test   %al,%al
80102ab9:	78 9d                	js     80102a58 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102abb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102abf:	89 fa                	mov    %edi,%edx
80102ac1:	0f b6 fa             	movzbl %dl,%edi
80102ac4:	89 f2                	mov    %esi,%edx
80102ac6:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102ac9:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102acd:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad0:	89 da                	mov    %ebx,%edx
80102ad2:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102ad5:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102ad8:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102adc:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102adf:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102ae2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102ae6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102ae9:	31 c0                	xor    %eax,%eax
80102aeb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aec:	89 ca                	mov    %ecx,%edx
80102aee:	ec                   	in     (%dx),%al
80102aef:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102af2:	89 da                	mov    %ebx,%edx
80102af4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102af7:	b8 02 00 00 00       	mov    $0x2,%eax
80102afc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102afd:	89 ca                	mov    %ecx,%edx
80102aff:	ec                   	in     (%dx),%al
80102b00:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b03:	89 da                	mov    %ebx,%edx
80102b05:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102b08:	b8 04 00 00 00       	mov    $0x4,%eax
80102b0d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b0e:	89 ca                	mov    %ecx,%edx
80102b10:	ec                   	in     (%dx),%al
80102b11:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b14:	89 da                	mov    %ebx,%edx
80102b16:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102b19:	b8 07 00 00 00       	mov    $0x7,%eax
80102b1e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b1f:	89 ca                	mov    %ecx,%edx
80102b21:	ec                   	in     (%dx),%al
80102b22:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b25:	89 da                	mov    %ebx,%edx
80102b27:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102b2a:	b8 08 00 00 00       	mov    $0x8,%eax
80102b2f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b30:	89 ca                	mov    %ecx,%edx
80102b32:	ec                   	in     (%dx),%al
80102b33:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b36:	89 da                	mov    %ebx,%edx
80102b38:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102b3b:	b8 09 00 00 00       	mov    $0x9,%eax
80102b40:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b41:	89 ca                	mov    %ecx,%edx
80102b43:	ec                   	in     (%dx),%al
80102b44:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b47:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102b4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b4d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b50:	6a 18                	push   $0x18
80102b52:	50                   	push   %eax
80102b53:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b56:	50                   	push   %eax
80102b57:	e8 e4 25 00 00       	call   80105140 <memcmp>
80102b5c:	83 c4 10             	add    $0x10,%esp
80102b5f:	85 c0                	test   %eax,%eax
80102b61:	0f 85 f1 fe ff ff    	jne    80102a58 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b67:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b6b:	75 78                	jne    80102be5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b6d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b70:	89 c2                	mov    %eax,%edx
80102b72:	83 e0 0f             	and    $0xf,%eax
80102b75:	c1 ea 04             	shr    $0x4,%edx
80102b78:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b7b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b7e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b81:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b84:	89 c2                	mov    %eax,%edx
80102b86:	83 e0 0f             	and    $0xf,%eax
80102b89:	c1 ea 04             	shr    $0x4,%edx
80102b8c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b8f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b92:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b95:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b98:	89 c2                	mov    %eax,%edx
80102b9a:	83 e0 0f             	and    $0xf,%eax
80102b9d:	c1 ea 04             	shr    $0x4,%edx
80102ba0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ba3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ba6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102ba9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bac:	89 c2                	mov    %eax,%edx
80102bae:	83 e0 0f             	and    $0xf,%eax
80102bb1:	c1 ea 04             	shr    $0x4,%edx
80102bb4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bb7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bba:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102bbd:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bc0:	89 c2                	mov    %eax,%edx
80102bc2:	83 e0 0f             	and    $0xf,%eax
80102bc5:	c1 ea 04             	shr    $0x4,%edx
80102bc8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bcb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bce:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102bd1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bd4:	89 c2                	mov    %eax,%edx
80102bd6:	83 e0 0f             	and    $0xf,%eax
80102bd9:	c1 ea 04             	shr    $0x4,%edx
80102bdc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bdf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102be2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102be5:	8b 75 08             	mov    0x8(%ebp),%esi
80102be8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102beb:	89 06                	mov    %eax,(%esi)
80102bed:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102bf0:	89 46 04             	mov    %eax,0x4(%esi)
80102bf3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102bf6:	89 46 08             	mov    %eax,0x8(%esi)
80102bf9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bfc:	89 46 0c             	mov    %eax,0xc(%esi)
80102bff:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c02:	89 46 10             	mov    %eax,0x10(%esi)
80102c05:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c08:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102c0b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102c12:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c15:	5b                   	pop    %ebx
80102c16:	5e                   	pop    %esi
80102c17:	5f                   	pop    %edi
80102c18:	5d                   	pop    %ebp
80102c19:	c3                   	ret    
80102c1a:	66 90                	xchg   %ax,%ax
80102c1c:	66 90                	xchg   %ax,%ax
80102c1e:	66 90                	xchg   %ax,%ax

80102c20 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c20:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102c26:	85 c9                	test   %ecx,%ecx
80102c28:	0f 8e 8a 00 00 00    	jle    80102cb8 <install_trans+0x98>
{
80102c2e:	55                   	push   %ebp
80102c2f:	89 e5                	mov    %esp,%ebp
80102c31:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102c32:	31 ff                	xor    %edi,%edi
{
80102c34:	56                   	push   %esi
80102c35:	53                   	push   %ebx
80102c36:	83 ec 0c             	sub    $0xc,%esp
80102c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c40:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102c45:	83 ec 08             	sub    $0x8,%esp
80102c48:	01 f8                	add    %edi,%eax
80102c4a:	83 c0 01             	add    $0x1,%eax
80102c4d:	50                   	push   %eax
80102c4e:	ff 35 e4 26 11 80    	push   0x801126e4
80102c54:	e8 77 d4 ff ff       	call   801000d0 <bread>
80102c59:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c5b:	58                   	pop    %eax
80102c5c:	5a                   	pop    %edx
80102c5d:	ff 34 bd ec 26 11 80 	push   -0x7feed914(,%edi,4)
80102c64:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c6a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c6d:	e8 5e d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c72:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c75:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c77:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c7a:	68 00 02 00 00       	push   $0x200
80102c7f:	50                   	push   %eax
80102c80:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c83:	50                   	push   %eax
80102c84:	e8 07 25 00 00       	call   80105190 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c89:	89 1c 24             	mov    %ebx,(%esp)
80102c8c:	e8 1f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c91:	89 34 24             	mov    %esi,(%esp)
80102c94:	e8 57 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c99:	89 1c 24             	mov    %ebx,(%esp)
80102c9c:	e8 4f d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ca1:	83 c4 10             	add    $0x10,%esp
80102ca4:	39 3d e8 26 11 80    	cmp    %edi,0x801126e8
80102caa:	7f 94                	jg     80102c40 <install_trans+0x20>
  }
}
80102cac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102caf:	5b                   	pop    %ebx
80102cb0:	5e                   	pop    %esi
80102cb1:	5f                   	pop    %edi
80102cb2:	5d                   	pop    %ebp
80102cb3:	c3                   	ret    
80102cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cb8:	c3                   	ret    
80102cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102cc0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102cc0:	55                   	push   %ebp
80102cc1:	89 e5                	mov    %esp,%ebp
80102cc3:	53                   	push   %ebx
80102cc4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102cc7:	ff 35 d4 26 11 80    	push   0x801126d4
80102ccd:	ff 35 e4 26 11 80    	push   0x801126e4
80102cd3:	e8 f8 d3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102cd8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102cdb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102cdd:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102ce2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102ce5:	85 c0                	test   %eax,%eax
80102ce7:	7e 19                	jle    80102d02 <write_head+0x42>
80102ce9:	31 d2                	xor    %edx,%edx
80102ceb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cef:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102cf0:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102cf7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102cfb:	83 c2 01             	add    $0x1,%edx
80102cfe:	39 d0                	cmp    %edx,%eax
80102d00:	75 ee                	jne    80102cf0 <write_head+0x30>
  }
  bwrite(buf);
80102d02:	83 ec 0c             	sub    $0xc,%esp
80102d05:	53                   	push   %ebx
80102d06:	e8 a5 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102d0b:	89 1c 24             	mov    %ebx,(%esp)
80102d0e:	e8 dd d4 ff ff       	call   801001f0 <brelse>
}
80102d13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d16:	83 c4 10             	add    $0x10,%esp
80102d19:	c9                   	leave  
80102d1a:	c3                   	ret    
80102d1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d1f:	90                   	nop

80102d20 <initlog>:
{
80102d20:	55                   	push   %ebp
80102d21:	89 e5                	mov    %esp,%ebp
80102d23:	53                   	push   %ebx
80102d24:	83 ec 2c             	sub    $0x2c,%esp
80102d27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102d2a:	68 e0 80 10 80       	push   $0x801080e0
80102d2f:	68 a0 26 11 80       	push   $0x801126a0
80102d34:	e8 27 21 00 00       	call   80104e60 <initlock>
  readsb(dev, &sb);
80102d39:	58                   	pop    %eax
80102d3a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102d3d:	5a                   	pop    %edx
80102d3e:	50                   	push   %eax
80102d3f:	53                   	push   %ebx
80102d40:	e8 3b e8 ff ff       	call   80101580 <readsb>
  log.start = sb.logstart;
80102d45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102d48:	59                   	pop    %ecx
  log.dev = dev;
80102d49:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  log.size = sb.nlog;
80102d4f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d52:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  log.size = sb.nlog;
80102d57:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  struct buf *buf = bread(log.dev, log.start);
80102d5d:	5a                   	pop    %edx
80102d5e:	50                   	push   %eax
80102d5f:	53                   	push   %ebx
80102d60:	e8 6b d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d65:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d68:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d6b:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102d71:	85 db                	test   %ebx,%ebx
80102d73:	7e 1d                	jle    80102d92 <initlog+0x72>
80102d75:	31 d2                	xor    %edx,%edx
80102d77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d7e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102d80:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d84:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d8b:	83 c2 01             	add    $0x1,%edx
80102d8e:	39 d3                	cmp    %edx,%ebx
80102d90:	75 ee                	jne    80102d80 <initlog+0x60>
  brelse(buf);
80102d92:	83 ec 0c             	sub    $0xc,%esp
80102d95:	50                   	push   %eax
80102d96:	e8 55 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d9b:	e8 80 fe ff ff       	call   80102c20 <install_trans>
  log.lh.n = 0;
80102da0:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102da7:	00 00 00 
  write_head(); // clear the log
80102daa:	e8 11 ff ff ff       	call   80102cc0 <write_head>
}
80102daf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102db2:	83 c4 10             	add    $0x10,%esp
80102db5:	c9                   	leave  
80102db6:	c3                   	ret    
80102db7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dbe:	66 90                	xchg   %ax,%ax

80102dc0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102dc0:	55                   	push   %ebp
80102dc1:	89 e5                	mov    %esp,%ebp
80102dc3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102dc6:	68 a0 26 11 80       	push   $0x801126a0
80102dcb:	e8 60 22 00 00       	call   80105030 <acquire>
80102dd0:	83 c4 10             	add    $0x10,%esp
80102dd3:	eb 18                	jmp    80102ded <begin_op+0x2d>
80102dd5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102dd8:	83 ec 08             	sub    $0x8,%esp
80102ddb:	68 a0 26 11 80       	push   $0x801126a0
80102de0:	68 a0 26 11 80       	push   $0x801126a0
80102de5:	e8 26 16 00 00       	call   80104410 <sleep>
80102dea:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102ded:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102df2:	85 c0                	test   %eax,%eax
80102df4:	75 e2                	jne    80102dd8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102df6:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102dfb:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102e01:	83 c0 01             	add    $0x1,%eax
80102e04:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102e07:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102e0a:	83 fa 1e             	cmp    $0x1e,%edx
80102e0d:	7f c9                	jg     80102dd8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102e0f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102e12:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102e17:	68 a0 26 11 80       	push   $0x801126a0
80102e1c:	e8 af 21 00 00       	call   80104fd0 <release>
      break;
    }
  }
}
80102e21:	83 c4 10             	add    $0x10,%esp
80102e24:	c9                   	leave  
80102e25:	c3                   	ret    
80102e26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e2d:	8d 76 00             	lea    0x0(%esi),%esi

80102e30 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102e30:	55                   	push   %ebp
80102e31:	89 e5                	mov    %esp,%ebp
80102e33:	57                   	push   %edi
80102e34:	56                   	push   %esi
80102e35:	53                   	push   %ebx
80102e36:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102e39:	68 a0 26 11 80       	push   $0x801126a0
80102e3e:	e8 ed 21 00 00       	call   80105030 <acquire>
  log.outstanding -= 1;
80102e43:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102e48:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
80102e4e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e51:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102e54:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
80102e5a:	85 f6                	test   %esi,%esi
80102e5c:	0f 85 22 01 00 00    	jne    80102f84 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e62:	85 db                	test   %ebx,%ebx
80102e64:	0f 85 f6 00 00 00    	jne    80102f60 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e6a:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102e71:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e74:	83 ec 0c             	sub    $0xc,%esp
80102e77:	68 a0 26 11 80       	push   $0x801126a0
80102e7c:	e8 4f 21 00 00       	call   80104fd0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e81:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102e87:	83 c4 10             	add    $0x10,%esp
80102e8a:	85 c9                	test   %ecx,%ecx
80102e8c:	7f 42                	jg     80102ed0 <end_op+0xa0>
    acquire(&log.lock);
80102e8e:	83 ec 0c             	sub    $0xc,%esp
80102e91:	68 a0 26 11 80       	push   $0x801126a0
80102e96:	e8 95 21 00 00       	call   80105030 <acquire>
    wakeup(&log);
80102e9b:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
    log.committing = 0;
80102ea2:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102ea9:	00 00 00 
    wakeup(&log);
80102eac:	e8 1f 16 00 00       	call   801044d0 <wakeup>
    release(&log.lock);
80102eb1:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102eb8:	e8 13 21 00 00       	call   80104fd0 <release>
80102ebd:	83 c4 10             	add    $0x10,%esp
}
80102ec0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ec3:	5b                   	pop    %ebx
80102ec4:	5e                   	pop    %esi
80102ec5:	5f                   	pop    %edi
80102ec6:	5d                   	pop    %ebp
80102ec7:	c3                   	ret    
80102ec8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ecf:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102ed0:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102ed5:	83 ec 08             	sub    $0x8,%esp
80102ed8:	01 d8                	add    %ebx,%eax
80102eda:	83 c0 01             	add    $0x1,%eax
80102edd:	50                   	push   %eax
80102ede:	ff 35 e4 26 11 80    	push   0x801126e4
80102ee4:	e8 e7 d1 ff ff       	call   801000d0 <bread>
80102ee9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102eeb:	58                   	pop    %eax
80102eec:	5a                   	pop    %edx
80102eed:	ff 34 9d ec 26 11 80 	push   -0x7feed914(,%ebx,4)
80102ef4:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102efa:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102efd:	e8 ce d1 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102f02:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f05:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102f07:	8d 40 5c             	lea    0x5c(%eax),%eax
80102f0a:	68 00 02 00 00       	push   $0x200
80102f0f:	50                   	push   %eax
80102f10:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f13:	50                   	push   %eax
80102f14:	e8 77 22 00 00       	call   80105190 <memmove>
    bwrite(to);  // write the log
80102f19:	89 34 24             	mov    %esi,(%esp)
80102f1c:	e8 8f d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102f21:	89 3c 24             	mov    %edi,(%esp)
80102f24:	e8 c7 d2 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102f29:	89 34 24             	mov    %esi,(%esp)
80102f2c:	e8 bf d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f31:	83 c4 10             	add    $0x10,%esp
80102f34:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102f3a:	7c 94                	jl     80102ed0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102f3c:	e8 7f fd ff ff       	call   80102cc0 <write_head>
    install_trans(); // Now install writes to home locations
80102f41:	e8 da fc ff ff       	call   80102c20 <install_trans>
    log.lh.n = 0;
80102f46:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102f4d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f50:	e8 6b fd ff ff       	call   80102cc0 <write_head>
80102f55:	e9 34 ff ff ff       	jmp    80102e8e <end_op+0x5e>
80102f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f60:	83 ec 0c             	sub    $0xc,%esp
80102f63:	68 a0 26 11 80       	push   $0x801126a0
80102f68:	e8 63 15 00 00       	call   801044d0 <wakeup>
  release(&log.lock);
80102f6d:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102f74:	e8 57 20 00 00       	call   80104fd0 <release>
80102f79:	83 c4 10             	add    $0x10,%esp
}
80102f7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f7f:	5b                   	pop    %ebx
80102f80:	5e                   	pop    %esi
80102f81:	5f                   	pop    %edi
80102f82:	5d                   	pop    %ebp
80102f83:	c3                   	ret    
    panic("log.committing");
80102f84:	83 ec 0c             	sub    $0xc,%esp
80102f87:	68 e4 80 10 80       	push   $0x801080e4
80102f8c:	e8 ef d3 ff ff       	call   80100380 <panic>
80102f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f9f:	90                   	nop

80102fa0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102fa0:	55                   	push   %ebp
80102fa1:	89 e5                	mov    %esp,%ebp
80102fa3:	53                   	push   %ebx
80102fa4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102fa7:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
{
80102fad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102fb0:	83 fa 1d             	cmp    $0x1d,%edx
80102fb3:	0f 8f 85 00 00 00    	jg     8010303e <log_write+0x9e>
80102fb9:	a1 d8 26 11 80       	mov    0x801126d8,%eax
80102fbe:	83 e8 01             	sub    $0x1,%eax
80102fc1:	39 c2                	cmp    %eax,%edx
80102fc3:	7d 79                	jge    8010303e <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102fc5:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102fca:	85 c0                	test   %eax,%eax
80102fcc:	7e 7d                	jle    8010304b <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102fce:	83 ec 0c             	sub    $0xc,%esp
80102fd1:	68 a0 26 11 80       	push   $0x801126a0
80102fd6:	e8 55 20 00 00       	call   80105030 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102fdb:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102fe1:	83 c4 10             	add    $0x10,%esp
80102fe4:	85 d2                	test   %edx,%edx
80102fe6:	7e 4a                	jle    80103032 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fe8:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102feb:	31 c0                	xor    %eax,%eax
80102fed:	eb 08                	jmp    80102ff7 <log_write+0x57>
80102fef:	90                   	nop
80102ff0:	83 c0 01             	add    $0x1,%eax
80102ff3:	39 c2                	cmp    %eax,%edx
80102ff5:	74 29                	je     80103020 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102ff7:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
80102ffe:	75 f0                	jne    80102ff0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103000:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103007:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010300a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010300d:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80103014:	c9                   	leave  
  release(&log.lock);
80103015:	e9 b6 1f 00 00       	jmp    80104fd0 <release>
8010301a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103020:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
    log.lh.n++;
80103027:	83 c2 01             	add    $0x1,%edx
8010302a:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
80103030:	eb d5                	jmp    80103007 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80103032:	8b 43 08             	mov    0x8(%ebx),%eax
80103035:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
8010303a:	75 cb                	jne    80103007 <log_write+0x67>
8010303c:	eb e9                	jmp    80103027 <log_write+0x87>
    panic("too big a transaction");
8010303e:	83 ec 0c             	sub    $0xc,%esp
80103041:	68 f3 80 10 80       	push   $0x801080f3
80103046:	e8 35 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010304b:	83 ec 0c             	sub    $0xc,%esp
8010304e:	68 09 81 10 80       	push   $0x80108109
80103053:	e8 28 d3 ff ff       	call   80100380 <panic>
80103058:	66 90                	xchg   %ax,%ax
8010305a:	66 90                	xchg   %ax,%ax
8010305c:	66 90                	xchg   %ax,%ax
8010305e:	66 90                	xchg   %ax,%ax

80103060 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103060:	55                   	push   %ebp
80103061:	89 e5                	mov    %esp,%ebp
80103063:	53                   	push   %ebx
80103064:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103067:	e8 d4 09 00 00       	call   80103a40 <cpuid>
8010306c:	89 c3                	mov    %eax,%ebx
8010306e:	e8 cd 09 00 00       	call   80103a40 <cpuid>
80103073:	83 ec 04             	sub    $0x4,%esp
80103076:	53                   	push   %ebx
80103077:	50                   	push   %eax
80103078:	68 24 81 10 80       	push   $0x80108124
8010307d:	e8 1e d6 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103082:	e8 09 33 00 00       	call   80106390 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103087:	e8 54 09 00 00       	call   801039e0 <mycpu>
8010308c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010308e:	b8 01 00 00 00       	mov    $0x1,%eax
80103093:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010309a:	e8 31 0d 00 00       	call   80103dd0 <scheduler>
8010309f:	90                   	nop

801030a0 <mpenter>:
{
801030a0:	55                   	push   %ebp
801030a1:	89 e5                	mov    %esp,%ebp
801030a3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801030a6:	e8 d5 43 00 00       	call   80107480 <switchkvm>
  seginit();
801030ab:	e8 40 43 00 00       	call   801073f0 <seginit>
  lapicinit();
801030b0:	e8 9b f7 ff ff       	call   80102850 <lapicinit>
  mpmain();
801030b5:	e8 a6 ff ff ff       	call   80103060 <mpmain>
801030ba:	66 90                	xchg   %ax,%ax
801030bc:	66 90                	xchg   %ax,%ax
801030be:	66 90                	xchg   %ax,%ax

801030c0 <main>:
{
801030c0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801030c4:	83 e4 f0             	and    $0xfffffff0,%esp
801030c7:	ff 71 fc             	push   -0x4(%ecx)
801030ca:	55                   	push   %ebp
801030cb:	89 e5                	mov    %esp,%ebp
801030cd:	53                   	push   %ebx
801030ce:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801030cf:	83 ec 08             	sub    $0x8,%esp
801030d2:	68 00 00 40 80       	push   $0x80400000
801030d7:	68 f0 69 11 80       	push   $0x801169f0
801030dc:	e8 8f f5 ff ff       	call   80102670 <kinit1>
  kvmalloc();      // kernel page table
801030e1:	e8 8a 48 00 00       	call   80107970 <kvmalloc>
  mpinit();        // detect other processors
801030e6:	e8 85 01 00 00       	call   80103270 <mpinit>
  lapicinit();     // interrupt controller
801030eb:	e8 60 f7 ff ff       	call   80102850 <lapicinit>
  seginit();       // segment descriptors
801030f0:	e8 fb 42 00 00       	call   801073f0 <seginit>
  picinit();       // disable pic
801030f5:	e8 76 03 00 00       	call   80103470 <picinit>
  ioapicinit();    // another interrupt controller
801030fa:	e8 31 f3 ff ff       	call   80102430 <ioapicinit>
  consoleinit();   // console hardware
801030ff:	e8 5c d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
80103104:	e8 77 35 00 00       	call   80106680 <uartinit>
  pinit();         // process table
80103109:	e8 b2 08 00 00       	call   801039c0 <pinit>
  tvinit();        // trap vectors
8010310e:	e8 fd 31 00 00       	call   80106310 <tvinit>
  binit();         // buffer cache
80103113:	e8 28 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103118:	e8 53 dd ff ff       	call   80100e70 <fileinit>
  ideinit();       // disk 
8010311d:	e8 fe f0 ff ff       	call   80102220 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103122:	83 c4 0c             	add    $0xc,%esp
80103125:	68 8a 00 00 00       	push   $0x8a
8010312a:	68 8c b4 10 80       	push   $0x8010b48c
8010312f:	68 00 70 00 80       	push   $0x80007000
80103134:	e8 57 20 00 00       	call   80105190 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103139:	83 c4 10             	add    $0x10,%esp
8010313c:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80103143:	00 00 00 
80103146:	05 a0 27 11 80       	add    $0x801127a0,%eax
8010314b:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
80103150:	76 7e                	jbe    801031d0 <main+0x110>
80103152:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
80103157:	eb 20                	jmp    80103179 <main+0xb9>
80103159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103160:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80103167:	00 00 00 
8010316a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103170:	05 a0 27 11 80       	add    $0x801127a0,%eax
80103175:	39 c3                	cmp    %eax,%ebx
80103177:	73 57                	jae    801031d0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103179:	e8 62 08 00 00       	call   801039e0 <mycpu>
8010317e:	39 c3                	cmp    %eax,%ebx
80103180:	74 de                	je     80103160 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103182:	e8 59 f5 ff ff       	call   801026e0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103187:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010318a:	c7 05 f8 6f 00 80 a0 	movl   $0x801030a0,0x80006ff8
80103191:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103194:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010319b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010319e:	05 00 10 00 00       	add    $0x1000,%eax
801031a3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801031a8:	0f b6 03             	movzbl (%ebx),%eax
801031ab:	68 00 70 00 00       	push   $0x7000
801031b0:	50                   	push   %eax
801031b1:	e8 ea f7 ff ff       	call   801029a0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801031b6:	83 c4 10             	add    $0x10,%esp
801031b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031c0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801031c6:	85 c0                	test   %eax,%eax
801031c8:	74 f6                	je     801031c0 <main+0x100>
801031ca:	eb 94                	jmp    80103160 <main+0xa0>
801031cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801031d0:	83 ec 08             	sub    $0x8,%esp
801031d3:	68 00 00 00 8e       	push   $0x8e000000
801031d8:	68 00 00 40 80       	push   $0x80400000
801031dd:	e8 2e f4 ff ff       	call   80102610 <kinit2>
  userinit();      // first user process
801031e2:	e8 a9 08 00 00       	call   80103a90 <userinit>
  mpmain();        // finish this processor's setup
801031e7:	e8 74 fe ff ff       	call   80103060 <mpmain>
801031ec:	66 90                	xchg   %ax,%ax
801031ee:	66 90                	xchg   %ax,%ax

801031f0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031f0:	55                   	push   %ebp
801031f1:	89 e5                	mov    %esp,%ebp
801031f3:	57                   	push   %edi
801031f4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801031f5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801031fb:	53                   	push   %ebx
  e = addr+len;
801031fc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801031ff:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103202:	39 de                	cmp    %ebx,%esi
80103204:	72 10                	jb     80103216 <mpsearch1+0x26>
80103206:	eb 50                	jmp    80103258 <mpsearch1+0x68>
80103208:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010320f:	90                   	nop
80103210:	89 fe                	mov    %edi,%esi
80103212:	39 fb                	cmp    %edi,%ebx
80103214:	76 42                	jbe    80103258 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103216:	83 ec 04             	sub    $0x4,%esp
80103219:	8d 7e 10             	lea    0x10(%esi),%edi
8010321c:	6a 04                	push   $0x4
8010321e:	68 38 81 10 80       	push   $0x80108138
80103223:	56                   	push   %esi
80103224:	e8 17 1f 00 00       	call   80105140 <memcmp>
80103229:	83 c4 10             	add    $0x10,%esp
8010322c:	85 c0                	test   %eax,%eax
8010322e:	75 e0                	jne    80103210 <mpsearch1+0x20>
80103230:	89 f2                	mov    %esi,%edx
80103232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103238:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010323b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010323e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103240:	39 fa                	cmp    %edi,%edx
80103242:	75 f4                	jne    80103238 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103244:	84 c0                	test   %al,%al
80103246:	75 c8                	jne    80103210 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103248:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010324b:	89 f0                	mov    %esi,%eax
8010324d:	5b                   	pop    %ebx
8010324e:	5e                   	pop    %esi
8010324f:	5f                   	pop    %edi
80103250:	5d                   	pop    %ebp
80103251:	c3                   	ret    
80103252:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103258:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010325b:	31 f6                	xor    %esi,%esi
}
8010325d:	5b                   	pop    %ebx
8010325e:	89 f0                	mov    %esi,%eax
80103260:	5e                   	pop    %esi
80103261:	5f                   	pop    %edi
80103262:	5d                   	pop    %ebp
80103263:	c3                   	ret    
80103264:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010326b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010326f:	90                   	nop

80103270 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103270:	55                   	push   %ebp
80103271:	89 e5                	mov    %esp,%ebp
80103273:	57                   	push   %edi
80103274:	56                   	push   %esi
80103275:	53                   	push   %ebx
80103276:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103279:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103280:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103287:	c1 e0 08             	shl    $0x8,%eax
8010328a:	09 d0                	or     %edx,%eax
8010328c:	c1 e0 04             	shl    $0x4,%eax
8010328f:	75 1b                	jne    801032ac <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103291:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103298:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010329f:	c1 e0 08             	shl    $0x8,%eax
801032a2:	09 d0                	or     %edx,%eax
801032a4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801032a7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801032ac:	ba 00 04 00 00       	mov    $0x400,%edx
801032b1:	e8 3a ff ff ff       	call   801031f0 <mpsearch1>
801032b6:	89 c3                	mov    %eax,%ebx
801032b8:	85 c0                	test   %eax,%eax
801032ba:	0f 84 40 01 00 00    	je     80103400 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032c0:	8b 73 04             	mov    0x4(%ebx),%esi
801032c3:	85 f6                	test   %esi,%esi
801032c5:	0f 84 25 01 00 00    	je     801033f0 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
801032cb:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032ce:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801032d4:	6a 04                	push   $0x4
801032d6:	68 3d 81 10 80       	push   $0x8010813d
801032db:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801032df:	e8 5c 1e 00 00       	call   80105140 <memcmp>
801032e4:	83 c4 10             	add    $0x10,%esp
801032e7:	85 c0                	test   %eax,%eax
801032e9:	0f 85 01 01 00 00    	jne    801033f0 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
801032ef:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801032f6:	3c 01                	cmp    $0x1,%al
801032f8:	74 08                	je     80103302 <mpinit+0x92>
801032fa:	3c 04                	cmp    $0x4,%al
801032fc:	0f 85 ee 00 00 00    	jne    801033f0 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
80103302:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103309:	66 85 d2             	test   %dx,%dx
8010330c:	74 22                	je     80103330 <mpinit+0xc0>
8010330e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103311:	89 f0                	mov    %esi,%eax
  sum = 0;
80103313:	31 d2                	xor    %edx,%edx
80103315:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103318:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010331f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103322:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103324:	39 c7                	cmp    %eax,%edi
80103326:	75 f0                	jne    80103318 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103328:	84 d2                	test   %dl,%dl
8010332a:	0f 85 c0 00 00 00    	jne    801033f0 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103330:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103336:	a3 80 26 11 80       	mov    %eax,0x80112680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010333b:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103342:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
80103348:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010334d:	03 55 e4             	add    -0x1c(%ebp),%edx
80103350:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103353:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103357:	90                   	nop
80103358:	39 d0                	cmp    %edx,%eax
8010335a:	73 15                	jae    80103371 <mpinit+0x101>
    switch(*p){
8010335c:	0f b6 08             	movzbl (%eax),%ecx
8010335f:	80 f9 02             	cmp    $0x2,%cl
80103362:	74 4c                	je     801033b0 <mpinit+0x140>
80103364:	77 3a                	ja     801033a0 <mpinit+0x130>
80103366:	84 c9                	test   %cl,%cl
80103368:	74 56                	je     801033c0 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010336a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010336d:	39 d0                	cmp    %edx,%eax
8010336f:	72 eb                	jb     8010335c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103371:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103374:	85 f6                	test   %esi,%esi
80103376:	0f 84 d9 00 00 00    	je     80103455 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010337c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103380:	74 15                	je     80103397 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103382:	b8 70 00 00 00       	mov    $0x70,%eax
80103387:	ba 22 00 00 00       	mov    $0x22,%edx
8010338c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010338d:	ba 23 00 00 00       	mov    $0x23,%edx
80103392:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103393:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103396:	ee                   	out    %al,(%dx)
  }
}
80103397:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010339a:	5b                   	pop    %ebx
8010339b:	5e                   	pop    %esi
8010339c:	5f                   	pop    %edi
8010339d:	5d                   	pop    %ebp
8010339e:	c3                   	ret    
8010339f:	90                   	nop
    switch(*p){
801033a0:	83 e9 03             	sub    $0x3,%ecx
801033a3:	80 f9 01             	cmp    $0x1,%cl
801033a6:	76 c2                	jbe    8010336a <mpinit+0xfa>
801033a8:	31 f6                	xor    %esi,%esi
801033aa:	eb ac                	jmp    80103358 <mpinit+0xe8>
801033ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801033b0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801033b4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801033b7:	88 0d 80 27 11 80    	mov    %cl,0x80112780
      continue;
801033bd:	eb 99                	jmp    80103358 <mpinit+0xe8>
801033bf:	90                   	nop
      if(ncpu < NCPU) {
801033c0:	8b 0d 84 27 11 80    	mov    0x80112784,%ecx
801033c6:	83 f9 07             	cmp    $0x7,%ecx
801033c9:	7f 19                	jg     801033e4 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033cb:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801033d1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801033d5:	83 c1 01             	add    $0x1,%ecx
801033d8:	89 0d 84 27 11 80    	mov    %ecx,0x80112784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033de:	88 9f a0 27 11 80    	mov    %bl,-0x7feed860(%edi)
      p += sizeof(struct mpproc);
801033e4:	83 c0 14             	add    $0x14,%eax
      continue;
801033e7:	e9 6c ff ff ff       	jmp    80103358 <mpinit+0xe8>
801033ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801033f0:	83 ec 0c             	sub    $0xc,%esp
801033f3:	68 42 81 10 80       	push   $0x80108142
801033f8:	e8 83 cf ff ff       	call   80100380 <panic>
801033fd:	8d 76 00             	lea    0x0(%esi),%esi
{
80103400:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80103405:	eb 13                	jmp    8010341a <mpinit+0x1aa>
80103407:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010340e:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
80103410:	89 f3                	mov    %esi,%ebx
80103412:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103418:	74 d6                	je     801033f0 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010341a:	83 ec 04             	sub    $0x4,%esp
8010341d:	8d 73 10             	lea    0x10(%ebx),%esi
80103420:	6a 04                	push   $0x4
80103422:	68 38 81 10 80       	push   $0x80108138
80103427:	53                   	push   %ebx
80103428:	e8 13 1d 00 00       	call   80105140 <memcmp>
8010342d:	83 c4 10             	add    $0x10,%esp
80103430:	85 c0                	test   %eax,%eax
80103432:	75 dc                	jne    80103410 <mpinit+0x1a0>
80103434:	89 da                	mov    %ebx,%edx
80103436:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010343d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103440:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103443:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103446:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103448:	39 d6                	cmp    %edx,%esi
8010344a:	75 f4                	jne    80103440 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010344c:	84 c0                	test   %al,%al
8010344e:	75 c0                	jne    80103410 <mpinit+0x1a0>
80103450:	e9 6b fe ff ff       	jmp    801032c0 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103455:	83 ec 0c             	sub    $0xc,%esp
80103458:	68 5c 81 10 80       	push   $0x8010815c
8010345d:	e8 1e cf ff ff       	call   80100380 <panic>
80103462:	66 90                	xchg   %ax,%ax
80103464:	66 90                	xchg   %ax,%ax
80103466:	66 90                	xchg   %ax,%ax
80103468:	66 90                	xchg   %ax,%ax
8010346a:	66 90                	xchg   %ax,%ax
8010346c:	66 90                	xchg   %ax,%ax
8010346e:	66 90                	xchg   %ax,%ax

80103470 <picinit>:
80103470:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103475:	ba 21 00 00 00       	mov    $0x21,%edx
8010347a:	ee                   	out    %al,(%dx)
8010347b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103480:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103481:	c3                   	ret    
80103482:	66 90                	xchg   %ax,%ax
80103484:	66 90                	xchg   %ax,%ax
80103486:	66 90                	xchg   %ax,%ax
80103488:	66 90                	xchg   %ax,%ax
8010348a:	66 90                	xchg   %ax,%ax
8010348c:	66 90                	xchg   %ax,%ax
8010348e:	66 90                	xchg   %ax,%ax

80103490 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103490:	55                   	push   %ebp
80103491:	89 e5                	mov    %esp,%ebp
80103493:	57                   	push   %edi
80103494:	56                   	push   %esi
80103495:	53                   	push   %ebx
80103496:	83 ec 0c             	sub    $0xc,%esp
80103499:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010349c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010349f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801034a5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801034ab:	e8 e0 d9 ff ff       	call   80100e90 <filealloc>
801034b0:	89 03                	mov    %eax,(%ebx)
801034b2:	85 c0                	test   %eax,%eax
801034b4:	0f 84 a8 00 00 00    	je     80103562 <pipealloc+0xd2>
801034ba:	e8 d1 d9 ff ff       	call   80100e90 <filealloc>
801034bf:	89 06                	mov    %eax,(%esi)
801034c1:	85 c0                	test   %eax,%eax
801034c3:	0f 84 87 00 00 00    	je     80103550 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801034c9:	e8 12 f2 ff ff       	call   801026e0 <kalloc>
801034ce:	89 c7                	mov    %eax,%edi
801034d0:	85 c0                	test   %eax,%eax
801034d2:	0f 84 b0 00 00 00    	je     80103588 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
801034d8:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801034df:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801034e2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801034e5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801034ec:	00 00 00 
  p->nwrite = 0;
801034ef:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034f6:	00 00 00 
  p->nread = 0;
801034f9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103500:	00 00 00 
  initlock(&p->lock, "pipe");
80103503:	68 7b 81 10 80       	push   $0x8010817b
80103508:	50                   	push   %eax
80103509:	e8 52 19 00 00       	call   80104e60 <initlock>
  (*f0)->type = FD_PIPE;
8010350e:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103510:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103513:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103519:	8b 03                	mov    (%ebx),%eax
8010351b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010351f:	8b 03                	mov    (%ebx),%eax
80103521:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103525:	8b 03                	mov    (%ebx),%eax
80103527:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010352a:	8b 06                	mov    (%esi),%eax
8010352c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103532:	8b 06                	mov    (%esi),%eax
80103534:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103538:	8b 06                	mov    (%esi),%eax
8010353a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010353e:	8b 06                	mov    (%esi),%eax
80103540:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103543:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103546:	31 c0                	xor    %eax,%eax
}
80103548:	5b                   	pop    %ebx
80103549:	5e                   	pop    %esi
8010354a:	5f                   	pop    %edi
8010354b:	5d                   	pop    %ebp
8010354c:	c3                   	ret    
8010354d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103550:	8b 03                	mov    (%ebx),%eax
80103552:	85 c0                	test   %eax,%eax
80103554:	74 1e                	je     80103574 <pipealloc+0xe4>
    fileclose(*f0);
80103556:	83 ec 0c             	sub    $0xc,%esp
80103559:	50                   	push   %eax
8010355a:	e8 f1 d9 ff ff       	call   80100f50 <fileclose>
8010355f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103562:	8b 06                	mov    (%esi),%eax
80103564:	85 c0                	test   %eax,%eax
80103566:	74 0c                	je     80103574 <pipealloc+0xe4>
    fileclose(*f1);
80103568:	83 ec 0c             	sub    $0xc,%esp
8010356b:	50                   	push   %eax
8010356c:	e8 df d9 ff ff       	call   80100f50 <fileclose>
80103571:	83 c4 10             	add    $0x10,%esp
}
80103574:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103577:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010357c:	5b                   	pop    %ebx
8010357d:	5e                   	pop    %esi
8010357e:	5f                   	pop    %edi
8010357f:	5d                   	pop    %ebp
80103580:	c3                   	ret    
80103581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103588:	8b 03                	mov    (%ebx),%eax
8010358a:	85 c0                	test   %eax,%eax
8010358c:	75 c8                	jne    80103556 <pipealloc+0xc6>
8010358e:	eb d2                	jmp    80103562 <pipealloc+0xd2>

80103590 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103590:	55                   	push   %ebp
80103591:	89 e5                	mov    %esp,%ebp
80103593:	56                   	push   %esi
80103594:	53                   	push   %ebx
80103595:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103598:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010359b:	83 ec 0c             	sub    $0xc,%esp
8010359e:	53                   	push   %ebx
8010359f:	e8 8c 1a 00 00       	call   80105030 <acquire>
  if(writable){
801035a4:	83 c4 10             	add    $0x10,%esp
801035a7:	85 f6                	test   %esi,%esi
801035a9:	74 65                	je     80103610 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
801035ab:	83 ec 0c             	sub    $0xc,%esp
801035ae:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801035b4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801035bb:	00 00 00 
    wakeup(&p->nread);
801035be:	50                   	push   %eax
801035bf:	e8 0c 0f 00 00       	call   801044d0 <wakeup>
801035c4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801035c7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801035cd:	85 d2                	test   %edx,%edx
801035cf:	75 0a                	jne    801035db <pipeclose+0x4b>
801035d1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801035d7:	85 c0                	test   %eax,%eax
801035d9:	74 15                	je     801035f0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801035db:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801035de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035e1:	5b                   	pop    %ebx
801035e2:	5e                   	pop    %esi
801035e3:	5d                   	pop    %ebp
    release(&p->lock);
801035e4:	e9 e7 19 00 00       	jmp    80104fd0 <release>
801035e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801035f0:	83 ec 0c             	sub    $0xc,%esp
801035f3:	53                   	push   %ebx
801035f4:	e8 d7 19 00 00       	call   80104fd0 <release>
    kfree((char*)p);
801035f9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801035fc:	83 c4 10             	add    $0x10,%esp
}
801035ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103602:	5b                   	pop    %ebx
80103603:	5e                   	pop    %esi
80103604:	5d                   	pop    %ebp
    kfree((char*)p);
80103605:	e9 16 ef ff ff       	jmp    80102520 <kfree>
8010360a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103610:	83 ec 0c             	sub    $0xc,%esp
80103613:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103619:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103620:	00 00 00 
    wakeup(&p->nwrite);
80103623:	50                   	push   %eax
80103624:	e8 a7 0e 00 00       	call   801044d0 <wakeup>
80103629:	83 c4 10             	add    $0x10,%esp
8010362c:	eb 99                	jmp    801035c7 <pipeclose+0x37>
8010362e:	66 90                	xchg   %ax,%ax

80103630 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103630:	55                   	push   %ebp
80103631:	89 e5                	mov    %esp,%ebp
80103633:	57                   	push   %edi
80103634:	56                   	push   %esi
80103635:	53                   	push   %ebx
80103636:	83 ec 28             	sub    $0x28,%esp
80103639:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010363c:	53                   	push   %ebx
8010363d:	e8 ee 19 00 00       	call   80105030 <acquire>
  for(i = 0; i < n; i++){
80103642:	8b 45 10             	mov    0x10(%ebp),%eax
80103645:	83 c4 10             	add    $0x10,%esp
80103648:	85 c0                	test   %eax,%eax
8010364a:	0f 8e c0 00 00 00    	jle    80103710 <pipewrite+0xe0>
80103650:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103653:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103659:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010365f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103662:	03 45 10             	add    0x10(%ebp),%eax
80103665:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103668:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010366e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103674:	89 ca                	mov    %ecx,%edx
80103676:	05 00 02 00 00       	add    $0x200,%eax
8010367b:	39 c1                	cmp    %eax,%ecx
8010367d:	74 3f                	je     801036be <pipewrite+0x8e>
8010367f:	eb 67                	jmp    801036e8 <pipewrite+0xb8>
80103681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103688:	e8 d3 03 00 00       	call   80103a60 <myproc>
8010368d:	8b 48 24             	mov    0x24(%eax),%ecx
80103690:	85 c9                	test   %ecx,%ecx
80103692:	75 34                	jne    801036c8 <pipewrite+0x98>
      wakeup(&p->nread);
80103694:	83 ec 0c             	sub    $0xc,%esp
80103697:	57                   	push   %edi
80103698:	e8 33 0e 00 00       	call   801044d0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010369d:	58                   	pop    %eax
8010369e:	5a                   	pop    %edx
8010369f:	53                   	push   %ebx
801036a0:	56                   	push   %esi
801036a1:	e8 6a 0d 00 00       	call   80104410 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036a6:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801036ac:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801036b2:	83 c4 10             	add    $0x10,%esp
801036b5:	05 00 02 00 00       	add    $0x200,%eax
801036ba:	39 c2                	cmp    %eax,%edx
801036bc:	75 2a                	jne    801036e8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
801036be:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801036c4:	85 c0                	test   %eax,%eax
801036c6:	75 c0                	jne    80103688 <pipewrite+0x58>
        release(&p->lock);
801036c8:	83 ec 0c             	sub    $0xc,%esp
801036cb:	53                   	push   %ebx
801036cc:	e8 ff 18 00 00       	call   80104fd0 <release>
        return -1;
801036d1:	83 c4 10             	add    $0x10,%esp
801036d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801036d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036dc:	5b                   	pop    %ebx
801036dd:	5e                   	pop    %esi
801036de:	5f                   	pop    %edi
801036df:	5d                   	pop    %ebp
801036e0:	c3                   	ret    
801036e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036e8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801036eb:	8d 4a 01             	lea    0x1(%edx),%ecx
801036ee:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801036f4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801036fa:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
801036fd:	83 c6 01             	add    $0x1,%esi
80103700:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103703:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103707:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010370a:	0f 85 58 ff ff ff    	jne    80103668 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103710:	83 ec 0c             	sub    $0xc,%esp
80103713:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103719:	50                   	push   %eax
8010371a:	e8 b1 0d 00 00       	call   801044d0 <wakeup>
  release(&p->lock);
8010371f:	89 1c 24             	mov    %ebx,(%esp)
80103722:	e8 a9 18 00 00       	call   80104fd0 <release>
  return n;
80103727:	8b 45 10             	mov    0x10(%ebp),%eax
8010372a:	83 c4 10             	add    $0x10,%esp
8010372d:	eb aa                	jmp    801036d9 <pipewrite+0xa9>
8010372f:	90                   	nop

80103730 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103730:	55                   	push   %ebp
80103731:	89 e5                	mov    %esp,%ebp
80103733:	57                   	push   %edi
80103734:	56                   	push   %esi
80103735:	53                   	push   %ebx
80103736:	83 ec 18             	sub    $0x18,%esp
80103739:	8b 75 08             	mov    0x8(%ebp),%esi
8010373c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010373f:	56                   	push   %esi
80103740:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103746:	e8 e5 18 00 00       	call   80105030 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010374b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103751:	83 c4 10             	add    $0x10,%esp
80103754:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010375a:	74 2f                	je     8010378b <piperead+0x5b>
8010375c:	eb 37                	jmp    80103795 <piperead+0x65>
8010375e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103760:	e8 fb 02 00 00       	call   80103a60 <myproc>
80103765:	8b 48 24             	mov    0x24(%eax),%ecx
80103768:	85 c9                	test   %ecx,%ecx
8010376a:	0f 85 80 00 00 00    	jne    801037f0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103770:	83 ec 08             	sub    $0x8,%esp
80103773:	56                   	push   %esi
80103774:	53                   	push   %ebx
80103775:	e8 96 0c 00 00       	call   80104410 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010377a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103780:	83 c4 10             	add    $0x10,%esp
80103783:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103789:	75 0a                	jne    80103795 <piperead+0x65>
8010378b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103791:	85 c0                	test   %eax,%eax
80103793:	75 cb                	jne    80103760 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103795:	8b 55 10             	mov    0x10(%ebp),%edx
80103798:	31 db                	xor    %ebx,%ebx
8010379a:	85 d2                	test   %edx,%edx
8010379c:	7f 20                	jg     801037be <piperead+0x8e>
8010379e:	eb 2c                	jmp    801037cc <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801037a0:	8d 48 01             	lea    0x1(%eax),%ecx
801037a3:	25 ff 01 00 00       	and    $0x1ff,%eax
801037a8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801037ae:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801037b3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037b6:	83 c3 01             	add    $0x1,%ebx
801037b9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801037bc:	74 0e                	je     801037cc <piperead+0x9c>
    if(p->nread == p->nwrite)
801037be:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801037c4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801037ca:	75 d4                	jne    801037a0 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801037cc:	83 ec 0c             	sub    $0xc,%esp
801037cf:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801037d5:	50                   	push   %eax
801037d6:	e8 f5 0c 00 00       	call   801044d0 <wakeup>
  release(&p->lock);
801037db:	89 34 24             	mov    %esi,(%esp)
801037de:	e8 ed 17 00 00       	call   80104fd0 <release>
  return i;
801037e3:	83 c4 10             	add    $0x10,%esp
}
801037e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037e9:	89 d8                	mov    %ebx,%eax
801037eb:	5b                   	pop    %ebx
801037ec:	5e                   	pop    %esi
801037ed:	5f                   	pop    %edi
801037ee:	5d                   	pop    %ebp
801037ef:	c3                   	ret    
      release(&p->lock);
801037f0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801037f3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801037f8:	56                   	push   %esi
801037f9:	e8 d2 17 00 00       	call   80104fd0 <release>
      return -1;
801037fe:	83 c4 10             	add    $0x10,%esp
}
80103801:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103804:	89 d8                	mov    %ebx,%eax
80103806:	5b                   	pop    %ebx
80103807:	5e                   	pop    %esi
80103808:	5f                   	pop    %edi
80103809:	5d                   	pop    %ebp
8010380a:	c3                   	ret    
8010380b:	66 90                	xchg   %ax,%ax
8010380d:	66 90                	xchg   %ax,%ax
8010380f:	90                   	nop

80103810 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103810:	55                   	push   %ebp
80103811:	89 e5                	mov    %esp,%ebp
80103813:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103814:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
80103819:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010381c:	68 20 2d 11 80       	push   $0x80112d20
80103821:	e8 0a 18 00 00       	call   80105030 <acquire>
80103826:	83 c4 10             	add    $0x10,%esp
80103829:	eb 13                	jmp    8010383e <allocproc+0x2e>
8010382b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010382f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103830:	81 c3 90 00 00 00    	add    $0x90,%ebx
80103836:	81 fb 54 51 11 80    	cmp    $0x80115154,%ebx
8010383c:	74 7a                	je     801038b8 <allocproc+0xa8>
    if(p->state == UNUSED)
8010383e:	8b 43 0c             	mov    0xc(%ebx),%eax
80103841:	85 c0                	test   %eax,%eax
80103843:	75 eb                	jne    80103830 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103845:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
8010384a:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010384d:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103854:	89 43 10             	mov    %eax,0x10(%ebx)
80103857:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
8010385a:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
8010385f:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103865:	e8 66 17 00 00       	call   80104fd0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010386a:	e8 71 ee ff ff       	call   801026e0 <kalloc>
8010386f:	83 c4 10             	add    $0x10,%esp
80103872:	89 43 08             	mov    %eax,0x8(%ebx)
80103875:	85 c0                	test   %eax,%eax
80103877:	74 58                	je     801038d1 <allocproc+0xc1>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103879:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010387f:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103882:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103887:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
8010388a:	c7 40 14 f7 62 10 80 	movl   $0x801062f7,0x14(%eax)
  p->context = (struct context*)sp;
80103891:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103894:	6a 14                	push   $0x14
80103896:	6a 00                	push   $0x0
80103898:	50                   	push   %eax
80103899:	e8 52 18 00 00       	call   801050f0 <memset>
  p->context->eip = (uint)forkret;
8010389e:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801038a1:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801038a4:	c7 40 10 f0 38 10 80 	movl   $0x801038f0,0x10(%eax)
}
801038ab:	89 d8                	mov    %ebx,%eax
801038ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038b0:	c9                   	leave  
801038b1:	c3                   	ret    
801038b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801038b8:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801038bb:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801038bd:	68 20 2d 11 80       	push   $0x80112d20
801038c2:	e8 09 17 00 00       	call   80104fd0 <release>
}
801038c7:	89 d8                	mov    %ebx,%eax
  return 0;
801038c9:	83 c4 10             	add    $0x10,%esp
}
801038cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038cf:	c9                   	leave  
801038d0:	c3                   	ret    
    p->state = UNUSED;
801038d1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801038d8:	31 db                	xor    %ebx,%ebx
}
801038da:	89 d8                	mov    %ebx,%eax
801038dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038df:	c9                   	leave  
801038e0:	c3                   	ret    
801038e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038ef:	90                   	nop

801038f0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038f6:	68 20 2d 11 80       	push   $0x80112d20
801038fb:	e8 d0 16 00 00       	call   80104fd0 <release>

  if (first) {
80103900:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103905:	83 c4 10             	add    $0x10,%esp
80103908:	85 c0                	test   %eax,%eax
8010390a:	75 04                	jne    80103910 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010390c:	c9                   	leave  
8010390d:	c3                   	ret    
8010390e:	66 90                	xchg   %ax,%ax
    first = 0;
80103910:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103917:	00 00 00 
    iinit(ROOTDEV);
8010391a:	83 ec 0c             	sub    $0xc,%esp
8010391d:	6a 01                	push   $0x1
8010391f:	e8 9c dc ff ff       	call   801015c0 <iinit>
    initlog(ROOTDEV);
80103924:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010392b:	e8 f0 f3 ff ff       	call   80102d20 <initlog>
}
80103930:	83 c4 10             	add    $0x10,%esp
80103933:	c9                   	leave  
80103934:	c3                   	ret    
80103935:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010393c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103940 <inc_num>:
inc_num(struct proc* p){
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
  if(p->queue==CLASS1){
80103943:	8b 45 08             	mov    0x8(%ebp),%eax
80103946:	8b 40 7c             	mov    0x7c(%eax),%eax
80103949:	85 c0                	test   %eax,%eax
8010394b:	75 13                	jne    80103960 <inc_num+0x20>
    ptable.class1_num++;
8010394d:	83 05 54 51 11 80 01 	addl   $0x1,0x80115154
}
80103954:	5d                   	pop    %ebp
80103955:	c3                   	ret    
80103956:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010395d:	8d 76 00             	lea    0x0(%esi),%esi
    if(p->queue==CLASS2_RR){
80103960:	83 f8 01             	cmp    $0x1,%eax
80103963:	74 0b                	je     80103970 <inc_num+0x30>
      ptable.fcfs_num++;
80103965:	83 05 5c 51 11 80 01 	addl   $0x1,0x8011515c
}
8010396c:	5d                   	pop    %ebp
8010396d:	c3                   	ret    
8010396e:	66 90                	xchg   %ax,%ax
      ptable.rr_num++;
80103970:	83 05 58 51 11 80 01 	addl   $0x1,0x80115158
}
80103977:	5d                   	pop    %ebp
80103978:	c3                   	ret    
80103979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103980 <dec_num>:
dec_num(struct proc* p){
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
  if(p->queue==CLASS1){
80103983:	8b 45 08             	mov    0x8(%ebp),%eax
80103986:	8b 40 7c             	mov    0x7c(%eax),%eax
80103989:	85 c0                	test   %eax,%eax
8010398b:	75 13                	jne    801039a0 <dec_num+0x20>
    ptable.class1_num--;
8010398d:	83 2d 54 51 11 80 01 	subl   $0x1,0x80115154
}
80103994:	5d                   	pop    %ebp
80103995:	c3                   	ret    
80103996:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010399d:	8d 76 00             	lea    0x0(%esi),%esi
    if(p->queue==CLASS2_RR){
801039a0:	83 f8 01             	cmp    $0x1,%eax
801039a3:	74 0b                	je     801039b0 <dec_num+0x30>
      ptable.fcfs_num--;
801039a5:	83 2d 5c 51 11 80 01 	subl   $0x1,0x8011515c
}
801039ac:	5d                   	pop    %ebp
801039ad:	c3                   	ret    
801039ae:	66 90                	xchg   %ax,%ax
      ptable.rr_num--;
801039b0:	83 2d 58 51 11 80 01 	subl   $0x1,0x80115158
}
801039b7:	5d                   	pop    %ebp
801039b8:	c3                   	ret    
801039b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801039c0 <pinit>:
{
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801039c6:	68 80 81 10 80       	push   $0x80108180
801039cb:	68 20 2d 11 80       	push   $0x80112d20
801039d0:	e8 8b 14 00 00       	call   80104e60 <initlock>
}
801039d5:	83 c4 10             	add    $0x10,%esp
801039d8:	c9                   	leave  
801039d9:	c3                   	ret    
801039da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801039e0 <mycpu>:
{
801039e0:	55                   	push   %ebp
801039e1:	89 e5                	mov    %esp,%ebp
801039e3:	56                   	push   %esi
801039e4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801039e5:	9c                   	pushf  
801039e6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801039e7:	f6 c4 02             	test   $0x2,%ah
801039ea:	75 46                	jne    80103a32 <mycpu+0x52>
  apicid = lapicid();
801039ec:	e8 5f ef ff ff       	call   80102950 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801039f1:	8b 35 84 27 11 80    	mov    0x80112784,%esi
801039f7:	85 f6                	test   %esi,%esi
801039f9:	7e 2a                	jle    80103a25 <mycpu+0x45>
801039fb:	31 d2                	xor    %edx,%edx
801039fd:	eb 08                	jmp    80103a07 <mycpu+0x27>
801039ff:	90                   	nop
80103a00:	83 c2 01             	add    $0x1,%edx
80103a03:	39 f2                	cmp    %esi,%edx
80103a05:	74 1e                	je     80103a25 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103a07:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103a0d:	0f b6 99 a0 27 11 80 	movzbl -0x7feed860(%ecx),%ebx
80103a14:	39 c3                	cmp    %eax,%ebx
80103a16:	75 e8                	jne    80103a00 <mycpu+0x20>
}
80103a18:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103a1b:	8d 81 a0 27 11 80    	lea    -0x7feed860(%ecx),%eax
}
80103a21:	5b                   	pop    %ebx
80103a22:	5e                   	pop    %esi
80103a23:	5d                   	pop    %ebp
80103a24:	c3                   	ret    
  panic("unknown apicid\n");
80103a25:	83 ec 0c             	sub    $0xc,%esp
80103a28:	68 87 81 10 80       	push   $0x80108187
80103a2d:	e8 4e c9 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103a32:	83 ec 0c             	sub    $0xc,%esp
80103a35:	68 d8 82 10 80       	push   $0x801082d8
80103a3a:	e8 41 c9 ff ff       	call   80100380 <panic>
80103a3f:	90                   	nop

80103a40 <cpuid>:
cpuid() {
80103a40:	55                   	push   %ebp
80103a41:	89 e5                	mov    %esp,%ebp
80103a43:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103a46:	e8 95 ff ff ff       	call   801039e0 <mycpu>
}
80103a4b:	c9                   	leave  
  return mycpu()-cpus;
80103a4c:	2d a0 27 11 80       	sub    $0x801127a0,%eax
80103a51:	c1 f8 04             	sar    $0x4,%eax
80103a54:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103a5a:	c3                   	ret    
80103a5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a5f:	90                   	nop

80103a60 <myproc>:
myproc(void) {
80103a60:	55                   	push   %ebp
80103a61:	89 e5                	mov    %esp,%ebp
80103a63:	53                   	push   %ebx
80103a64:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103a67:	e8 74 14 00 00       	call   80104ee0 <pushcli>
  c = mycpu();
80103a6c:	e8 6f ff ff ff       	call   801039e0 <mycpu>
  p = c->proc;
80103a71:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a77:	e8 b4 14 00 00       	call   80104f30 <popcli>
}
80103a7c:	89 d8                	mov    %ebx,%eax
80103a7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a81:	c9                   	leave  
80103a82:	c3                   	ret    
80103a83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a90 <userinit>:
{
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	53                   	push   %ebx
80103a94:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103a97:	e8 74 fd ff ff       	call   80103810 <allocproc>
80103a9c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103a9e:	a3 60 51 11 80       	mov    %eax,0x80115160
  if((p->pgdir = setupkvm()) == 0)
80103aa3:	e8 48 3e 00 00       	call   801078f0 <setupkvm>
80103aa8:	89 43 04             	mov    %eax,0x4(%ebx)
80103aab:	85 c0                	test   %eax,%eax
80103aad:	0f 84 ea 00 00 00    	je     80103b9d <userinit+0x10d>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103ab3:	83 ec 04             	sub    $0x4,%esp
80103ab6:	68 2c 00 00 00       	push   $0x2c
80103abb:	68 60 b4 10 80       	push   $0x8010b460
80103ac0:	50                   	push   %eax
80103ac1:	e8 da 3a 00 00       	call   801075a0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103ac6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103ac9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103acf:	6a 4c                	push   $0x4c
80103ad1:	6a 00                	push   $0x0
80103ad3:	ff 73 18             	push   0x18(%ebx)
80103ad6:	e8 15 16 00 00       	call   801050f0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103adb:	8b 43 18             	mov    0x18(%ebx),%eax
80103ade:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103ae3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ae6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103aeb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103aef:	8b 43 18             	mov    0x18(%ebx),%eax
80103af2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103af6:	8b 43 18             	mov    0x18(%ebx),%eax
80103af9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103afd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103b01:	8b 43 18             	mov    0x18(%ebx),%eax
80103b04:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b08:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103b0c:	8b 43 18             	mov    0x18(%ebx),%eax
80103b0f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103b16:	8b 43 18             	mov    0x18(%ebx),%eax
80103b19:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103b20:	8b 43 18             	mov    0x18(%ebx),%eax
80103b23:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b2a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103b2d:	6a 10                	push   $0x10
80103b2f:	68 b0 81 10 80       	push   $0x801081b0
80103b34:	50                   	push   %eax
80103b35:	e8 76 17 00 00       	call   801052b0 <safestrcpy>
  p->cwd = namei("/");
80103b3a:	c7 04 24 b9 81 10 80 	movl   $0x801081b9,(%esp)
80103b41:	e8 ba e5 ff ff       	call   80102100 <namei>
80103b46:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103b49:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b50:	e8 db 14 00 00       	call   80105030 <acquire>
  p->arrival_time = ticks;
80103b55:	a1 80 51 11 80       	mov    0x80115180,%eax
  p->state = RUNNABLE;
80103b5a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  p->deadline = 0;
80103b61:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103b68:	00 00 00 
  p->arrival_time = ticks;
80103b6b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
  p->queue = CLASS2_RR;
80103b71:	c7 43 7c 01 00 00 00 	movl   $0x1,0x7c(%ebx)
  p->age = 0;
80103b78:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103b7f:	00 00 00 
  release(&ptable.lock);
80103b82:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
      ptable.rr_num++;
80103b89:	83 05 58 51 11 80 01 	addl   $0x1,0x80115158
  release(&ptable.lock);
80103b90:	e8 3b 14 00 00       	call   80104fd0 <release>
}
80103b95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b98:	83 c4 10             	add    $0x10,%esp
80103b9b:	c9                   	leave  
80103b9c:	c3                   	ret    
    panic("userinit: out of memory?");
80103b9d:	83 ec 0c             	sub    $0xc,%esp
80103ba0:	68 97 81 10 80       	push   $0x80108197
80103ba5:	e8 d6 c7 ff ff       	call   80100380 <panic>
80103baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103bb0 <growproc>:
{
80103bb0:	55                   	push   %ebp
80103bb1:	89 e5                	mov    %esp,%ebp
80103bb3:	56                   	push   %esi
80103bb4:	53                   	push   %ebx
80103bb5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103bb8:	e8 23 13 00 00       	call   80104ee0 <pushcli>
  c = mycpu();
80103bbd:	e8 1e fe ff ff       	call   801039e0 <mycpu>
  p = c->proc;
80103bc2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bc8:	e8 63 13 00 00       	call   80104f30 <popcli>
  sz = curproc->sz;
80103bcd:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103bcf:	85 f6                	test   %esi,%esi
80103bd1:	7f 1d                	jg     80103bf0 <growproc+0x40>
  } else if(n < 0){
80103bd3:	75 3b                	jne    80103c10 <growproc+0x60>
  switchuvm(curproc);
80103bd5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103bd8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103bda:	53                   	push   %ebx
80103bdb:	e8 b0 38 00 00       	call   80107490 <switchuvm>
  return 0;
80103be0:	83 c4 10             	add    $0x10,%esp
80103be3:	31 c0                	xor    %eax,%eax
}
80103be5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103be8:	5b                   	pop    %ebx
80103be9:	5e                   	pop    %esi
80103bea:	5d                   	pop    %ebp
80103beb:	c3                   	ret    
80103bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103bf0:	83 ec 04             	sub    $0x4,%esp
80103bf3:	01 c6                	add    %eax,%esi
80103bf5:	56                   	push   %esi
80103bf6:	50                   	push   %eax
80103bf7:	ff 73 04             	push   0x4(%ebx)
80103bfa:	e8 11 3b 00 00       	call   80107710 <allocuvm>
80103bff:	83 c4 10             	add    $0x10,%esp
80103c02:	85 c0                	test   %eax,%eax
80103c04:	75 cf                	jne    80103bd5 <growproc+0x25>
      return -1;
80103c06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c0b:	eb d8                	jmp    80103be5 <growproc+0x35>
80103c0d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c10:	83 ec 04             	sub    $0x4,%esp
80103c13:	01 c6                	add    %eax,%esi
80103c15:	56                   	push   %esi
80103c16:	50                   	push   %eax
80103c17:	ff 73 04             	push   0x4(%ebx)
80103c1a:	e8 21 3c 00 00       	call   80107840 <deallocuvm>
80103c1f:	83 c4 10             	add    $0x10,%esp
80103c22:	85 c0                	test   %eax,%eax
80103c24:	75 af                	jne    80103bd5 <growproc+0x25>
80103c26:	eb de                	jmp    80103c06 <growproc+0x56>
80103c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c2f:	90                   	nop

80103c30 <fork>:
{
80103c30:	55                   	push   %ebp
80103c31:	89 e5                	mov    %esp,%ebp
80103c33:	57                   	push   %edi
80103c34:	56                   	push   %esi
80103c35:	53                   	push   %ebx
80103c36:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103c39:	e8 a2 12 00 00       	call   80104ee0 <pushcli>
  c = mycpu();
80103c3e:	e8 9d fd ff ff       	call   801039e0 <mycpu>
  p = c->proc;
80103c43:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80103c49:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  popcli();
80103c4c:	e8 df 12 00 00       	call   80104f30 <popcli>
  if((np = allocproc()) == 0){
80103c51:	e8 ba fb ff ff       	call   80103810 <allocproc>
80103c56:	85 c0                	test   %eax,%eax
80103c58:	0f 84 3f 01 00 00    	je     80103d9d <fork+0x16d>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103c5e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103c61:	83 ec 08             	sub    $0x8,%esp
80103c64:	89 c3                	mov    %eax,%ebx
80103c66:	ff 32                	push   (%edx)
80103c68:	ff 72 04             	push   0x4(%edx)
80103c6b:	e8 70 3d 00 00       	call   801079e0 <copyuvm>
80103c70:	83 c4 10             	add    $0x10,%esp
80103c73:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103c76:	85 c0                	test   %eax,%eax
80103c78:	89 43 04             	mov    %eax,0x4(%ebx)
80103c7b:	0f 84 23 01 00 00    	je     80103da4 <fork+0x174>
  np->sz = curproc->sz;
80103c81:	8b 02                	mov    (%edx),%eax
  *np->tf = *curproc->tf;
80103c83:	8b 7b 18             	mov    0x18(%ebx),%edi
  np->parent = curproc;
80103c86:	89 53 14             	mov    %edx,0x14(%ebx)
  *np->tf = *curproc->tf;
80103c89:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
80103c8e:	89 03                	mov    %eax,(%ebx)
  *np->tf = *curproc->tf;
80103c90:	8b 72 18             	mov    0x18(%edx),%esi
80103c93:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103c95:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103c97:	8b 43 18             	mov    0x18(%ebx),%eax
80103c9a:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103ca8:	8b 44 b2 28          	mov    0x28(%edx,%esi,4),%eax
80103cac:	85 c0                	test   %eax,%eax
80103cae:	74 16                	je     80103cc6 <fork+0x96>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103cb0:	83 ec 0c             	sub    $0xc,%esp
80103cb3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103cb6:	50                   	push   %eax
80103cb7:	e8 44 d2 ff ff       	call   80100f00 <filedup>
80103cbc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103cbf:	83 c4 10             	add    $0x10,%esp
80103cc2:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103cc6:	83 c6 01             	add    $0x1,%esi
80103cc9:	83 fe 10             	cmp    $0x10,%esi
80103ccc:	75 da                	jne    80103ca8 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80103cce:	83 ec 0c             	sub    $0xc,%esp
80103cd1:	ff 72 68             	push   0x68(%edx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103cd4:	8d 73 6c             	lea    0x6c(%ebx),%esi
  np->cwd = idup(curproc->cwd);
80103cd7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103cda:	e8 d1 da ff ff       	call   801017b0 <idup>
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103cdf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103ce2:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103ce5:	89 43 68             	mov    %eax,0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ce8:	83 c2 6c             	add    $0x6c,%edx
80103ceb:	6a 10                	push   $0x10
80103ced:	52                   	push   %edx
80103cee:	56                   	push   %esi
80103cef:	e8 bc 15 00 00       	call   801052b0 <safestrcpy>
  pid = np->pid;
80103cf4:	8b 7b 10             	mov    0x10(%ebx),%edi
  acquire(&ptable.lock);
80103cf7:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103cfe:	e8 2d 13 00 00       	call   80105030 <acquire>
  np->arrival_time = ticks;
80103d03:	a1 80 51 11 80       	mov    0x80115180,%eax
  if (strncmp(np->name,"sh",3)||strncmp(np->parent->name,"sh",3)){
80103d08:	83 c4 0c             	add    $0xc,%esp
  np->state = RUNNABLE;
80103d0b:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  np->deadline = 0;
80103d12:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103d19:	00 00 00 
  np->arrival_time = ticks;
80103d1c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
  np->age=0;
80103d22:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103d29:	00 00 00 
  np->queue = CLASS2_FCFS;
80103d2c:	c7 43 7c 02 00 00 00 	movl   $0x2,0x7c(%ebx)
  if (strncmp(np->name,"sh",3)||strncmp(np->parent->name,"sh",3)){
80103d33:	6a 03                	push   $0x3
80103d35:	68 cd 7c 10 80       	push   $0x80107ccd
80103d3a:	56                   	push   %esi
80103d3b:	e8 c0 14 00 00       	call   80105200 <strncmp>
80103d40:	83 c4 10             	add    $0x10,%esp
80103d43:	85 c0                	test   %eax,%eax
80103d45:	74 29                	je     80103d70 <fork+0x140>
80103d47:	c7 43 7c 01 00 00 00 	movl   $0x1,0x7c(%ebx)
      ptable.rr_num++;
80103d4e:	83 05 58 51 11 80 01 	addl   $0x1,0x80115158
  release(&ptable.lock);
80103d55:	83 ec 0c             	sub    $0xc,%esp
80103d58:	68 20 2d 11 80       	push   $0x80112d20
80103d5d:	e8 6e 12 00 00       	call   80104fd0 <release>
  return pid;
80103d62:	83 c4 10             	add    $0x10,%esp
}
80103d65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d68:	89 f8                	mov    %edi,%eax
80103d6a:	5b                   	pop    %ebx
80103d6b:	5e                   	pop    %esi
80103d6c:	5f                   	pop    %edi
80103d6d:	5d                   	pop    %ebp
80103d6e:	c3                   	ret    
80103d6f:	90                   	nop
  if (strncmp(np->name,"sh",3)||strncmp(np->parent->name,"sh",3)){
80103d70:	83 ec 04             	sub    $0x4,%esp
80103d73:	6a 03                	push   $0x3
80103d75:	68 cd 7c 10 80       	push   $0x80107ccd
80103d7a:	8b 43 14             	mov    0x14(%ebx),%eax
80103d7d:	83 c0 6c             	add    $0x6c,%eax
80103d80:	50                   	push   %eax
80103d81:	e8 7a 14 00 00       	call   80105200 <strncmp>
80103d86:	83 c4 10             	add    $0x10,%esp
80103d89:	85 c0                	test   %eax,%eax
80103d8b:	75 ba                	jne    80103d47 <fork+0x117>
80103d8d:	c7 43 7c 02 00 00 00 	movl   $0x2,0x7c(%ebx)
      ptable.fcfs_num++;
80103d94:	83 05 5c 51 11 80 01 	addl   $0x1,0x8011515c
80103d9b:	eb b8                	jmp    80103d55 <fork+0x125>
    return -1;
80103d9d:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80103da2:	eb c1                	jmp    80103d65 <fork+0x135>
    kfree(np->kstack);
80103da4:	83 ec 0c             	sub    $0xc,%esp
80103da7:	ff 73 08             	push   0x8(%ebx)
    return -1;
80103daa:	bf ff ff ff ff       	mov    $0xffffffff,%edi
    kfree(np->kstack);
80103daf:	e8 6c e7 ff ff       	call   80102520 <kfree>
    np->kstack = 0;
80103db4:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103dbb:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103dbe:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103dc5:	eb 9e                	jmp    80103d65 <fork+0x135>
80103dc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dce:	66 90                	xchg   %ax,%ax

80103dd0 <scheduler>:
{
80103dd0:	55                   	push   %ebp
80103dd1:	89 e5                	mov    %esp,%ebp
80103dd3:	57                   	push   %edi
80103dd4:	56                   	push   %esi
80103dd5:	53                   	push   %ebx
80103dd6:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103dd9:	e8 02 fc ff ff       	call   801039e0 <mycpu>
  c->proc = 0;
80103dde:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103de5:	00 00 00 
  struct cpu *c = mycpu();
80103de8:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103dea:	8d 40 04             	lea    0x4(%eax),%eax
80103ded:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  asm volatile("sti");
80103df0:	fb                   	sti    
    acquire(&ptable.lock);
80103df1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103df4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103df9:	68 20 2d 11 80       	push   $0x80112d20
80103dfe:	e8 2d 12 00 00       	call   80105030 <acquire>
80103e03:	83 c4 10             	add    $0x10,%esp
80103e06:	eb 16                	jmp    80103e1e <scheduler+0x4e>
80103e08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e0f:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e10:	81 c3 90 00 00 00    	add    $0x90,%ebx
80103e16:	81 fb 54 51 11 80    	cmp    $0x80115154,%ebx
80103e1c:	74 52                	je     80103e70 <scheduler+0xa0>
        if(p->state==RUNNABLE && p->queue==CLASS2_FCFS){
80103e1e:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103e22:	75 ec                	jne    80103e10 <scheduler+0x40>
80103e24:	83 7b 7c 02          	cmpl   $0x2,0x7c(%ebx)
80103e28:	75 e6                	jne    80103e10 <scheduler+0x40>
          p->age++;    
80103e2a:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
80103e30:	83 c0 01             	add    $0x1,%eax
80103e33:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
          if(p->age>=800){
80103e39:	3d 1f 03 00 00       	cmp    $0x31f,%eax
80103e3e:	76 d0                	jbe    80103e10 <scheduler+0x40>
            cprintf("PID %d: got increased priority to RR due to growing old!\n",p->pid);
80103e40:	83 ec 08             	sub    $0x8,%esp
            p->queue = CLASS2_RR ;
80103e43:	c7 43 7c 01 00 00 00 	movl   $0x1,0x7c(%ebx)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e4a:	81 c3 90 00 00 00    	add    $0x90,%ebx
            p->age = 0;
80103e50:	c7 43 f8 00 00 00 00 	movl   $0x0,-0x8(%ebx)
            cprintf("PID %d: got increased priority to RR due to growing old!\n",p->pid);
80103e57:	ff 73 80             	push   -0x80(%ebx)
80103e5a:	68 00 83 10 80       	push   $0x80108300
80103e5f:	e8 3c c8 ff ff       	call   801006a0 <cprintf>
80103e64:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e67:	81 fb 54 51 11 80    	cmp    $0x80115154,%ebx
80103e6d:	75 af                	jne    80103e1e <scheduler+0x4e>
80103e6f:	90                   	nop
    if(ptable.class1_num>0){
80103e70:	8b 0d 54 51 11 80    	mov    0x80115154,%ecx
80103e76:	85 c9                	test   %ecx,%ecx
80103e78:	7f 3b                	jg     80103eb5 <scheduler+0xe5>
      if(!runable_p && ptable.rr_num>0){
80103e7a:	8b 1d 58 51 11 80    	mov    0x80115158,%ebx
80103e80:	85 db                	test   %ebx,%ebx
80103e82:	0f 8f ef 00 00 00    	jg     80103f77 <scheduler+0x1a7>
      if(!runable_p && ptable.fcfs_num>0){
80103e88:	8b 0d 5c 51 11 80    	mov    0x8011515c,%ecx
80103e8e:	85 c9                	test   %ecx,%ecx
80103e90:	0f 8f 19 01 00 00    	jg     80103faf <scheduler+0x1df>
80103e96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e9d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ptable.lock);
80103ea0:	83 ec 0c             	sub    $0xc,%esp
80103ea3:	68 20 2d 11 80       	push   $0x80112d20
80103ea8:	e8 23 11 00 00       	call   80104fd0 <release>
  for(;;){
80103ead:	83 c4 10             	add    $0x10,%esp
80103eb0:	e9 3b ff ff ff       	jmp    80103df0 <scheduler+0x20>
          int argMin = ticks - p->deadline ;
80103eb5:	8b 3d 80 51 11 80    	mov    0x80115180,%edi
      int min_dead = 1000000;
80103ebb:	b9 40 42 0f 00       	mov    $0xf4240,%ecx
      struct proc *runable_p = 0;
80103ec0:	31 db                	xor    %ebx,%ebx
      for(p=ptable.proc; p <&ptable.proc[NPROC]; p++){
80103ec2:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103ec7:	eb 13                	jmp    80103edc <scheduler+0x10c>
80103ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ed0:	05 90 00 00 00       	add    $0x90,%eax
80103ed5:	3d 54 51 11 80       	cmp    $0x80115154,%eax
80103eda:	74 2d                	je     80103f09 <scheduler+0x139>
        if(p->state==RUNNABLE && p->queue==CLASS1){
80103edc:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103ee0:	75 ee                	jne    80103ed0 <scheduler+0x100>
80103ee2:	8b 50 7c             	mov    0x7c(%eax),%edx
80103ee5:	85 d2                	test   %edx,%edx
80103ee7:	75 e7                	jne    80103ed0 <scheduler+0x100>
          int argMin = ticks - p->deadline ;
80103ee9:	89 fa                	mov    %edi,%edx
80103eeb:	2b 90 84 00 00 00    	sub    0x84(%eax),%edx
          if(!runable_p || argMin<min_dead){
80103ef1:	85 db                	test   %ebx,%ebx
80103ef3:	74 04                	je     80103ef9 <scheduler+0x129>
80103ef5:	39 ca                	cmp    %ecx,%edx
80103ef7:	7d d7                	jge    80103ed0 <scheduler+0x100>
80103ef9:	89 c3                	mov    %eax,%ebx
      for(p=ptable.proc; p <&ptable.proc[NPROC]; p++){
80103efb:	05 90 00 00 00       	add    $0x90,%eax
          int argMin = ticks - p->deadline ;
80103f00:	89 d1                	mov    %edx,%ecx
      for(p=ptable.proc; p <&ptable.proc[NPROC]; p++){
80103f02:	3d 54 51 11 80       	cmp    $0x80115154,%eax
80103f07:	75 d3                	jne    80103edc <scheduler+0x10c>
      if(!runable_p && ptable.rr_num>0){
80103f09:	85 db                	test   %ebx,%ebx
80103f0b:	0f 84 69 ff ff ff    	je     80103e7a <scheduler+0xaa>
        c->proc = runable_p;
80103f11:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
  if(p->queue==CLASS1){
80103f17:	8b 43 7c             	mov    0x7c(%ebx),%eax
80103f1a:	85 c0                	test   %eax,%eax
80103f1c:	75 4b                	jne    80103f69 <scheduler+0x199>
    ptable.class1_num--;
80103f1e:	83 2d 54 51 11 80 01 	subl   $0x1,0x80115154
        if(runable_p->queue==CLASS2_FCFS){
80103f25:	83 7b 7c 02          	cmpl   $0x2,0x7c(%ebx)
80103f29:	75 0a                	jne    80103f35 <scheduler+0x165>
          runable_p->age = 0;
80103f2b:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103f32:	00 00 00 
        switchuvm(runable_p);
80103f35:	83 ec 0c             	sub    $0xc,%esp
80103f38:	53                   	push   %ebx
80103f39:	e8 52 35 00 00       	call   80107490 <switchuvm>
        runable_p->state = RUNNING;
80103f3e:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
        swtch(&(c->scheduler),runable_p->context);
80103f45:	58                   	pop    %eax
80103f46:	5a                   	pop    %edx
80103f47:	ff 73 1c             	push   0x1c(%ebx)
80103f4a:	ff 75 e4             	push   -0x1c(%ebp)
80103f4d:	e8 b9 13 00 00       	call   8010530b <swtch>
      switchkvm();
80103f52:	e8 29 35 00 00       	call   80107480 <switchkvm>
      c->proc = 0;
80103f57:	83 c4 10             	add    $0x10,%esp
80103f5a:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103f61:	00 00 00 
80103f64:	e9 37 ff ff ff       	jmp    80103ea0 <scheduler+0xd0>
    if(p->queue==CLASS2_RR){
80103f69:	83 f8 01             	cmp    $0x1,%eax
80103f6c:	74 35                	je     80103fa3 <scheduler+0x1d3>
      ptable.fcfs_num--;
80103f6e:	83 2d 5c 51 11 80 01 	subl   $0x1,0x8011515c
80103f75:	eb ae                	jmp    80103f25 <scheduler+0x155>
        for(p=ptable.proc; p <&ptable.proc[NPROC]; p++){
80103f77:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103f7c:	eb 14                	jmp    80103f92 <scheduler+0x1c2>
80103f7e:	66 90                	xchg   %ax,%ax
80103f80:	81 c3 90 00 00 00    	add    $0x90,%ebx
80103f86:	81 fb 54 51 11 80    	cmp    $0x80115154,%ebx
80103f8c:	0f 84 f6 fe ff ff    	je     80103e88 <scheduler+0xb8>
          if(p->state==RUNNABLE && p->queue==CLASS2_RR){
80103f92:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103f96:	75 e8                	jne    80103f80 <scheduler+0x1b0>
80103f98:	83 7b 7c 01          	cmpl   $0x1,0x7c(%ebx)
80103f9c:	75 e2                	jne    80103f80 <scheduler+0x1b0>
80103f9e:	e9 6e ff ff ff       	jmp    80103f11 <scheduler+0x141>
      ptable.rr_num--;
80103fa3:	83 2d 58 51 11 80 01 	subl   $0x1,0x80115158
}
80103faa:	e9 76 ff ff ff       	jmp    80103f25 <scheduler+0x155>
80103faf:	31 db                	xor    %ebx,%ebx
        for(p=ptable.proc; p <&ptable.proc[NPROC]; p++){
80103fb1:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103fb6:	eb 14                	jmp    80103fcc <scheduler+0x1fc>
80103fb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fbf:	90                   	nop
80103fc0:	05 90 00 00 00       	add    $0x90,%eax
80103fc5:	3d 54 51 11 80       	cmp    $0x80115154,%eax
80103fca:	74 2b                	je     80103ff7 <scheduler+0x227>
          if(p->state==RUNNABLE && p->queue==CLASS2_FCFS){
80103fcc:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103fd0:	75 ee                	jne    80103fc0 <scheduler+0x1f0>
80103fd2:	83 78 7c 02          	cmpl   $0x2,0x7c(%eax)
80103fd6:	75 e8                	jne    80103fc0 <scheduler+0x1f0>
            if(!runable_p || p->arrival_time < runable_p->arrival_time){
80103fd8:	85 db                	test   %ebx,%ebx
80103fda:	74 28                	je     80104004 <scheduler+0x234>
80103fdc:	8b bb 80 00 00 00    	mov    0x80(%ebx),%edi
80103fe2:	39 b8 80 00 00 00    	cmp    %edi,0x80(%eax)
80103fe8:	0f 42 d8             	cmovb  %eax,%ebx
        for(p=ptable.proc; p <&ptable.proc[NPROC]; p++){
80103feb:	05 90 00 00 00       	add    $0x90,%eax
80103ff0:	3d 54 51 11 80       	cmp    $0x80115154,%eax
80103ff5:	75 d5                	jne    80103fcc <scheduler+0x1fc>
      if(runable_p){
80103ff7:	85 db                	test   %ebx,%ebx
80103ff9:	0f 85 12 ff ff ff    	jne    80103f11 <scheduler+0x141>
80103fff:	e9 9c fe ff ff       	jmp    80103ea0 <scheduler+0xd0>
80104004:	89 c3                	mov    %eax,%ebx
80104006:	eb b8                	jmp    80103fc0 <scheduler+0x1f0>
80104008:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010400f:	90                   	nop

80104010 <sched>:
{
80104010:	55                   	push   %ebp
80104011:	89 e5                	mov    %esp,%ebp
80104013:	56                   	push   %esi
80104014:	53                   	push   %ebx
  pushcli();
80104015:	e8 c6 0e 00 00       	call   80104ee0 <pushcli>
  c = mycpu();
8010401a:	e8 c1 f9 ff ff       	call   801039e0 <mycpu>
  p = c->proc;
8010401f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104025:	e8 06 0f 00 00       	call   80104f30 <popcli>
  if(!holding(&ptable.lock))
8010402a:	83 ec 0c             	sub    $0xc,%esp
8010402d:	68 20 2d 11 80       	push   $0x80112d20
80104032:	e8 59 0f 00 00       	call   80104f90 <holding>
80104037:	83 c4 10             	add    $0x10,%esp
8010403a:	85 c0                	test   %eax,%eax
8010403c:	74 4f                	je     8010408d <sched+0x7d>
  if(mycpu()->ncli != 1)
8010403e:	e8 9d f9 ff ff       	call   801039e0 <mycpu>
80104043:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010404a:	75 68                	jne    801040b4 <sched+0xa4>
  if(p->state == RUNNING)
8010404c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104050:	74 55                	je     801040a7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104052:	9c                   	pushf  
80104053:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104054:	f6 c4 02             	test   $0x2,%ah
80104057:	75 41                	jne    8010409a <sched+0x8a>
  intena = mycpu()->intena;
80104059:	e8 82 f9 ff ff       	call   801039e0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010405e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104061:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104067:	e8 74 f9 ff ff       	call   801039e0 <mycpu>
8010406c:	83 ec 08             	sub    $0x8,%esp
8010406f:	ff 70 04             	push   0x4(%eax)
80104072:	53                   	push   %ebx
80104073:	e8 93 12 00 00       	call   8010530b <swtch>
  mycpu()->intena = intena;
80104078:	e8 63 f9 ff ff       	call   801039e0 <mycpu>
}
8010407d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104080:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104086:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104089:	5b                   	pop    %ebx
8010408a:	5e                   	pop    %esi
8010408b:	5d                   	pop    %ebp
8010408c:	c3                   	ret    
    panic("sched ptable.lock");
8010408d:	83 ec 0c             	sub    $0xc,%esp
80104090:	68 bb 81 10 80       	push   $0x801081bb
80104095:	e8 e6 c2 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
8010409a:	83 ec 0c             	sub    $0xc,%esp
8010409d:	68 e7 81 10 80       	push   $0x801081e7
801040a2:	e8 d9 c2 ff ff       	call   80100380 <panic>
    panic("sched running");
801040a7:	83 ec 0c             	sub    $0xc,%esp
801040aa:	68 d9 81 10 80       	push   $0x801081d9
801040af:	e8 cc c2 ff ff       	call   80100380 <panic>
    panic("sched locks");
801040b4:	83 ec 0c             	sub    $0xc,%esp
801040b7:	68 cd 81 10 80       	push   $0x801081cd
801040bc:	e8 bf c2 ff ff       	call   80100380 <panic>
801040c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040cf:	90                   	nop

801040d0 <exit>:
{
801040d0:	55                   	push   %ebp
801040d1:	89 e5                	mov    %esp,%ebp
801040d3:	57                   	push   %edi
801040d4:	56                   	push   %esi
801040d5:	53                   	push   %ebx
801040d6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
801040d9:	e8 82 f9 ff ff       	call   80103a60 <myproc>
  if(curproc == initproc)
801040de:	39 05 60 51 11 80    	cmp    %eax,0x80115160
801040e4:	0f 84 52 01 00 00    	je     8010423c <exit+0x16c>
801040ea:	89 c3                	mov    %eax,%ebx
801040ec:	8d 70 28             	lea    0x28(%eax),%esi
801040ef:	8d 78 68             	lea    0x68(%eax),%edi
801040f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
801040f8:	8b 06                	mov    (%esi),%eax
801040fa:	85 c0                	test   %eax,%eax
801040fc:	74 12                	je     80104110 <exit+0x40>
      fileclose(curproc->ofile[fd]);
801040fe:	83 ec 0c             	sub    $0xc,%esp
80104101:	50                   	push   %eax
80104102:	e8 49 ce ff ff       	call   80100f50 <fileclose>
      curproc->ofile[fd] = 0;
80104107:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010410d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104110:	83 c6 04             	add    $0x4,%esi
80104113:	39 f7                	cmp    %esi,%edi
80104115:	75 e1                	jne    801040f8 <exit+0x28>
  begin_op();
80104117:	e8 a4 ec ff ff       	call   80102dc0 <begin_op>
  iput(curproc->cwd);
8010411c:	83 ec 0c             	sub    $0xc,%esp
8010411f:	ff 73 68             	push   0x68(%ebx)
80104122:	e8 e9 d7 ff ff       	call   80101910 <iput>
  end_op();
80104127:	e8 04 ed ff ff       	call   80102e30 <end_op>
  curproc->cwd = 0;
8010412c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80104133:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010413a:	e8 f1 0e 00 00       	call   80105030 <acquire>
  wakeup1(curproc->parent);
8010413f:	8b 53 14             	mov    0x14(%ebx),%edx
80104142:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104145:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010414a:	eb 10                	jmp    8010415c <exit+0x8c>
8010414c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104150:	05 90 00 00 00       	add    $0x90,%eax
80104155:	3d 54 51 11 80       	cmp    $0x80115154,%eax
8010415a:	74 2c                	je     80104188 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan){
8010415c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104160:	75 ee                	jne    80104150 <exit+0x80>
80104162:	3b 50 20             	cmp    0x20(%eax),%edx
80104165:	75 e9                	jne    80104150 <exit+0x80>
  if(p->queue==CLASS1){
80104167:	8b 48 7c             	mov    0x7c(%eax),%ecx
      p->state = RUNNABLE;
8010416a:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  if(p->queue==CLASS1){
80104171:	85 c9                	test   %ecx,%ecx
80104173:	75 79                	jne    801041ee <exit+0x11e>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104175:	05 90 00 00 00       	add    $0x90,%eax
    ptable.class1_num++;
8010417a:	83 05 54 51 11 80 01 	addl   $0x1,0x80115154
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104181:	3d 54 51 11 80       	cmp    $0x80115154,%eax
80104186:	75 d4                	jne    8010415c <exit+0x8c>
      p->parent = initproc;
80104188:	8b 0d 60 51 11 80    	mov    0x80115160,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010418e:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80104193:	eb 11                	jmp    801041a6 <exit+0xd6>
80104195:	8d 76 00             	lea    0x0(%esi),%esi
80104198:	81 c2 90 00 00 00    	add    $0x90,%edx
8010419e:	81 fa 54 51 11 80    	cmp    $0x80115154,%edx
801041a4:	74 71                	je     80104217 <exit+0x147>
    if(p->parent == curproc){
801041a6:	39 5a 14             	cmp    %ebx,0x14(%edx)
801041a9:	75 ed                	jne    80104198 <exit+0xc8>
      if(p->state == ZOMBIE)
801041ab:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801041af:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801041b2:	75 e4                	jne    80104198 <exit+0xc8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041b4:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801041b9:	eb 11                	jmp    801041cc <exit+0xfc>
801041bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041bf:	90                   	nop
801041c0:	05 90 00 00 00       	add    $0x90,%eax
801041c5:	3d 54 51 11 80       	cmp    $0x80115154,%eax
801041ca:	74 cc                	je     80104198 <exit+0xc8>
    if(p->state == SLEEPING && p->chan == chan){
801041cc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801041d0:	75 ee                	jne    801041c0 <exit+0xf0>
801041d2:	3b 48 20             	cmp    0x20(%eax),%ecx
801041d5:	75 e9                	jne    801041c0 <exit+0xf0>
  if(p->queue==CLASS1){
801041d7:	8b 70 7c             	mov    0x7c(%eax),%esi
      p->state = RUNNABLE;
801041da:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  if(p->queue==CLASS1){
801041e1:	85 f6                	test   %esi,%esi
801041e3:	75 1b                	jne    80104200 <exit+0x130>
    ptable.class1_num++;
801041e5:	83 05 54 51 11 80 01 	addl   $0x1,0x80115154
801041ec:	eb d2                	jmp    801041c0 <exit+0xf0>
    if(p->queue==CLASS2_RR){
801041ee:	83 f9 01             	cmp    $0x1,%ecx
801041f1:	74 3d                	je     80104230 <exit+0x160>
      ptable.fcfs_num++;
801041f3:	83 05 5c 51 11 80 01 	addl   $0x1,0x8011515c
801041fa:	e9 51 ff ff ff       	jmp    80104150 <exit+0x80>
801041ff:	90                   	nop
    if(p->queue==CLASS2_RR){
80104200:	83 fe 01             	cmp    $0x1,%esi
80104203:	74 09                	je     8010420e <exit+0x13e>
      ptable.fcfs_num++;
80104205:	83 05 5c 51 11 80 01 	addl   $0x1,0x8011515c
8010420c:	eb b2                	jmp    801041c0 <exit+0xf0>
      ptable.rr_num++;
8010420e:	83 05 58 51 11 80 01 	addl   $0x1,0x80115158
}
80104215:	eb a9                	jmp    801041c0 <exit+0xf0>
  curproc->state = ZOMBIE;
80104217:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
8010421e:	e8 ed fd ff ff       	call   80104010 <sched>
  panic("zombie exit");
80104223:	83 ec 0c             	sub    $0xc,%esp
80104226:	68 08 82 10 80       	push   $0x80108208
8010422b:	e8 50 c1 ff ff       	call   80100380 <panic>
      ptable.rr_num++;
80104230:	83 05 58 51 11 80 01 	addl   $0x1,0x80115158
}
80104237:	e9 14 ff ff ff       	jmp    80104150 <exit+0x80>
    panic("init exiting");
8010423c:	83 ec 0c             	sub    $0xc,%esp
8010423f:	68 fb 81 10 80       	push   $0x801081fb
80104244:	e8 37 c1 ff ff       	call   80100380 <panic>
80104249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104250 <wait>:
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	56                   	push   %esi
80104254:	53                   	push   %ebx
  pushcli();
80104255:	e8 86 0c 00 00       	call   80104ee0 <pushcli>
  c = mycpu();
8010425a:	e8 81 f7 ff ff       	call   801039e0 <mycpu>
  p = c->proc;
8010425f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104265:	e8 c6 0c 00 00       	call   80104f30 <popcli>
  acquire(&ptable.lock);
8010426a:	83 ec 0c             	sub    $0xc,%esp
8010426d:	68 20 2d 11 80       	push   $0x80112d20
80104272:	e8 b9 0d 00 00       	call   80105030 <acquire>
80104277:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010427a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010427c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80104281:	eb 13                	jmp    80104296 <wait+0x46>
80104283:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104287:	90                   	nop
80104288:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010428e:	81 fb 54 51 11 80    	cmp    $0x80115154,%ebx
80104294:	74 1e                	je     801042b4 <wait+0x64>
      if(p->parent != curproc)
80104296:	39 73 14             	cmp    %esi,0x14(%ebx)
80104299:	75 ed                	jne    80104288 <wait+0x38>
      if(p->state == ZOMBIE){
8010429b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010429f:	74 5f                	je     80104300 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042a1:	81 c3 90 00 00 00    	add    $0x90,%ebx
      havekids = 1;
801042a7:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042ac:	81 fb 54 51 11 80    	cmp    $0x80115154,%ebx
801042b2:	75 e2                	jne    80104296 <wait+0x46>
    if(!havekids || curproc->killed){
801042b4:	85 c0                	test   %eax,%eax
801042b6:	0f 84 9a 00 00 00    	je     80104356 <wait+0x106>
801042bc:	8b 46 24             	mov    0x24(%esi),%eax
801042bf:	85 c0                	test   %eax,%eax
801042c1:	0f 85 8f 00 00 00    	jne    80104356 <wait+0x106>
  pushcli();
801042c7:	e8 14 0c 00 00       	call   80104ee0 <pushcli>
  c = mycpu();
801042cc:	e8 0f f7 ff ff       	call   801039e0 <mycpu>
  p = c->proc;
801042d1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042d7:	e8 54 0c 00 00       	call   80104f30 <popcli>
  if(p == 0)
801042dc:	85 db                	test   %ebx,%ebx
801042de:	0f 84 89 00 00 00    	je     8010436d <wait+0x11d>
  p->chan = chan;
801042e4:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
801042e7:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801042ee:	e8 1d fd ff ff       	call   80104010 <sched>
  p->chan = 0;
801042f3:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801042fa:	e9 7b ff ff ff       	jmp    8010427a <wait+0x2a>
801042ff:	90                   	nop
        kfree(p->kstack);
80104300:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104303:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104306:	ff 73 08             	push   0x8(%ebx)
80104309:	e8 12 e2 ff ff       	call   80102520 <kfree>
        p->kstack = 0;
8010430e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104315:	5a                   	pop    %edx
80104316:	ff 73 04             	push   0x4(%ebx)
80104319:	e8 52 35 00 00       	call   80107870 <freevm>
        p->pid = 0;
8010431e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104325:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010432c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104330:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104337:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010433e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104345:	e8 86 0c 00 00       	call   80104fd0 <release>
        return pid;
8010434a:	83 c4 10             	add    $0x10,%esp
}
8010434d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104350:	89 f0                	mov    %esi,%eax
80104352:	5b                   	pop    %ebx
80104353:	5e                   	pop    %esi
80104354:	5d                   	pop    %ebp
80104355:	c3                   	ret    
      release(&ptable.lock);
80104356:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104359:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010435e:	68 20 2d 11 80       	push   $0x80112d20
80104363:	e8 68 0c 00 00       	call   80104fd0 <release>
      return -1;
80104368:	83 c4 10             	add    $0x10,%esp
8010436b:	eb e0                	jmp    8010434d <wait+0xfd>
    panic("sleep");
8010436d:	83 ec 0c             	sub    $0xc,%esp
80104370:	68 14 82 10 80       	push   $0x80108214
80104375:	e8 06 c0 ff ff       	call   80100380 <panic>
8010437a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104380 <yield>:
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	53                   	push   %ebx
80104384:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104387:	68 20 2d 11 80       	push   $0x80112d20
8010438c:	e8 9f 0c 00 00       	call   80105030 <acquire>
  pushcli();
80104391:	e8 4a 0b 00 00       	call   80104ee0 <pushcli>
  c = mycpu();
80104396:	e8 45 f6 ff ff       	call   801039e0 <mycpu>
  p = c->proc;
8010439b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043a1:	e8 8a 0b 00 00       	call   80104f30 <popcli>
  myproc()->state = RUNNABLE;
801043a6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  pushcli();
801043ad:	e8 2e 0b 00 00       	call   80104ee0 <pushcli>
  c = mycpu();
801043b2:	e8 29 f6 ff ff       	call   801039e0 <mycpu>
  p = c->proc;
801043b7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043bd:	e8 6e 0b 00 00       	call   80104f30 <popcli>
  if(p->queue==CLASS1){
801043c2:	83 c4 10             	add    $0x10,%esp
801043c5:	8b 43 7c             	mov    0x7c(%ebx),%eax
801043c8:	85 c0                	test   %eax,%eax
801043ca:	75 24                	jne    801043f0 <yield+0x70>
    ptable.class1_num++;
801043cc:	83 05 54 51 11 80 01 	addl   $0x1,0x80115154
  sched();
801043d3:	e8 38 fc ff ff       	call   80104010 <sched>
  release(&ptable.lock);
801043d8:	83 ec 0c             	sub    $0xc,%esp
801043db:	68 20 2d 11 80       	push   $0x80112d20
801043e0:	e8 eb 0b 00 00       	call   80104fd0 <release>
}
801043e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043e8:	83 c4 10             	add    $0x10,%esp
801043eb:	c9                   	leave  
801043ec:	c3                   	ret    
801043ed:	8d 76 00             	lea    0x0(%esi),%esi
    if(p->queue==CLASS2_RR){
801043f0:	83 f8 01             	cmp    $0x1,%eax
801043f3:	74 0b                	je     80104400 <yield+0x80>
      ptable.fcfs_num++;
801043f5:	83 05 5c 51 11 80 01 	addl   $0x1,0x8011515c
801043fc:	eb d5                	jmp    801043d3 <yield+0x53>
801043fe:	66 90                	xchg   %ax,%ax
      ptable.rr_num++;
80104400:	83 05 58 51 11 80 01 	addl   $0x1,0x80115158
}
80104407:	eb ca                	jmp    801043d3 <yield+0x53>
80104409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104410 <sleep>:
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	57                   	push   %edi
80104414:	56                   	push   %esi
80104415:	53                   	push   %ebx
80104416:	83 ec 0c             	sub    $0xc,%esp
80104419:	8b 7d 08             	mov    0x8(%ebp),%edi
8010441c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010441f:	e8 bc 0a 00 00       	call   80104ee0 <pushcli>
  c = mycpu();
80104424:	e8 b7 f5 ff ff       	call   801039e0 <mycpu>
  p = c->proc;
80104429:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010442f:	e8 fc 0a 00 00       	call   80104f30 <popcli>
  if(p == 0)
80104434:	85 db                	test   %ebx,%ebx
80104436:	0f 84 87 00 00 00    	je     801044c3 <sleep+0xb3>
  if(lk == 0)
8010443c:	85 f6                	test   %esi,%esi
8010443e:	74 76                	je     801044b6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104440:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80104446:	74 50                	je     80104498 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104448:	83 ec 0c             	sub    $0xc,%esp
8010444b:	68 20 2d 11 80       	push   $0x80112d20
80104450:	e8 db 0b 00 00       	call   80105030 <acquire>
    release(lk);
80104455:	89 34 24             	mov    %esi,(%esp)
80104458:	e8 73 0b 00 00       	call   80104fd0 <release>
  p->chan = chan;
8010445d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104460:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104467:	e8 a4 fb ff ff       	call   80104010 <sched>
  p->chan = 0;
8010446c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104473:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010447a:	e8 51 0b 00 00       	call   80104fd0 <release>
    acquire(lk);
8010447f:	89 75 08             	mov    %esi,0x8(%ebp)
80104482:	83 c4 10             	add    $0x10,%esp
}
80104485:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104488:	5b                   	pop    %ebx
80104489:	5e                   	pop    %esi
8010448a:	5f                   	pop    %edi
8010448b:	5d                   	pop    %ebp
    acquire(lk);
8010448c:	e9 9f 0b 00 00       	jmp    80105030 <acquire>
80104491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104498:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010449b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801044a2:	e8 69 fb ff ff       	call   80104010 <sched>
  p->chan = 0;
801044a7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801044ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044b1:	5b                   	pop    %ebx
801044b2:	5e                   	pop    %esi
801044b3:	5f                   	pop    %edi
801044b4:	5d                   	pop    %ebp
801044b5:	c3                   	ret    
    panic("sleep without lk");
801044b6:	83 ec 0c             	sub    $0xc,%esp
801044b9:	68 1a 82 10 80       	push   $0x8010821a
801044be:	e8 bd be ff ff       	call   80100380 <panic>
    panic("sleep");
801044c3:	83 ec 0c             	sub    $0xc,%esp
801044c6:	68 14 82 10 80       	push   $0x80108214
801044cb:	e8 b0 be ff ff       	call   80100380 <panic>

801044d0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	53                   	push   %ebx
801044d4:	83 ec 10             	sub    $0x10,%esp
801044d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801044da:	68 20 2d 11 80       	push   $0x80112d20
801044df:	e8 4c 0b 00 00       	call   80105030 <acquire>
801044e4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044e7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801044ec:	eb 0e                	jmp    801044fc <wakeup+0x2c>
801044ee:	66 90                	xchg   %ax,%ax
801044f0:	05 90 00 00 00       	add    $0x90,%eax
801044f5:	3d 54 51 11 80       	cmp    $0x80115154,%eax
801044fa:	74 2c                	je     80104528 <wakeup+0x58>
    if(p->state == SLEEPING && p->chan == chan){
801044fc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104500:	75 ee                	jne    801044f0 <wakeup+0x20>
80104502:	3b 58 20             	cmp    0x20(%eax),%ebx
80104505:	75 e9                	jne    801044f0 <wakeup+0x20>
  if(p->queue==CLASS1){
80104507:	8b 50 7c             	mov    0x7c(%eax),%edx
      p->state = RUNNABLE;
8010450a:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  if(p->queue==CLASS1){
80104511:	85 d2                	test   %edx,%edx
80104513:	75 2b                	jne    80104540 <wakeup+0x70>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104515:	05 90 00 00 00       	add    $0x90,%eax
    ptable.class1_num++;
8010451a:	83 05 54 51 11 80 01 	addl   $0x1,0x80115154
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104521:	3d 54 51 11 80       	cmp    $0x80115154,%eax
80104526:	75 d4                	jne    801044fc <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
80104528:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
8010452f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104532:	c9                   	leave  
  release(&ptable.lock);
80104533:	e9 98 0a 00 00       	jmp    80104fd0 <release>
80104538:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010453f:	90                   	nop
    if(p->queue==CLASS2_RR){
80104540:	83 fa 01             	cmp    $0x1,%edx
80104543:	74 09                	je     8010454e <wakeup+0x7e>
      ptable.fcfs_num++;
80104545:	83 05 5c 51 11 80 01 	addl   $0x1,0x8011515c
8010454c:	eb a2                	jmp    801044f0 <wakeup+0x20>
      ptable.rr_num++;
8010454e:	83 05 58 51 11 80 01 	addl   $0x1,0x80115158
}
80104555:	eb 99                	jmp    801044f0 <wakeup+0x20>
80104557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010455e:	66 90                	xchg   %ax,%ax

80104560 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	53                   	push   %ebx
80104564:	83 ec 10             	sub    $0x10,%esp
80104567:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010456a:	68 20 2d 11 80       	push   $0x80112d20
8010456f:	e8 bc 0a 00 00       	call   80105030 <acquire>
80104574:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104577:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010457c:	eb 0e                	jmp    8010458c <kill+0x2c>
8010457e:	66 90                	xchg   %ax,%ax
80104580:	05 90 00 00 00       	add    $0x90,%eax
80104585:	3d 54 51 11 80       	cmp    $0x80115154,%eax
8010458a:	74 2c                	je     801045b8 <kill+0x58>
    if(p->pid == pid){
8010458c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010458f:	75 ef                	jne    80104580 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING){
80104591:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104595:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING){
8010459c:	74 3a                	je     801045d8 <kill+0x78>
        inc_num(p);
        p->state = RUNNABLE;
      }  
      release(&ptable.lock);
8010459e:	83 ec 0c             	sub    $0xc,%esp
801045a1:	68 20 2d 11 80       	push   $0x80112d20
801045a6:	e8 25 0a 00 00       	call   80104fd0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801045ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801045ae:	83 c4 10             	add    $0x10,%esp
801045b1:	31 c0                	xor    %eax,%eax
}
801045b3:	c9                   	leave  
801045b4:	c3                   	ret    
801045b5:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ptable.lock);
801045b8:	83 ec 0c             	sub    $0xc,%esp
801045bb:	68 20 2d 11 80       	push   $0x80112d20
801045c0:	e8 0b 0a 00 00       	call   80104fd0 <release>
}
801045c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801045c8:	83 c4 10             	add    $0x10,%esp
801045cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801045d0:	c9                   	leave  
801045d1:	c3                   	ret    
801045d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(p->queue==CLASS1){
801045d8:	8b 50 7c             	mov    0x7c(%eax),%edx
801045db:	85 d2                	test   %edx,%edx
801045dd:	75 10                	jne    801045ef <kill+0x8f>
    ptable.class1_num++;
801045df:	83 05 54 51 11 80 01 	addl   $0x1,0x80115154
        p->state = RUNNABLE;
801045e6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801045ed:	eb af                	jmp    8010459e <kill+0x3e>
    if(p->queue==CLASS2_RR){
801045ef:	83 fa 01             	cmp    $0x1,%edx
801045f2:	74 09                	je     801045fd <kill+0x9d>
      ptable.fcfs_num++;
801045f4:	83 05 5c 51 11 80 01 	addl   $0x1,0x8011515c
801045fb:	eb e9                	jmp    801045e6 <kill+0x86>
      ptable.rr_num++;
801045fd:	83 05 58 51 11 80 01 	addl   $0x1,0x80115158
}
80104604:	eb e0                	jmp    801045e6 <kill+0x86>
80104606:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010460d:	8d 76 00             	lea    0x0(%esi),%esi

80104610 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	57                   	push   %edi
80104614:	56                   	push   %esi
80104615:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104618:	53                   	push   %ebx
80104619:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
8010461e:	83 ec 3c             	sub    $0x3c,%esp
80104621:	eb 27                	jmp    8010464a <procdump+0x3a>
80104623:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104627:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104628:	83 ec 0c             	sub    $0xc,%esp
8010462b:	68 4c 82 10 80       	push   $0x8010824c
80104630:	e8 6b c0 ff ff       	call   801006a0 <cprintf>
80104635:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104638:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010463e:	81 fb c0 51 11 80    	cmp    $0x801151c0,%ebx
80104644:	0f 84 7e 00 00 00    	je     801046c8 <procdump+0xb8>
    if(p->state == UNUSED)
8010464a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010464d:	85 c0                	test   %eax,%eax
8010464f:	74 e7                	je     80104638 <procdump+0x28>
      state = "???";
80104651:	ba 2b 82 10 80       	mov    $0x8010822b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104656:	83 f8 05             	cmp    $0x5,%eax
80104659:	77 11                	ja     8010466c <procdump+0x5c>
8010465b:	8b 14 85 64 84 10 80 	mov    -0x7fef7b9c(,%eax,4),%edx
      state = "???";
80104662:	b8 2b 82 10 80       	mov    $0x8010822b,%eax
80104667:	85 d2                	test   %edx,%edx
80104669:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010466c:	53                   	push   %ebx
8010466d:	52                   	push   %edx
8010466e:	ff 73 a4             	push   -0x5c(%ebx)
80104671:	68 2f 82 10 80       	push   $0x8010822f
80104676:	e8 25 c0 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
8010467b:	83 c4 10             	add    $0x10,%esp
8010467e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104682:	75 a4                	jne    80104628 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104684:	83 ec 08             	sub    $0x8,%esp
80104687:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010468a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010468d:	50                   	push   %eax
8010468e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104691:	8b 40 0c             	mov    0xc(%eax),%eax
80104694:	83 c0 08             	add    $0x8,%eax
80104697:	50                   	push   %eax
80104698:	e8 e3 07 00 00       	call   80104e80 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010469d:	83 c4 10             	add    $0x10,%esp
801046a0:	8b 17                	mov    (%edi),%edx
801046a2:	85 d2                	test   %edx,%edx
801046a4:	74 82                	je     80104628 <procdump+0x18>
        cprintf(" %p", pc[i]);
801046a6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801046a9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801046ac:	52                   	push   %edx
801046ad:	68 81 7c 10 80       	push   $0x80107c81
801046b2:	e8 e9 bf ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801046b7:	83 c4 10             	add    $0x10,%esp
801046ba:	39 fe                	cmp    %edi,%esi
801046bc:	75 e2                	jne    801046a0 <procdump+0x90>
801046be:	e9 65 ff ff ff       	jmp    80104628 <procdump+0x18>
801046c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046c7:	90                   	nop
  }

}
801046c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046cb:	5b                   	pop    %ebx
801046cc:	5e                   	pop    %esi
801046cd:	5f                   	pop    %edi
801046ce:	5d                   	pop    %ebp
801046cf:	c3                   	ret    

801046d0 <sys_setlevel>:

int sys_setlevel(void){
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	56                   	push   %esi
801046d4:	53                   	push   %ebx
    int pid, new_level;
    struct proc *p;


    if(argint(0, &pid) < 0)
801046d5:	8d 45 f0             	lea    -0x10(%ebp),%eax
int sys_setlevel(void){
801046d8:	83 ec 18             	sub    $0x18,%esp
    if(argint(0, &pid) < 0)
801046db:	50                   	push   %eax
801046dc:	6a 00                	push   $0x0
801046de:	e8 cd 0c 00 00       	call   801053b0 <argint>
801046e3:	83 c4 10             	add    $0x10,%esp
801046e6:	85 c0                	test   %eax,%eax
801046e8:	0f 88 a2 00 00 00    	js     80104790 <sys_setlevel+0xc0>
        return -1;
    if(argint(1, &new_level) < 0)
801046ee:	83 ec 08             	sub    $0x8,%esp
801046f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
801046f4:	50                   	push   %eax
801046f5:	6a 01                	push   $0x1
801046f7:	e8 b4 0c 00 00       	call   801053b0 <argint>
801046fc:	83 c4 10             	add    $0x10,%esp
801046ff:	85 c0                	test   %eax,%eax
80104701:	0f 88 89 00 00 00    	js     80104790 <sys_setlevel+0xc0>
        return -1;

 
    if(new_level != CLASS2_RR && new_level != CLASS2_FCFS)
80104707:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010470a:	83 e8 01             	sub    $0x1,%eax
8010470d:	83 f8 01             	cmp    $0x1,%eax
80104710:	77 7e                	ja     80104790 <sys_setlevel+0xc0>
        return -1;

    acquire(&ptable.lock);
80104712:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104715:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
8010471a:	68 20 2d 11 80       	push   $0x80112d20
8010471f:	e8 0c 09 00 00       	call   80105030 <acquire>
        if(p->pid == pid){
80104724:	8b 55 f0             	mov    -0x10(%ebp),%edx
          if(p->queue == new_level){
80104727:	8b 75 f4             	mov    -0xc(%ebp),%esi
8010472a:	83 c4 10             	add    $0x10,%esp
8010472d:	eb 0f                	jmp    8010473e <sys_setlevel+0x6e>
8010472f:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104730:	81 c3 90 00 00 00    	add    $0x90,%ebx
80104736:	81 fb 54 51 11 80    	cmp    $0x80115154,%ebx
8010473c:	74 42                	je     80104780 <sys_setlevel+0xb0>
        if(p->pid == pid){
8010473e:	39 53 10             	cmp    %edx,0x10(%ebx)
80104741:	75 ed                	jne    80104730 <sys_setlevel+0x60>
          if(p->queue == new_level){
80104743:	8b 43 7c             	mov    0x7c(%ebx),%eax
80104746:	39 f0                	cmp    %esi,%eax
80104748:	74 52                	je     8010479c <sys_setlevel+0xcc>
            release(&ptable.lock);
            cprintf("the process is in this level now, can't change level!\n");
            return -1;
          }
            if(p->queue == CLASS2_FCFS || p->queue == CLASS2_RR){
8010474a:	8d 48 ff             	lea    -0x1(%eax),%ecx
8010474d:	83 f9 01             	cmp    $0x1,%ecx
80104750:	76 72                	jbe    801047c4 <sys_setlevel+0xf4>
               // p->age = 0;
                cprintf("\n",p->queue);
                release(&ptable.lock);
                cprintf("changing level done!\n");
                return 0; 
            } if(p->queue == CLASS1) {
80104752:	85 c0                	test   %eax,%eax
80104754:	75 da                	jne    80104730 <sys_setlevel+0x60>
                release(&ptable.lock);
80104756:	83 ec 0c             	sub    $0xc,%esp
80104759:	68 20 2d 11 80       	push   $0x80112d20
8010475e:	e8 6d 08 00 00       	call   80104fd0 <release>
                cprintf("Not in class2, can't change level!\n");
80104763:	c7 04 24 74 83 10 80 	movl   $0x80108374,(%esp)
8010476a:	e8 31 bf ff ff       	call   801006a0 <cprintf>
                return -1; 
8010476f:	83 c4 10             	add    $0x10,%esp
            }
        }
    }
    release(&ptable.lock);
    return -1; // pid not found
}
80104772:	8d 65 f8             	lea    -0x8(%ebp),%esp
                return -1; 
80104775:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010477a:	5b                   	pop    %ebx
8010477b:	5e                   	pop    %esi
8010477c:	5d                   	pop    %ebp
8010477d:	c3                   	ret    
8010477e:	66 90                	xchg   %ax,%ax
    release(&ptable.lock);
80104780:	83 ec 0c             	sub    $0xc,%esp
80104783:	68 20 2d 11 80       	push   $0x80112d20
80104788:	e8 43 08 00 00       	call   80104fd0 <release>
    return -1; // pid not found
8010478d:	83 c4 10             	add    $0x10,%esp
}
80104790:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1; // pid not found
80104793:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104798:	5b                   	pop    %ebx
80104799:	5e                   	pop    %esi
8010479a:	5d                   	pop    %ebp
8010479b:	c3                   	ret    
            release(&ptable.lock);
8010479c:	83 ec 0c             	sub    $0xc,%esp
8010479f:	68 20 2d 11 80       	push   $0x80112d20
801047a4:	e8 27 08 00 00       	call   80104fd0 <release>
            cprintf("the process is in this level now, can't change level!\n");
801047a9:	c7 04 24 3c 83 10 80 	movl   $0x8010833c,(%esp)
801047b0:	e8 eb be ff ff       	call   801006a0 <cprintf>
            return -1;
801047b5:	83 c4 10             	add    $0x10,%esp
}
801047b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
            return -1;
801047bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801047c0:	5b                   	pop    %ebx
801047c1:	5e                   	pop    %esi
801047c2:	5d                   	pop    %ebp
801047c3:	c3                   	ret    
                cprintf("\n",p->queue);
801047c4:	83 ec 08             	sub    $0x8,%esp
801047c7:	50                   	push   %eax
801047c8:	68 4c 82 10 80       	push   $0x8010824c
801047cd:	e8 ce be ff ff       	call   801006a0 <cprintf>
                p->queue = new_level;
801047d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
                cprintf("\n",p->queue);
801047d5:	5a                   	pop    %edx
801047d6:	59                   	pop    %ecx
801047d7:	50                   	push   %eax
801047d8:	68 4c 82 10 80       	push   $0x8010824c
                p->queue = new_level;
801047dd:	89 43 7c             	mov    %eax,0x7c(%ebx)
                cprintf("\n",p->queue);
801047e0:	e8 bb be ff ff       	call   801006a0 <cprintf>
                release(&ptable.lock);
801047e5:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801047ec:	e8 df 07 00 00       	call   80104fd0 <release>
                cprintf("changing level done!\n");
801047f1:	c7 04 24 38 82 10 80 	movl   $0x80108238,(%esp)
801047f8:	e8 a3 be ff ff       	call   801006a0 <cprintf>
                return 0; 
801047fd:	83 c4 10             	add    $0x10,%esp
}
80104800:	8d 65 f8             	lea    -0x8(%ebp),%esp
                return 0; 
80104803:	31 c0                	xor    %eax,%eax
}
80104805:	5b                   	pop    %ebx
80104806:	5e                   	pop    %esi
80104807:	5d                   	pop    %ebp
80104808:	c3                   	ret    
80104809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104810 <getStateString>:





char* getStateString(enum procstate state) {
80104810:	55                   	push   %ebp
80104811:	b8 4e 82 10 80       	mov    $0x8010824e,%eax
80104816:	89 e5                	mov    %esp,%ebp
80104818:	8b 55 08             	mov    0x8(%ebp),%edx
8010481b:	83 fa 05             	cmp    $0x5,%edx
8010481e:	77 07                	ja     80104827 <getStateString+0x17>
80104820:	8b 04 95 4c 84 10 80 	mov    -0x7fef7bb4(,%edx,4),%eax
    case RUNNABLE: return "RUNNABLE";
    case RUNNING: return "RUNNING";
    case ZOMBIE: return "ZOMBIE";
    default: return "UNKNOWN";
  }
}
80104827:	5d                   	pop    %ebp
80104828:	c3                   	ret    
80104829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104830 <getClassString>:
char* getClassString(enum priority_queue q) {
80104830:	55                   	push   %ebp
80104831:	b8 56 82 10 80       	mov    $0x80108256,%eax
80104836:	89 e5                	mov    %esp,%ebp
80104838:	8b 55 08             	mov    0x8(%ebp),%edx
8010483b:	83 fa 02             	cmp    $0x2,%edx
8010483e:	77 07                	ja     80104847 <getClassString+0x17>
80104840:	8b 04 95 40 84 10 80 	mov    -0x7fef7bc0(,%edx,4),%eax
    case CLASS1: return "real-time";
    case CLASS2_RR: return "normal";
    case CLASS2_FCFS: return "normal";
    default: return "unknown";
  }
}
80104847:	5d                   	pop    %ebp
80104848:	c3                   	ret    
80104849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104850 <getAlgorithmString>:
char* getAlgorithmString(struct proc *p) {
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
  switch (p->queue) {
80104853:	8b 45 08             	mov    0x8(%ebp),%eax
80104856:	8b 50 7c             	mov    0x7c(%eax),%edx
80104859:	b8 56 82 10 80       	mov    $0x80108256,%eax
8010485e:	83 fa 02             	cmp    $0x2,%edx
80104861:	77 07                	ja     8010486a <getAlgorithmString+0x1a>
80104863:	8b 04 95 34 84 10 80 	mov    -0x7fef7bcc(,%edx,4),%eax
    case CLASS1: return "EDF";
    case CLASS2_RR: return "RR";
    case CLASS2_FCFS: return "FCFS";
    default: return "unknown";
  }
}
8010486a:	5d                   	pop    %ebp
8010486b:	c3                   	ret    
8010486c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104870 <count_digits>:


int count_digits(int number) {
80104870:	55                   	push   %ebp
80104871:	b9 01 00 00 00       	mov    $0x1,%ecx
80104876:	89 e5                	mov    %esp,%ebp
80104878:	53                   	push   %ebx
80104879:	8b 55 08             	mov    0x8(%ebp),%edx
  if (number == 0)
8010487c:	85 d2                	test   %edx,%edx
8010487e:	74 1c                	je     8010489c <count_digits+0x2c>
      return 1;  

  int count = 0;
80104880:	b9 00 00 00 00       	mov    $0x0,%ecx
  if (number < 0) {
80104885:	78 21                	js     801048a8 <count_digits+0x38>
      number = -number; 
  }

  while (number > 0) {
      count++;
      number /= 10; 
80104887:	bb cd cc cc cc       	mov    $0xcccccccd,%ebx
8010488c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104890:	89 d0                	mov    %edx,%eax
      count++;
80104892:	83 c1 01             	add    $0x1,%ecx
      number /= 10; 
80104895:	f7 e3                	mul    %ebx
  while (number > 0) {
80104897:	c1 ea 03             	shr    $0x3,%edx
8010489a:	75 f4                	jne    80104890 <count_digits+0x20>
  }
  return count;
}
8010489c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010489f:	89 c8                	mov    %ecx,%eax
801048a1:	c9                   	leave  
801048a2:	c3                   	ret    
801048a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048a7:	90                   	nop
      number = -number; 
801048a8:	f7 da                	neg    %edx
      count++;     
801048aa:	b9 01 00 00 00       	mov    $0x1,%ecx
801048af:	eb d6                	jmp    80104887 <count_digits+0x17>
801048b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048bf:	90                   	nop

801048c0 <printspaces>:

void printspaces(int count) { 
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
801048c3:	56                   	push   %esi
801048c4:	8b 75 08             	mov    0x8(%ebp),%esi
801048c7:	53                   	push   %ebx
  for (int i = 0; i < count; i++) {
801048c8:	85 f6                	test   %esi,%esi
801048ca:	7e 1b                	jle    801048e7 <printspaces+0x27>
801048cc:	31 db                	xor    %ebx,%ebx
801048ce:	66 90                	xchg   %ax,%ax
    cprintf(" ");
801048d0:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < count; i++) {
801048d3:	83 c3 01             	add    $0x1,%ebx
    cprintf(" ");
801048d6:	68 ce 82 10 80       	push   $0x801082ce
801048db:	e8 c0 bd ff ff       	call   801006a0 <cprintf>
  for (int i = 0; i < count; i++) {
801048e0:	83 c4 10             	add    $0x10,%esp
801048e3:	39 de                	cmp    %ebx,%esi
801048e5:	75 e9                	jne    801048d0 <printspaces+0x10>
  }
}
801048e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048ea:	5b                   	pop    %ebx
801048eb:	5e                   	pop    %esi
801048ec:	5d                   	pop    %ebp
801048ed:	c3                   	ret    
801048ee:	66 90                	xchg   %ax,%ax

801048f0 <printprocinfo>:

void printprocinfo(void) {
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	57                   	push   %edi
801048f4:	56                   	push   %esi
801048f5:	53                   	push   %ebx
801048f6:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
801048fb:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
801048fe:	68 20 2d 11 80       	push   $0x80112d20
80104903:	e8 28 07 00 00       	call   80105030 <acquire>

  cprintf("name            pid  state class   algorithm age deadline cons_run arrival\n"
80104908:	c7 04 24 98 83 10 80 	movl   $0x80108398,(%esp)
8010490f:	e8 8c bd ff ff       	call   801006a0 <cprintf>
    "------------------------------------------------------------------------------\n");

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104914:	83 c4 10             	add    $0x10,%esp
80104917:	eb 19                	jmp    80104932 <printprocinfo+0x42>
80104919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104920:	81 c3 90 00 00 00    	add    $0x90,%ebx
80104926:	81 fb c0 51 11 80    	cmp    $0x801151c0,%ebx
8010492c:	0f 84 97 03 00 00    	je     80104cc9 <printprocinfo+0x3d9>
    if (p->state == UNUSED)
80104932:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104935:	85 c0                	test   %eax,%eax
80104937:	74 e7                	je     80104920 <printprocinfo+0x30>
      continue;

    static int columns[] = { 16, 5, 10, 9, 10, 8, 8, 8, 8 };

    cprintf("%s", p->name);
80104939:	83 ec 08             	sub    $0x8,%esp
    printspaces(columns[0] - strlen(p->name));
8010493c:	be 10 00 00 00       	mov    $0x10,%esi
    cprintf("%s", p->name);
80104941:	53                   	push   %ebx
80104942:	68 35 82 10 80       	push   $0x80108235
80104947:	e8 54 bd ff ff       	call   801006a0 <cprintf>
    printspaces(columns[0] - strlen(p->name));
8010494c:	89 1c 24             	mov    %ebx,(%esp)
8010494f:	e8 9c 09 00 00       	call   801052f0 <strlen>
  for (int i = 0; i < count; i++) {
80104954:	83 c4 10             	add    $0x10,%esp
    printspaces(columns[0] - strlen(p->name));
80104957:	29 c6                	sub    %eax,%esi
  for (int i = 0; i < count; i++) {
80104959:	85 f6                	test   %esi,%esi
8010495b:	7e 1a                	jle    80104977 <printprocinfo+0x87>
8010495d:	31 ff                	xor    %edi,%edi
8010495f:	90                   	nop
    cprintf(" ");
80104960:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < count; i++) {
80104963:	83 c7 01             	add    $0x1,%edi
    cprintf(" ");
80104966:	68 ce 82 10 80       	push   $0x801082ce
8010496b:	e8 30 bd ff ff       	call   801006a0 <cprintf>
  for (int i = 0; i < count; i++) {
80104970:	83 c4 10             	add    $0x10,%esp
80104973:	39 fe                	cmp    %edi,%esi
80104975:	75 e9                	jne    80104960 <printprocinfo+0x70>

    cprintf("%d", p->pid);
80104977:	83 ec 08             	sub    $0x8,%esp
8010497a:	ff 73 a4             	push   -0x5c(%ebx)
8010497d:	68 5e 82 10 80       	push   $0x8010825e
80104982:	e8 19 bd ff ff       	call   801006a0 <cprintf>
    printspaces(columns[1] - count_digits(p->pid));
80104987:	8b 53 a4             	mov    -0x5c(%ebx),%edx
  if (number == 0)
8010498a:	83 c4 10             	add    $0x10,%esp
8010498d:	85 d2                	test   %edx,%edx
8010498f:	0f 84 8b 03 00 00    	je     80104d20 <printprocinfo+0x430>
  int count = 0;
80104995:	b9 00 00 00 00       	mov    $0x0,%ecx
  if (number < 0) {
8010499a:	79 07                	jns    801049a3 <printprocinfo+0xb3>
      number = -number; 
8010499c:	f7 da                	neg    %edx
      count++;     
8010499e:	b9 01 00 00 00       	mov    $0x1,%ecx
      number /= 10; 
801049a3:	be cd cc cc cc       	mov    $0xcccccccd,%esi
801049a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049af:	90                   	nop
801049b0:	89 d0                	mov    %edx,%eax
      count++;
801049b2:	83 c1 01             	add    $0x1,%ecx
      number /= 10; 
801049b5:	f7 e6                	mul    %esi
  while (number > 0) {
801049b7:	c1 ea 03             	shr    $0x3,%edx
801049ba:	75 f4                	jne    801049b0 <printprocinfo+0xc0>
    printspaces(columns[1] - count_digits(p->pid));
801049bc:	be 05 00 00 00       	mov    $0x5,%esi
801049c1:	29 ce                	sub    %ecx,%esi
  for (int i = 0; i < count; i++) {
801049c3:	85 f6                	test   %esi,%esi
801049c5:	7e 20                	jle    801049e7 <printprocinfo+0xf7>
    printspaces(columns[1] - count_digits(p->pid));
801049c7:	31 ff                	xor    %edi,%edi
801049c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" ");
801049d0:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < count; i++) {
801049d3:	83 c7 01             	add    $0x1,%edi
    cprintf(" ");
801049d6:	68 ce 82 10 80       	push   $0x801082ce
801049db:	e8 c0 bc ff ff       	call   801006a0 <cprintf>
  for (int i = 0; i < count; i++) {
801049e0:	83 c4 10             	add    $0x10,%esp
801049e3:	39 f7                	cmp    %esi,%edi
801049e5:	7c e9                	jl     801049d0 <printprocinfo+0xe0>

    char *stateStr = getStateString(p->state);
801049e7:	8b 43 a0             	mov    -0x60(%ebx),%eax
801049ea:	be 4e 82 10 80       	mov    $0x8010824e,%esi
801049ef:	83 f8 05             	cmp    $0x5,%eax
801049f2:	77 07                	ja     801049fb <printprocinfo+0x10b>
801049f4:	8b 34 85 4c 84 10 80 	mov    -0x7fef7bb4(,%eax,4),%esi
    cprintf("%s", stateStr);
801049fb:	83 ec 08             	sub    $0x8,%esp
801049fe:	56                   	push   %esi
801049ff:	68 35 82 10 80       	push   $0x80108235
80104a04:	e8 97 bc ff ff       	call   801006a0 <cprintf>
    printspaces(columns[2] - strlen(stateStr));
80104a09:	89 34 24             	mov    %esi,(%esp)
80104a0c:	be 0a 00 00 00       	mov    $0xa,%esi
80104a11:	e8 da 08 00 00       	call   801052f0 <strlen>
  for (int i = 0; i < count; i++) {
80104a16:	83 c4 10             	add    $0x10,%esp
    printspaces(columns[2] - strlen(stateStr));
80104a19:	29 c6                	sub    %eax,%esi
  for (int i = 0; i < count; i++) {
80104a1b:	85 f6                	test   %esi,%esi
80104a1d:	7e 20                	jle    80104a3f <printprocinfo+0x14f>
80104a1f:	31 ff                	xor    %edi,%edi
80104a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" ");
80104a28:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < count; i++) {
80104a2b:	83 c7 01             	add    $0x1,%edi
    cprintf(" ");
80104a2e:	68 ce 82 10 80       	push   $0x801082ce
80104a33:	e8 68 bc ff ff       	call   801006a0 <cprintf>
  for (int i = 0; i < count; i++) {
80104a38:	83 c4 10             	add    $0x10,%esp
80104a3b:	39 fe                	cmp    %edi,%esi
80104a3d:	75 e9                	jne    80104a28 <printprocinfo+0x138>

    char *classStr = getClassString(p->queue);
80104a3f:	8b 43 10             	mov    0x10(%ebx),%eax
80104a42:	be 56 82 10 80       	mov    $0x80108256,%esi
80104a47:	83 f8 02             	cmp    $0x2,%eax
80104a4a:	77 07                	ja     80104a53 <printprocinfo+0x163>
80104a4c:	8b 34 85 40 84 10 80 	mov    -0x7fef7bc0(,%eax,4),%esi
    cprintf("%s", classStr);
80104a53:	83 ec 08             	sub    $0x8,%esp
80104a56:	56                   	push   %esi
80104a57:	68 35 82 10 80       	push   $0x80108235
80104a5c:	e8 3f bc ff ff       	call   801006a0 <cprintf>
    printspaces(columns[3] - strlen(classStr));
80104a61:	89 34 24             	mov    %esi,(%esp)
80104a64:	be 09 00 00 00       	mov    $0x9,%esi
80104a69:	e8 82 08 00 00       	call   801052f0 <strlen>
  for (int i = 0; i < count; i++) {
80104a6e:	83 c4 10             	add    $0x10,%esp
    printspaces(columns[3] - strlen(classStr));
80104a71:	29 c6                	sub    %eax,%esi
  for (int i = 0; i < count; i++) {
80104a73:	85 f6                	test   %esi,%esi
80104a75:	7e 20                	jle    80104a97 <printprocinfo+0x1a7>
80104a77:	31 ff                	xor    %edi,%edi
80104a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" ");
80104a80:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < count; i++) {
80104a83:	83 c7 01             	add    $0x1,%edi
    cprintf(" ");
80104a86:	68 ce 82 10 80       	push   $0x801082ce
80104a8b:	e8 10 bc ff ff       	call   801006a0 <cprintf>
  for (int i = 0; i < count; i++) {
80104a90:	83 c4 10             	add    $0x10,%esp
80104a93:	39 fe                	cmp    %edi,%esi
80104a95:	75 e9                	jne    80104a80 <printprocinfo+0x190>
  switch (p->queue) {
80104a97:	8b 43 10             	mov    0x10(%ebx),%eax
80104a9a:	be 56 82 10 80       	mov    $0x80108256,%esi
80104a9f:	83 f8 02             	cmp    $0x2,%eax
80104aa2:	77 07                	ja     80104aab <printprocinfo+0x1bb>
80104aa4:	8b 34 85 34 84 10 80 	mov    -0x7fef7bcc(,%eax,4),%esi

    char *algoStr = getAlgorithmString(p);
    cprintf("%s", algoStr);
80104aab:	83 ec 08             	sub    $0x8,%esp
80104aae:	56                   	push   %esi
80104aaf:	68 35 82 10 80       	push   $0x80108235
80104ab4:	e8 e7 bb ff ff       	call   801006a0 <cprintf>
    printspaces(columns[4] - strlen(algoStr));
80104ab9:	89 34 24             	mov    %esi,(%esp)
80104abc:	be 0a 00 00 00       	mov    $0xa,%esi
80104ac1:	e8 2a 08 00 00       	call   801052f0 <strlen>
  for (int i = 0; i < count; i++) {
80104ac6:	83 c4 10             	add    $0x10,%esp
    printspaces(columns[4] - strlen(algoStr));
80104ac9:	29 c6                	sub    %eax,%esi
  for (int i = 0; i < count; i++) {
80104acb:	85 f6                	test   %esi,%esi
80104acd:	7e 20                	jle    80104aef <printprocinfo+0x1ff>
80104acf:	31 ff                	xor    %edi,%edi
80104ad1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" ");
80104ad8:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < count; i++) {
80104adb:	83 c7 01             	add    $0x1,%edi
    cprintf(" ");
80104ade:	68 ce 82 10 80       	push   $0x801082ce
80104ae3:	e8 b8 bb ff ff       	call   801006a0 <cprintf>
  for (int i = 0; i < count; i++) {
80104ae8:	83 c4 10             	add    $0x10,%esp
80104aeb:	39 fe                	cmp    %edi,%esi
80104aed:	75 e9                	jne    80104ad8 <printprocinfo+0x1e8>

    cprintf("%d", p->age);
80104aef:	83 ec 08             	sub    $0x8,%esp
80104af2:	ff 73 1c             	push   0x1c(%ebx)
80104af5:	68 5e 82 10 80       	push   $0x8010825e
80104afa:	e8 a1 bb ff ff       	call   801006a0 <cprintf>
    printspaces(columns[5] - count_digits(p->age));
80104aff:	8b 53 1c             	mov    0x1c(%ebx),%edx
  if (number == 0)
80104b02:	83 c4 10             	add    $0x10,%esp
80104b05:	85 d2                	test   %edx,%edx
80104b07:	0f 84 03 02 00 00    	je     80104d10 <printprocinfo+0x420>
  int count = 0;
80104b0d:	b9 00 00 00 00       	mov    $0x0,%ecx
  if (number < 0) {
80104b12:	79 07                	jns    80104b1b <printprocinfo+0x22b>
      number = -number; 
80104b14:	f7 da                	neg    %edx
      count++;     
80104b16:	b9 01 00 00 00       	mov    $0x1,%ecx
      number /= 10; 
80104b1b:	be cd cc cc cc       	mov    $0xcccccccd,%esi
80104b20:	89 d0                	mov    %edx,%eax
      count++;
80104b22:	83 c1 01             	add    $0x1,%ecx
      number /= 10; 
80104b25:	f7 e6                	mul    %esi
  while (number > 0) {
80104b27:	c1 ea 03             	shr    $0x3,%edx
80104b2a:	75 f4                	jne    80104b20 <printprocinfo+0x230>
    printspaces(columns[5] - count_digits(p->age));
80104b2c:	be 08 00 00 00       	mov    $0x8,%esi
80104b31:	29 ce                	sub    %ecx,%esi
  for (int i = 0; i < count; i++) {
80104b33:	85 f6                	test   %esi,%esi
80104b35:	7e 20                	jle    80104b57 <printprocinfo+0x267>
    printspaces(columns[5] - count_digits(p->age));
80104b37:	31 ff                	xor    %edi,%edi
80104b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" ");
80104b40:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < count; i++) {
80104b43:	83 c7 01             	add    $0x1,%edi
    cprintf(" ");
80104b46:	68 ce 82 10 80       	push   $0x801082ce
80104b4b:	e8 50 bb ff ff       	call   801006a0 <cprintf>
  for (int i = 0; i < count; i++) {
80104b50:	83 c4 10             	add    $0x10,%esp
80104b53:	39 f7                	cmp    %esi,%edi
80104b55:	7c e9                	jl     80104b40 <printprocinfo+0x250>

    cprintf("%d", p->deadline);
80104b57:	83 ec 08             	sub    $0x8,%esp
80104b5a:	ff 73 18             	push   0x18(%ebx)
80104b5d:	68 5e 82 10 80       	push   $0x8010825e
80104b62:	e8 39 bb ff ff       	call   801006a0 <cprintf>
    printspaces(columns[6] - count_digits(p->deadline));
80104b67:	8b 53 18             	mov    0x18(%ebx),%edx
  if (number == 0)
80104b6a:	83 c4 10             	add    $0x10,%esp
80104b6d:	85 d2                	test   %edx,%edx
80104b6f:	0f 84 8b 01 00 00    	je     80104d00 <printprocinfo+0x410>
  int count = 0;
80104b75:	b9 00 00 00 00       	mov    $0x0,%ecx
  if (number < 0) {
80104b7a:	79 07                	jns    80104b83 <printprocinfo+0x293>
      number = -number; 
80104b7c:	f7 da                	neg    %edx
      count++;     
80104b7e:	b9 01 00 00 00       	mov    $0x1,%ecx
      number /= 10; 
80104b83:	be cd cc cc cc       	mov    $0xcccccccd,%esi
80104b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b8f:	90                   	nop
80104b90:	89 d0                	mov    %edx,%eax
      count++;
80104b92:	83 c1 01             	add    $0x1,%ecx
      number /= 10; 
80104b95:	f7 e6                	mul    %esi
  while (number > 0) {
80104b97:	c1 ea 03             	shr    $0x3,%edx
80104b9a:	75 f4                	jne    80104b90 <printprocinfo+0x2a0>
    printspaces(columns[6] - count_digits(p->deadline));
80104b9c:	be 08 00 00 00       	mov    $0x8,%esi
80104ba1:	29 ce                	sub    %ecx,%esi
  for (int i = 0; i < count; i++) {
80104ba3:	85 f6                	test   %esi,%esi
80104ba5:	7e 20                	jle    80104bc7 <printprocinfo+0x2d7>
    printspaces(columns[6] - count_digits(p->deadline));
80104ba7:	31 ff                	xor    %edi,%edi
80104ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" ");
80104bb0:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < count; i++) {
80104bb3:	83 c7 01             	add    $0x1,%edi
    cprintf(" ");
80104bb6:	68 ce 82 10 80       	push   $0x801082ce
80104bbb:	e8 e0 ba ff ff       	call   801006a0 <cprintf>
  for (int i = 0; i < count; i++) {
80104bc0:	83 c4 10             	add    $0x10,%esp
80104bc3:	39 f7                	cmp    %esi,%edi
80104bc5:	7c e9                	jl     80104bb0 <printprocinfo+0x2c0>

    cprintf("%d", p->cons_run);
80104bc7:	83 ec 08             	sub    $0x8,%esp
80104bca:	ff 73 20             	push   0x20(%ebx)
80104bcd:	68 5e 82 10 80       	push   $0x8010825e
80104bd2:	e8 c9 ba ff ff       	call   801006a0 <cprintf>
    printspaces(columns[7] - count_digits(p->cons_run));
80104bd7:	8b 53 20             	mov    0x20(%ebx),%edx
  if (number == 0)
80104bda:	83 c4 10             	add    $0x10,%esp
80104bdd:	85 d2                	test   %edx,%edx
80104bdf:	0f 84 0b 01 00 00    	je     80104cf0 <printprocinfo+0x400>
  int count = 0;
80104be5:	b9 00 00 00 00       	mov    $0x0,%ecx
  if (number < 0) {
80104bea:	79 07                	jns    80104bf3 <printprocinfo+0x303>
      number = -number; 
80104bec:	f7 da                	neg    %edx
      count++;     
80104bee:	b9 01 00 00 00       	mov    $0x1,%ecx
      number /= 10; 
80104bf3:	be cd cc cc cc       	mov    $0xcccccccd,%esi
80104bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bff:	90                   	nop
80104c00:	89 d0                	mov    %edx,%eax
      count++;
80104c02:	83 c1 01             	add    $0x1,%ecx
      number /= 10; 
80104c05:	f7 e6                	mul    %esi
  while (number > 0) {
80104c07:	c1 ea 03             	shr    $0x3,%edx
80104c0a:	75 f4                	jne    80104c00 <printprocinfo+0x310>
    printspaces(columns[7] - count_digits(p->cons_run));
80104c0c:	be 08 00 00 00       	mov    $0x8,%esi
80104c11:	29 ce                	sub    %ecx,%esi
  for (int i = 0; i < count; i++) {
80104c13:	85 f6                	test   %esi,%esi
80104c15:	7e 20                	jle    80104c37 <printprocinfo+0x347>
    printspaces(columns[7] - count_digits(p->cons_run));
80104c17:	31 ff                	xor    %edi,%edi
80104c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" ");
80104c20:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < count; i++) {
80104c23:	83 c7 01             	add    $0x1,%edi
    cprintf(" ");
80104c26:	68 ce 82 10 80       	push   $0x801082ce
80104c2b:	e8 70 ba ff ff       	call   801006a0 <cprintf>
  for (int i = 0; i < count; i++) {
80104c30:	83 c4 10             	add    $0x10,%esp
80104c33:	39 f7                	cmp    %esi,%edi
80104c35:	7c e9                	jl     80104c20 <printprocinfo+0x330>

    cprintf("%d", p->arrival_time);
80104c37:	83 ec 08             	sub    $0x8,%esp
80104c3a:	ff 73 14             	push   0x14(%ebx)
80104c3d:	68 5e 82 10 80       	push   $0x8010825e
80104c42:	e8 59 ba ff ff       	call   801006a0 <cprintf>
    printspaces(columns[8] - count_digits(p->arrival_time));
80104c47:	8b 53 14             	mov    0x14(%ebx),%edx
  if (number == 0)
80104c4a:	83 c4 10             	add    $0x10,%esp
80104c4d:	85 d2                	test   %edx,%edx
80104c4f:	0f 84 93 00 00 00    	je     80104ce8 <printprocinfo+0x3f8>
  int count = 0;
80104c55:	b9 00 00 00 00       	mov    $0x0,%ecx
  if (number < 0) {
80104c5a:	79 07                	jns    80104c63 <printprocinfo+0x373>
      number = -number; 
80104c5c:	f7 da                	neg    %edx
      count++;     
80104c5e:	b9 01 00 00 00       	mov    $0x1,%ecx
      number /= 10; 
80104c63:	be cd cc cc cc       	mov    $0xcccccccd,%esi
80104c68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c6f:	90                   	nop
80104c70:	89 d0                	mov    %edx,%eax
      count++;
80104c72:	83 c1 01             	add    $0x1,%ecx
      number /= 10; 
80104c75:	f7 e6                	mul    %esi
  while (number > 0) {
80104c77:	c1 ea 03             	shr    $0x3,%edx
80104c7a:	75 f4                	jne    80104c70 <printprocinfo+0x380>
    printspaces(columns[8] - count_digits(p->arrival_time));
80104c7c:	be 08 00 00 00       	mov    $0x8,%esi
80104c81:	29 ce                	sub    %ecx,%esi
  for (int i = 0; i < count; i++) {
80104c83:	85 f6                	test   %esi,%esi
80104c85:	7e 20                	jle    80104ca7 <printprocinfo+0x3b7>
    printspaces(columns[8] - count_digits(p->arrival_time));
80104c87:	31 ff                	xor    %edi,%edi
80104c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" ");
80104c90:	83 ec 0c             	sub    $0xc,%esp
  for (int i = 0; i < count; i++) {
80104c93:	83 c7 01             	add    $0x1,%edi
    cprintf(" ");
80104c96:	68 ce 82 10 80       	push   $0x801082ce
80104c9b:	e8 00 ba ff ff       	call   801006a0 <cprintf>
  for (int i = 0; i < count; i++) {
80104ca0:	83 c4 10             	add    $0x10,%esp
80104ca3:	39 f7                	cmp    %esi,%edi
80104ca5:	7c e9                	jl     80104c90 <printprocinfo+0x3a0>

    cprintf("\n");
80104ca7:	83 ec 0c             	sub    $0xc,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104caa:	81 c3 90 00 00 00    	add    $0x90,%ebx
    cprintf("\n");
80104cb0:	68 4c 82 10 80       	push   $0x8010824c
80104cb5:	e8 e6 b9 ff ff       	call   801006a0 <cprintf>
80104cba:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104cbd:	81 fb c0 51 11 80    	cmp    $0x801151c0,%ebx
80104cc3:	0f 85 69 fc ff ff    	jne    80104932 <printprocinfo+0x42>
  } 

  release(&ptable.lock);
80104cc9:	83 ec 0c             	sub    $0xc,%esp
80104ccc:	68 20 2d 11 80       	push   $0x80112d20
80104cd1:	e8 fa 02 00 00       	call   80104fd0 <release>
80104cd6:	83 c4 10             	add    $0x10,%esp
80104cd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104cdc:	5b                   	pop    %ebx
80104cdd:	5e                   	pop    %esi
80104cde:	5f                   	pop    %edi
80104cdf:	5d                   	pop    %ebp
80104ce0:	c3                   	ret    
80104ce1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    printspaces(columns[8] - count_digits(p->arrival_time));
80104ce8:	be 07 00 00 00       	mov    $0x7,%esi
80104ced:	eb 98                	jmp    80104c87 <printprocinfo+0x397>
80104cef:	90                   	nop
    printspaces(columns[7] - count_digits(p->cons_run));
80104cf0:	be 07 00 00 00       	mov    $0x7,%esi
80104cf5:	e9 1d ff ff ff       	jmp    80104c17 <printprocinfo+0x327>
80104cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    printspaces(columns[6] - count_digits(p->deadline));
80104d00:	be 07 00 00 00       	mov    $0x7,%esi
80104d05:	e9 9d fe ff ff       	jmp    80104ba7 <printprocinfo+0x2b7>
80104d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    printspaces(columns[5] - count_digits(p->age));
80104d10:	be 07 00 00 00       	mov    $0x7,%esi
80104d15:	e9 1d fe ff ff       	jmp    80104b37 <printprocinfo+0x247>
80104d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    printspaces(columns[1] - count_digits(p->pid));
80104d20:	be 04 00 00 00       	mov    $0x4,%esi
80104d25:	e9 9d fc ff ff       	jmp    801049c7 <printprocinfo+0xd7>
80104d2a:	66 90                	xchg   %ax,%ax
80104d2c:	66 90                	xchg   %ax,%ax
80104d2e:	66 90                	xchg   %ax,%ax

80104d30 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	53                   	push   %ebx
80104d34:	83 ec 0c             	sub    $0xc,%esp
80104d37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104d3a:	68 7c 84 10 80       	push   $0x8010847c
80104d3f:	8d 43 04             	lea    0x4(%ebx),%eax
80104d42:	50                   	push   %eax
80104d43:	e8 18 01 00 00       	call   80104e60 <initlock>
  lk->name = name;
80104d48:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104d4b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104d51:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104d54:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104d5b:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104d5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d61:	c9                   	leave  
80104d62:	c3                   	ret    
80104d63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d70 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	56                   	push   %esi
80104d74:	53                   	push   %ebx
80104d75:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104d78:	8d 73 04             	lea    0x4(%ebx),%esi
80104d7b:	83 ec 0c             	sub    $0xc,%esp
80104d7e:	56                   	push   %esi
80104d7f:	e8 ac 02 00 00       	call   80105030 <acquire>
  while (lk->locked) {
80104d84:	8b 13                	mov    (%ebx),%edx
80104d86:	83 c4 10             	add    $0x10,%esp
80104d89:	85 d2                	test   %edx,%edx
80104d8b:	74 16                	je     80104da3 <acquiresleep+0x33>
80104d8d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104d90:	83 ec 08             	sub    $0x8,%esp
80104d93:	56                   	push   %esi
80104d94:	53                   	push   %ebx
80104d95:	e8 76 f6 ff ff       	call   80104410 <sleep>
  while (lk->locked) {
80104d9a:	8b 03                	mov    (%ebx),%eax
80104d9c:	83 c4 10             	add    $0x10,%esp
80104d9f:	85 c0                	test   %eax,%eax
80104da1:	75 ed                	jne    80104d90 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104da3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104da9:	e8 b2 ec ff ff       	call   80103a60 <myproc>
80104dae:	8b 40 10             	mov    0x10(%eax),%eax
80104db1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104db4:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104db7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104dba:	5b                   	pop    %ebx
80104dbb:	5e                   	pop    %esi
80104dbc:	5d                   	pop    %ebp
  release(&lk->lk);
80104dbd:	e9 0e 02 00 00       	jmp    80104fd0 <release>
80104dc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104dd0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	56                   	push   %esi
80104dd4:	53                   	push   %ebx
80104dd5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104dd8:	8d 73 04             	lea    0x4(%ebx),%esi
80104ddb:	83 ec 0c             	sub    $0xc,%esp
80104dde:	56                   	push   %esi
80104ddf:	e8 4c 02 00 00       	call   80105030 <acquire>
  lk->locked = 0;
80104de4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104dea:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104df1:	89 1c 24             	mov    %ebx,(%esp)
80104df4:	e8 d7 f6 ff ff       	call   801044d0 <wakeup>
  release(&lk->lk);
80104df9:	89 75 08             	mov    %esi,0x8(%ebp)
80104dfc:	83 c4 10             	add    $0x10,%esp
}
80104dff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e02:	5b                   	pop    %ebx
80104e03:	5e                   	pop    %esi
80104e04:	5d                   	pop    %ebp
  release(&lk->lk);
80104e05:	e9 c6 01 00 00       	jmp    80104fd0 <release>
80104e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e10 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104e10:	55                   	push   %ebp
80104e11:	89 e5                	mov    %esp,%ebp
80104e13:	57                   	push   %edi
80104e14:	31 ff                	xor    %edi,%edi
80104e16:	56                   	push   %esi
80104e17:	53                   	push   %ebx
80104e18:	83 ec 18             	sub    $0x18,%esp
80104e1b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104e1e:	8d 73 04             	lea    0x4(%ebx),%esi
80104e21:	56                   	push   %esi
80104e22:	e8 09 02 00 00       	call   80105030 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104e27:	8b 03                	mov    (%ebx),%eax
80104e29:	83 c4 10             	add    $0x10,%esp
80104e2c:	85 c0                	test   %eax,%eax
80104e2e:	75 18                	jne    80104e48 <holdingsleep+0x38>
  release(&lk->lk);
80104e30:	83 ec 0c             	sub    $0xc,%esp
80104e33:	56                   	push   %esi
80104e34:	e8 97 01 00 00       	call   80104fd0 <release>
  return r;
}
80104e39:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e3c:	89 f8                	mov    %edi,%eax
80104e3e:	5b                   	pop    %ebx
80104e3f:	5e                   	pop    %esi
80104e40:	5f                   	pop    %edi
80104e41:	5d                   	pop    %ebp
80104e42:	c3                   	ret    
80104e43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e47:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104e48:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104e4b:	e8 10 ec ff ff       	call   80103a60 <myproc>
80104e50:	39 58 10             	cmp    %ebx,0x10(%eax)
80104e53:	0f 94 c0             	sete   %al
80104e56:	0f b6 c0             	movzbl %al,%eax
80104e59:	89 c7                	mov    %eax,%edi
80104e5b:	eb d3                	jmp    80104e30 <holdingsleep+0x20>
80104e5d:	66 90                	xchg   %ax,%ax
80104e5f:	90                   	nop

80104e60 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104e66:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104e69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104e6f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104e72:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104e79:	5d                   	pop    %ebp
80104e7a:	c3                   	ret    
80104e7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e7f:	90                   	nop

80104e80 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104e80:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104e81:	31 d2                	xor    %edx,%edx
{
80104e83:	89 e5                	mov    %esp,%ebp
80104e85:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104e86:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104e89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104e8c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104e8f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104e90:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104e96:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104e9c:	77 1a                	ja     80104eb8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104e9e:	8b 58 04             	mov    0x4(%eax),%ebx
80104ea1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104ea4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104ea7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104ea9:	83 fa 0a             	cmp    $0xa,%edx
80104eac:	75 e2                	jne    80104e90 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104eae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104eb1:	c9                   	leave  
80104eb2:	c3                   	ret    
80104eb3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104eb7:	90                   	nop
  for(; i < 10; i++)
80104eb8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104ebb:	8d 51 28             	lea    0x28(%ecx),%edx
80104ebe:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104ec0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104ec6:	83 c0 04             	add    $0x4,%eax
80104ec9:	39 d0                	cmp    %edx,%eax
80104ecb:	75 f3                	jne    80104ec0 <getcallerpcs+0x40>
}
80104ecd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ed0:	c9                   	leave  
80104ed1:	c3                   	ret    
80104ed2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ee0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	53                   	push   %ebx
80104ee4:	83 ec 04             	sub    $0x4,%esp
80104ee7:	9c                   	pushf  
80104ee8:	5b                   	pop    %ebx
  asm volatile("cli");
80104ee9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104eea:	e8 f1 ea ff ff       	call   801039e0 <mycpu>
80104eef:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104ef5:	85 c0                	test   %eax,%eax
80104ef7:	74 17                	je     80104f10 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104ef9:	e8 e2 ea ff ff       	call   801039e0 <mycpu>
80104efe:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104f05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f08:	c9                   	leave  
80104f09:	c3                   	ret    
80104f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104f10:	e8 cb ea ff ff       	call   801039e0 <mycpu>
80104f15:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104f1b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104f21:	eb d6                	jmp    80104ef9 <pushcli+0x19>
80104f23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f30 <popcli>:

void
popcli(void)
{
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104f36:	9c                   	pushf  
80104f37:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104f38:	f6 c4 02             	test   $0x2,%ah
80104f3b:	75 35                	jne    80104f72 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104f3d:	e8 9e ea ff ff       	call   801039e0 <mycpu>
80104f42:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104f49:	78 34                	js     80104f7f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104f4b:	e8 90 ea ff ff       	call   801039e0 <mycpu>
80104f50:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104f56:	85 d2                	test   %edx,%edx
80104f58:	74 06                	je     80104f60 <popcli+0x30>
    sti();
}
80104f5a:	c9                   	leave  
80104f5b:	c3                   	ret    
80104f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104f60:	e8 7b ea ff ff       	call   801039e0 <mycpu>
80104f65:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104f6b:	85 c0                	test   %eax,%eax
80104f6d:	74 eb                	je     80104f5a <popcli+0x2a>
  asm volatile("sti");
80104f6f:	fb                   	sti    
}
80104f70:	c9                   	leave  
80104f71:	c3                   	ret    
    panic("popcli - interruptible");
80104f72:	83 ec 0c             	sub    $0xc,%esp
80104f75:	68 87 84 10 80       	push   $0x80108487
80104f7a:	e8 01 b4 ff ff       	call   80100380 <panic>
    panic("popcli");
80104f7f:	83 ec 0c             	sub    $0xc,%esp
80104f82:	68 9e 84 10 80       	push   $0x8010849e
80104f87:	e8 f4 b3 ff ff       	call   80100380 <panic>
80104f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f90 <holding>:
{
80104f90:	55                   	push   %ebp
80104f91:	89 e5                	mov    %esp,%ebp
80104f93:	56                   	push   %esi
80104f94:	53                   	push   %ebx
80104f95:	8b 75 08             	mov    0x8(%ebp),%esi
80104f98:	31 db                	xor    %ebx,%ebx
  pushcli();
80104f9a:	e8 41 ff ff ff       	call   80104ee0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104f9f:	8b 06                	mov    (%esi),%eax
80104fa1:	85 c0                	test   %eax,%eax
80104fa3:	75 0b                	jne    80104fb0 <holding+0x20>
  popcli();
80104fa5:	e8 86 ff ff ff       	call   80104f30 <popcli>
}
80104faa:	89 d8                	mov    %ebx,%eax
80104fac:	5b                   	pop    %ebx
80104fad:	5e                   	pop    %esi
80104fae:	5d                   	pop    %ebp
80104faf:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104fb0:	8b 5e 08             	mov    0x8(%esi),%ebx
80104fb3:	e8 28 ea ff ff       	call   801039e0 <mycpu>
80104fb8:	39 c3                	cmp    %eax,%ebx
80104fba:	0f 94 c3             	sete   %bl
  popcli();
80104fbd:	e8 6e ff ff ff       	call   80104f30 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104fc2:	0f b6 db             	movzbl %bl,%ebx
}
80104fc5:	89 d8                	mov    %ebx,%eax
80104fc7:	5b                   	pop    %ebx
80104fc8:	5e                   	pop    %esi
80104fc9:	5d                   	pop    %ebp
80104fca:	c3                   	ret    
80104fcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fcf:	90                   	nop

80104fd0 <release>:
{
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	56                   	push   %esi
80104fd4:	53                   	push   %ebx
80104fd5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104fd8:	e8 03 ff ff ff       	call   80104ee0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104fdd:	8b 03                	mov    (%ebx),%eax
80104fdf:	85 c0                	test   %eax,%eax
80104fe1:	75 15                	jne    80104ff8 <release+0x28>
  popcli();
80104fe3:	e8 48 ff ff ff       	call   80104f30 <popcli>
    panic("release");
80104fe8:	83 ec 0c             	sub    $0xc,%esp
80104feb:	68 a5 84 10 80       	push   $0x801084a5
80104ff0:	e8 8b b3 ff ff       	call   80100380 <panic>
80104ff5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104ff8:	8b 73 08             	mov    0x8(%ebx),%esi
80104ffb:	e8 e0 e9 ff ff       	call   801039e0 <mycpu>
80105000:	39 c6                	cmp    %eax,%esi
80105002:	75 df                	jne    80104fe3 <release+0x13>
  popcli();
80105004:	e8 27 ff ff ff       	call   80104f30 <popcli>
  lk->pcs[0] = 0;
80105009:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80105010:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105017:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010501c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105022:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105025:	5b                   	pop    %ebx
80105026:	5e                   	pop    %esi
80105027:	5d                   	pop    %ebp
  popcli();
80105028:	e9 03 ff ff ff       	jmp    80104f30 <popcli>
8010502d:	8d 76 00             	lea    0x0(%esi),%esi

80105030 <acquire>:
{
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	53                   	push   %ebx
80105034:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105037:	e8 a4 fe ff ff       	call   80104ee0 <pushcli>
  if(holding(lk))
8010503c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010503f:	e8 9c fe ff ff       	call   80104ee0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105044:	8b 03                	mov    (%ebx),%eax
80105046:	85 c0                	test   %eax,%eax
80105048:	75 7e                	jne    801050c8 <acquire+0x98>
  popcli();
8010504a:	e8 e1 fe ff ff       	call   80104f30 <popcli>
  asm volatile("lock; xchgl %0, %1" :
8010504f:	b9 01 00 00 00       	mov    $0x1,%ecx
80105054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80105058:	8b 55 08             	mov    0x8(%ebp),%edx
8010505b:	89 c8                	mov    %ecx,%eax
8010505d:	f0 87 02             	lock xchg %eax,(%edx)
80105060:	85 c0                	test   %eax,%eax
80105062:	75 f4                	jne    80105058 <acquire+0x28>
  __sync_synchronize();
80105064:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105069:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010506c:	e8 6f e9 ff ff       	call   801039e0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80105071:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80105074:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80105076:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80105079:	31 c0                	xor    %eax,%eax
8010507b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010507f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105080:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80105086:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010508c:	77 1a                	ja     801050a8 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010508e:	8b 5a 04             	mov    0x4(%edx),%ebx
80105091:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80105095:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80105098:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010509a:	83 f8 0a             	cmp    $0xa,%eax
8010509d:	75 e1                	jne    80105080 <acquire+0x50>
}
8010509f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050a2:	c9                   	leave  
801050a3:	c3                   	ret    
801050a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
801050a8:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
801050ac:	8d 51 34             	lea    0x34(%ecx),%edx
801050af:	90                   	nop
    pcs[i] = 0;
801050b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801050b6:	83 c0 04             	add    $0x4,%eax
801050b9:	39 c2                	cmp    %eax,%edx
801050bb:	75 f3                	jne    801050b0 <acquire+0x80>
}
801050bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050c0:	c9                   	leave  
801050c1:	c3                   	ret    
801050c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801050c8:	8b 5b 08             	mov    0x8(%ebx),%ebx
801050cb:	e8 10 e9 ff ff       	call   801039e0 <mycpu>
801050d0:	39 c3                	cmp    %eax,%ebx
801050d2:	0f 85 72 ff ff ff    	jne    8010504a <acquire+0x1a>
  popcli();
801050d8:	e8 53 fe ff ff       	call   80104f30 <popcli>
    panic("acquire");
801050dd:	83 ec 0c             	sub    $0xc,%esp
801050e0:	68 ad 84 10 80       	push   $0x801084ad
801050e5:	e8 96 b2 ff ff       	call   80100380 <panic>
801050ea:	66 90                	xchg   %ax,%ax
801050ec:	66 90                	xchg   %ax,%ax
801050ee:	66 90                	xchg   %ax,%ax

801050f0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801050f0:	55                   	push   %ebp
801050f1:	89 e5                	mov    %esp,%ebp
801050f3:	57                   	push   %edi
801050f4:	8b 55 08             	mov    0x8(%ebp),%edx
801050f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801050fa:	53                   	push   %ebx
801050fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801050fe:	89 d7                	mov    %edx,%edi
80105100:	09 cf                	or     %ecx,%edi
80105102:	83 e7 03             	and    $0x3,%edi
80105105:	75 29                	jne    80105130 <memset+0x40>
    c &= 0xFF;
80105107:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010510a:	c1 e0 18             	shl    $0x18,%eax
8010510d:	89 fb                	mov    %edi,%ebx
8010510f:	c1 e9 02             	shr    $0x2,%ecx
80105112:	c1 e3 10             	shl    $0x10,%ebx
80105115:	09 d8                	or     %ebx,%eax
80105117:	09 f8                	or     %edi,%eax
80105119:	c1 e7 08             	shl    $0x8,%edi
8010511c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010511e:	89 d7                	mov    %edx,%edi
80105120:	fc                   	cld    
80105121:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80105123:	5b                   	pop    %ebx
80105124:	89 d0                	mov    %edx,%eax
80105126:	5f                   	pop    %edi
80105127:	5d                   	pop    %ebp
80105128:	c3                   	ret    
80105129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80105130:	89 d7                	mov    %edx,%edi
80105132:	fc                   	cld    
80105133:	f3 aa                	rep stos %al,%es:(%edi)
80105135:	5b                   	pop    %ebx
80105136:	89 d0                	mov    %edx,%eax
80105138:	5f                   	pop    %edi
80105139:	5d                   	pop    %ebp
8010513a:	c3                   	ret    
8010513b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010513f:	90                   	nop

80105140 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105140:	55                   	push   %ebp
80105141:	89 e5                	mov    %esp,%ebp
80105143:	56                   	push   %esi
80105144:	8b 75 10             	mov    0x10(%ebp),%esi
80105147:	8b 55 08             	mov    0x8(%ebp),%edx
8010514a:	53                   	push   %ebx
8010514b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010514e:	85 f6                	test   %esi,%esi
80105150:	74 2e                	je     80105180 <memcmp+0x40>
80105152:	01 c6                	add    %eax,%esi
80105154:	eb 14                	jmp    8010516a <memcmp+0x2a>
80105156:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010515d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80105160:	83 c0 01             	add    $0x1,%eax
80105163:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80105166:	39 f0                	cmp    %esi,%eax
80105168:	74 16                	je     80105180 <memcmp+0x40>
    if(*s1 != *s2)
8010516a:	0f b6 0a             	movzbl (%edx),%ecx
8010516d:	0f b6 18             	movzbl (%eax),%ebx
80105170:	38 d9                	cmp    %bl,%cl
80105172:	74 ec                	je     80105160 <memcmp+0x20>
      return *s1 - *s2;
80105174:	0f b6 c1             	movzbl %cl,%eax
80105177:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80105179:	5b                   	pop    %ebx
8010517a:	5e                   	pop    %esi
8010517b:	5d                   	pop    %ebp
8010517c:	c3                   	ret    
8010517d:	8d 76 00             	lea    0x0(%esi),%esi
80105180:	5b                   	pop    %ebx
  return 0;
80105181:	31 c0                	xor    %eax,%eax
}
80105183:	5e                   	pop    %esi
80105184:	5d                   	pop    %ebp
80105185:	c3                   	ret    
80105186:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010518d:	8d 76 00             	lea    0x0(%esi),%esi

80105190 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	57                   	push   %edi
80105194:	8b 55 08             	mov    0x8(%ebp),%edx
80105197:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010519a:	56                   	push   %esi
8010519b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010519e:	39 d6                	cmp    %edx,%esi
801051a0:	73 26                	jae    801051c8 <memmove+0x38>
801051a2:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801051a5:	39 fa                	cmp    %edi,%edx
801051a7:	73 1f                	jae    801051c8 <memmove+0x38>
801051a9:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
801051ac:	85 c9                	test   %ecx,%ecx
801051ae:	74 0c                	je     801051bc <memmove+0x2c>
      *--d = *--s;
801051b0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801051b4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801051b7:	83 e8 01             	sub    $0x1,%eax
801051ba:	73 f4                	jae    801051b0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801051bc:	5e                   	pop    %esi
801051bd:	89 d0                	mov    %edx,%eax
801051bf:	5f                   	pop    %edi
801051c0:	5d                   	pop    %ebp
801051c1:	c3                   	ret    
801051c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
801051c8:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
801051cb:	89 d7                	mov    %edx,%edi
801051cd:	85 c9                	test   %ecx,%ecx
801051cf:	74 eb                	je     801051bc <memmove+0x2c>
801051d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801051d8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801051d9:	39 c6                	cmp    %eax,%esi
801051db:	75 fb                	jne    801051d8 <memmove+0x48>
}
801051dd:	5e                   	pop    %esi
801051de:	89 d0                	mov    %edx,%eax
801051e0:	5f                   	pop    %edi
801051e1:	5d                   	pop    %ebp
801051e2:	c3                   	ret    
801051e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801051f0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801051f0:	eb 9e                	jmp    80105190 <memmove>
801051f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105200 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105200:	55                   	push   %ebp
80105201:	89 e5                	mov    %esp,%ebp
80105203:	56                   	push   %esi
80105204:	8b 75 10             	mov    0x10(%ebp),%esi
80105207:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010520a:	53                   	push   %ebx
8010520b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
8010520e:	85 f6                	test   %esi,%esi
80105210:	74 2e                	je     80105240 <strncmp+0x40>
80105212:	01 d6                	add    %edx,%esi
80105214:	eb 18                	jmp    8010522e <strncmp+0x2e>
80105216:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010521d:	8d 76 00             	lea    0x0(%esi),%esi
80105220:	38 d8                	cmp    %bl,%al
80105222:	75 14                	jne    80105238 <strncmp+0x38>
    n--, p++, q++;
80105224:	83 c2 01             	add    $0x1,%edx
80105227:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010522a:	39 f2                	cmp    %esi,%edx
8010522c:	74 12                	je     80105240 <strncmp+0x40>
8010522e:	0f b6 01             	movzbl (%ecx),%eax
80105231:	0f b6 1a             	movzbl (%edx),%ebx
80105234:	84 c0                	test   %al,%al
80105236:	75 e8                	jne    80105220 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105238:	29 d8                	sub    %ebx,%eax
}
8010523a:	5b                   	pop    %ebx
8010523b:	5e                   	pop    %esi
8010523c:	5d                   	pop    %ebp
8010523d:	c3                   	ret    
8010523e:	66 90                	xchg   %ax,%ax
80105240:	5b                   	pop    %ebx
    return 0;
80105241:	31 c0                	xor    %eax,%eax
}
80105243:	5e                   	pop    %esi
80105244:	5d                   	pop    %ebp
80105245:	c3                   	ret    
80105246:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010524d:	8d 76 00             	lea    0x0(%esi),%esi

80105250 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105250:	55                   	push   %ebp
80105251:	89 e5                	mov    %esp,%ebp
80105253:	57                   	push   %edi
80105254:	56                   	push   %esi
80105255:	8b 75 08             	mov    0x8(%ebp),%esi
80105258:	53                   	push   %ebx
80105259:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010525c:	89 f0                	mov    %esi,%eax
8010525e:	eb 15                	jmp    80105275 <strncpy+0x25>
80105260:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105264:	8b 7d 0c             	mov    0xc(%ebp),%edi
80105267:	83 c0 01             	add    $0x1,%eax
8010526a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
8010526e:	88 50 ff             	mov    %dl,-0x1(%eax)
80105271:	84 d2                	test   %dl,%dl
80105273:	74 09                	je     8010527e <strncpy+0x2e>
80105275:	89 cb                	mov    %ecx,%ebx
80105277:	83 e9 01             	sub    $0x1,%ecx
8010527a:	85 db                	test   %ebx,%ebx
8010527c:	7f e2                	jg     80105260 <strncpy+0x10>
    ;
  while(n-- > 0)
8010527e:	89 c2                	mov    %eax,%edx
80105280:	85 c9                	test   %ecx,%ecx
80105282:	7e 17                	jle    8010529b <strncpy+0x4b>
80105284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105288:	83 c2 01             	add    $0x1,%edx
8010528b:	89 c1                	mov    %eax,%ecx
8010528d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80105291:	29 d1                	sub    %edx,%ecx
80105293:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80105297:	85 c9                	test   %ecx,%ecx
80105299:	7f ed                	jg     80105288 <strncpy+0x38>
  return os;
}
8010529b:	5b                   	pop    %ebx
8010529c:	89 f0                	mov    %esi,%eax
8010529e:	5e                   	pop    %esi
8010529f:	5f                   	pop    %edi
801052a0:	5d                   	pop    %ebp
801052a1:	c3                   	ret    
801052a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801052b0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801052b0:	55                   	push   %ebp
801052b1:	89 e5                	mov    %esp,%ebp
801052b3:	56                   	push   %esi
801052b4:	8b 55 10             	mov    0x10(%ebp),%edx
801052b7:	8b 75 08             	mov    0x8(%ebp),%esi
801052ba:	53                   	push   %ebx
801052bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801052be:	85 d2                	test   %edx,%edx
801052c0:	7e 25                	jle    801052e7 <safestrcpy+0x37>
801052c2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
801052c6:	89 f2                	mov    %esi,%edx
801052c8:	eb 16                	jmp    801052e0 <safestrcpy+0x30>
801052ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801052d0:	0f b6 08             	movzbl (%eax),%ecx
801052d3:	83 c0 01             	add    $0x1,%eax
801052d6:	83 c2 01             	add    $0x1,%edx
801052d9:	88 4a ff             	mov    %cl,-0x1(%edx)
801052dc:	84 c9                	test   %cl,%cl
801052de:	74 04                	je     801052e4 <safestrcpy+0x34>
801052e0:	39 d8                	cmp    %ebx,%eax
801052e2:	75 ec                	jne    801052d0 <safestrcpy+0x20>
    ;
  *s = 0;
801052e4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801052e7:	89 f0                	mov    %esi,%eax
801052e9:	5b                   	pop    %ebx
801052ea:	5e                   	pop    %esi
801052eb:	5d                   	pop    %ebp
801052ec:	c3                   	ret    
801052ed:	8d 76 00             	lea    0x0(%esi),%esi

801052f0 <strlen>:

int
strlen(const char *s)
{
801052f0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801052f1:	31 c0                	xor    %eax,%eax
{
801052f3:	89 e5                	mov    %esp,%ebp
801052f5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801052f8:	80 3a 00             	cmpb   $0x0,(%edx)
801052fb:	74 0c                	je     80105309 <strlen+0x19>
801052fd:	8d 76 00             	lea    0x0(%esi),%esi
80105300:	83 c0 01             	add    $0x1,%eax
80105303:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105307:	75 f7                	jne    80105300 <strlen+0x10>
    ;
  return n;
}
80105309:	5d                   	pop    %ebp
8010530a:	c3                   	ret    

8010530b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010530b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010530f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105313:	55                   	push   %ebp
  pushl %ebx
80105314:	53                   	push   %ebx
  pushl %esi
80105315:	56                   	push   %esi
  pushl %edi
80105316:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105317:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105319:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010531b:	5f                   	pop    %edi
  popl %esi
8010531c:	5e                   	pop    %esi
  popl %ebx
8010531d:	5b                   	pop    %ebx
  popl %ebp
8010531e:	5d                   	pop    %ebp
  ret
8010531f:	c3                   	ret    

80105320 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105320:	55                   	push   %ebp
80105321:	89 e5                	mov    %esp,%ebp
80105323:	53                   	push   %ebx
80105324:	83 ec 04             	sub    $0x4,%esp
80105327:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010532a:	e8 31 e7 ff ff       	call   80103a60 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010532f:	8b 00                	mov    (%eax),%eax
80105331:	39 d8                	cmp    %ebx,%eax
80105333:	76 1b                	jbe    80105350 <fetchint+0x30>
80105335:	8d 53 04             	lea    0x4(%ebx),%edx
80105338:	39 d0                	cmp    %edx,%eax
8010533a:	72 14                	jb     80105350 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010533c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010533f:	8b 13                	mov    (%ebx),%edx
80105341:	89 10                	mov    %edx,(%eax)
  return 0;
80105343:	31 c0                	xor    %eax,%eax
}
80105345:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105348:	c9                   	leave  
80105349:	c3                   	ret    
8010534a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105350:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105355:	eb ee                	jmp    80105345 <fetchint+0x25>
80105357:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010535e:	66 90                	xchg   %ax,%ax

80105360 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105360:	55                   	push   %ebp
80105361:	89 e5                	mov    %esp,%ebp
80105363:	53                   	push   %ebx
80105364:	83 ec 04             	sub    $0x4,%esp
80105367:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010536a:	e8 f1 e6 ff ff       	call   80103a60 <myproc>

  if(addr >= curproc->sz)
8010536f:	39 18                	cmp    %ebx,(%eax)
80105371:	76 2d                	jbe    801053a0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80105373:	8b 55 0c             	mov    0xc(%ebp),%edx
80105376:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105378:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010537a:	39 d3                	cmp    %edx,%ebx
8010537c:	73 22                	jae    801053a0 <fetchstr+0x40>
8010537e:	89 d8                	mov    %ebx,%eax
80105380:	eb 0d                	jmp    8010538f <fetchstr+0x2f>
80105382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105388:	83 c0 01             	add    $0x1,%eax
8010538b:	39 c2                	cmp    %eax,%edx
8010538d:	76 11                	jbe    801053a0 <fetchstr+0x40>
    if(*s == 0)
8010538f:	80 38 00             	cmpb   $0x0,(%eax)
80105392:	75 f4                	jne    80105388 <fetchstr+0x28>
      return s - *pp;
80105394:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80105396:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105399:	c9                   	leave  
8010539a:	c3                   	ret    
8010539b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010539f:	90                   	nop
801053a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
801053a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053a8:	c9                   	leave  
801053a9:	c3                   	ret    
801053aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801053b0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801053b0:	55                   	push   %ebp
801053b1:	89 e5                	mov    %esp,%ebp
801053b3:	56                   	push   %esi
801053b4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801053b5:	e8 a6 e6 ff ff       	call   80103a60 <myproc>
801053ba:	8b 55 08             	mov    0x8(%ebp),%edx
801053bd:	8b 40 18             	mov    0x18(%eax),%eax
801053c0:	8b 40 44             	mov    0x44(%eax),%eax
801053c3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801053c6:	e8 95 e6 ff ff       	call   80103a60 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801053cb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801053ce:	8b 00                	mov    (%eax),%eax
801053d0:	39 c6                	cmp    %eax,%esi
801053d2:	73 1c                	jae    801053f0 <argint+0x40>
801053d4:	8d 53 08             	lea    0x8(%ebx),%edx
801053d7:	39 d0                	cmp    %edx,%eax
801053d9:	72 15                	jb     801053f0 <argint+0x40>
  *ip = *(int*)(addr);
801053db:	8b 45 0c             	mov    0xc(%ebp),%eax
801053de:	8b 53 04             	mov    0x4(%ebx),%edx
801053e1:	89 10                	mov    %edx,(%eax)
  return 0;
801053e3:	31 c0                	xor    %eax,%eax
}
801053e5:	5b                   	pop    %ebx
801053e6:	5e                   	pop    %esi
801053e7:	5d                   	pop    %ebp
801053e8:	c3                   	ret    
801053e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801053f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801053f5:	eb ee                	jmp    801053e5 <argint+0x35>
801053f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053fe:	66 90                	xchg   %ax,%ax

80105400 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105400:	55                   	push   %ebp
80105401:	89 e5                	mov    %esp,%ebp
80105403:	57                   	push   %edi
80105404:	56                   	push   %esi
80105405:	53                   	push   %ebx
80105406:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80105409:	e8 52 e6 ff ff       	call   80103a60 <myproc>
8010540e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105410:	e8 4b e6 ff ff       	call   80103a60 <myproc>
80105415:	8b 55 08             	mov    0x8(%ebp),%edx
80105418:	8b 40 18             	mov    0x18(%eax),%eax
8010541b:	8b 40 44             	mov    0x44(%eax),%eax
8010541e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105421:	e8 3a e6 ff ff       	call   80103a60 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105426:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105429:	8b 00                	mov    (%eax),%eax
8010542b:	39 c7                	cmp    %eax,%edi
8010542d:	73 31                	jae    80105460 <argptr+0x60>
8010542f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80105432:	39 c8                	cmp    %ecx,%eax
80105434:	72 2a                	jb     80105460 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105436:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80105439:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
8010543c:	85 d2                	test   %edx,%edx
8010543e:	78 20                	js     80105460 <argptr+0x60>
80105440:	8b 16                	mov    (%esi),%edx
80105442:	39 c2                	cmp    %eax,%edx
80105444:	76 1a                	jbe    80105460 <argptr+0x60>
80105446:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105449:	01 c3                	add    %eax,%ebx
8010544b:	39 da                	cmp    %ebx,%edx
8010544d:	72 11                	jb     80105460 <argptr+0x60>
    return -1;
  *pp = (char*)i;
8010544f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105452:	89 02                	mov    %eax,(%edx)
  return 0;
80105454:	31 c0                	xor    %eax,%eax
}
80105456:	83 c4 0c             	add    $0xc,%esp
80105459:	5b                   	pop    %ebx
8010545a:	5e                   	pop    %esi
8010545b:	5f                   	pop    %edi
8010545c:	5d                   	pop    %ebp
8010545d:	c3                   	ret    
8010545e:	66 90                	xchg   %ax,%ax
    return -1;
80105460:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105465:	eb ef                	jmp    80105456 <argptr+0x56>
80105467:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010546e:	66 90                	xchg   %ax,%ax

80105470 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105470:	55                   	push   %ebp
80105471:	89 e5                	mov    %esp,%ebp
80105473:	56                   	push   %esi
80105474:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105475:	e8 e6 e5 ff ff       	call   80103a60 <myproc>
8010547a:	8b 55 08             	mov    0x8(%ebp),%edx
8010547d:	8b 40 18             	mov    0x18(%eax),%eax
80105480:	8b 40 44             	mov    0x44(%eax),%eax
80105483:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105486:	e8 d5 e5 ff ff       	call   80103a60 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010548b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010548e:	8b 00                	mov    (%eax),%eax
80105490:	39 c6                	cmp    %eax,%esi
80105492:	73 44                	jae    801054d8 <argstr+0x68>
80105494:	8d 53 08             	lea    0x8(%ebx),%edx
80105497:	39 d0                	cmp    %edx,%eax
80105499:	72 3d                	jb     801054d8 <argstr+0x68>
  *ip = *(int*)(addr);
8010549b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
8010549e:	e8 bd e5 ff ff       	call   80103a60 <myproc>
  if(addr >= curproc->sz)
801054a3:	3b 18                	cmp    (%eax),%ebx
801054a5:	73 31                	jae    801054d8 <argstr+0x68>
  *pp = (char*)addr;
801054a7:	8b 55 0c             	mov    0xc(%ebp),%edx
801054aa:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801054ac:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801054ae:	39 d3                	cmp    %edx,%ebx
801054b0:	73 26                	jae    801054d8 <argstr+0x68>
801054b2:	89 d8                	mov    %ebx,%eax
801054b4:	eb 11                	jmp    801054c7 <argstr+0x57>
801054b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054bd:	8d 76 00             	lea    0x0(%esi),%esi
801054c0:	83 c0 01             	add    $0x1,%eax
801054c3:	39 c2                	cmp    %eax,%edx
801054c5:	76 11                	jbe    801054d8 <argstr+0x68>
    if(*s == 0)
801054c7:	80 38 00             	cmpb   $0x0,(%eax)
801054ca:	75 f4                	jne    801054c0 <argstr+0x50>
      return s - *pp;
801054cc:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
801054ce:	5b                   	pop    %ebx
801054cf:	5e                   	pop    %esi
801054d0:	5d                   	pop    %ebp
801054d1:	c3                   	ret    
801054d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801054d8:	5b                   	pop    %ebx
    return -1;
801054d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054de:	5e                   	pop    %esi
801054df:	5d                   	pop    %ebp
801054e0:	c3                   	ret    
801054e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054ef:	90                   	nop

801054f0 <syscall>:
[SYS_printprocinfo]   sys_printprocinfo, 
};

void
syscall(void)
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
801054f3:	53                   	push   %ebx
801054f4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801054f7:	e8 64 e5 ff ff       	call   80103a60 <myproc>
801054fc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801054fe:	8b 40 18             	mov    0x18(%eax),%eax
80105501:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105504:	8d 50 ff             	lea    -0x1(%eax),%edx
80105507:	83 fa 16             	cmp    $0x16,%edx
8010550a:	77 24                	ja     80105530 <syscall+0x40>
8010550c:	8b 14 85 e0 84 10 80 	mov    -0x7fef7b20(,%eax,4),%edx
80105513:	85 d2                	test   %edx,%edx
80105515:	74 19                	je     80105530 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80105517:	ff d2                	call   *%edx
80105519:	89 c2                	mov    %eax,%edx
8010551b:	8b 43 18             	mov    0x18(%ebx),%eax
8010551e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105521:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105524:	c9                   	leave  
80105525:	c3                   	ret    
80105526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010552d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105530:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105531:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105534:	50                   	push   %eax
80105535:	ff 73 10             	push   0x10(%ebx)
80105538:	68 b5 84 10 80       	push   $0x801084b5
8010553d:	e8 5e b1 ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80105542:	8b 43 18             	mov    0x18(%ebx),%eax
80105545:	83 c4 10             	add    $0x10,%esp
80105548:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010554f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105552:	c9                   	leave  
80105553:	c3                   	ret    
80105554:	66 90                	xchg   %ax,%ax
80105556:	66 90                	xchg   %ax,%ax
80105558:	66 90                	xchg   %ax,%ax
8010555a:	66 90                	xchg   %ax,%ax
8010555c:	66 90                	xchg   %ax,%ax
8010555e:	66 90                	xchg   %ax,%ax

80105560 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	57                   	push   %edi
80105564:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105565:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105568:	53                   	push   %ebx
80105569:	83 ec 34             	sub    $0x34,%esp
8010556c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010556f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105572:	57                   	push   %edi
80105573:	50                   	push   %eax
{
80105574:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105577:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010557a:	e8 a1 cb ff ff       	call   80102120 <nameiparent>
8010557f:	83 c4 10             	add    $0x10,%esp
80105582:	85 c0                	test   %eax,%eax
80105584:	0f 84 46 01 00 00    	je     801056d0 <create+0x170>
    return 0;
  ilock(dp);
8010558a:	83 ec 0c             	sub    $0xc,%esp
8010558d:	89 c3                	mov    %eax,%ebx
8010558f:	50                   	push   %eax
80105590:	e8 4b c2 ff ff       	call   801017e0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105595:	83 c4 0c             	add    $0xc,%esp
80105598:	6a 00                	push   $0x0
8010559a:	57                   	push   %edi
8010559b:	53                   	push   %ebx
8010559c:	e8 9f c7 ff ff       	call   80101d40 <dirlookup>
801055a1:	83 c4 10             	add    $0x10,%esp
801055a4:	89 c6                	mov    %eax,%esi
801055a6:	85 c0                	test   %eax,%eax
801055a8:	74 56                	je     80105600 <create+0xa0>
    iunlockput(dp);
801055aa:	83 ec 0c             	sub    $0xc,%esp
801055ad:	53                   	push   %ebx
801055ae:	e8 bd c4 ff ff       	call   80101a70 <iunlockput>
    ilock(ip);
801055b3:	89 34 24             	mov    %esi,(%esp)
801055b6:	e8 25 c2 ff ff       	call   801017e0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801055bb:	83 c4 10             	add    $0x10,%esp
801055be:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801055c3:	75 1b                	jne    801055e0 <create+0x80>
801055c5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801055ca:	75 14                	jne    801055e0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801055cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055cf:	89 f0                	mov    %esi,%eax
801055d1:	5b                   	pop    %ebx
801055d2:	5e                   	pop    %esi
801055d3:	5f                   	pop    %edi
801055d4:	5d                   	pop    %ebp
801055d5:	c3                   	ret    
801055d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055dd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801055e0:	83 ec 0c             	sub    $0xc,%esp
801055e3:	56                   	push   %esi
    return 0;
801055e4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
801055e6:	e8 85 c4 ff ff       	call   80101a70 <iunlockput>
    return 0;
801055eb:	83 c4 10             	add    $0x10,%esp
}
801055ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055f1:	89 f0                	mov    %esi,%eax
801055f3:	5b                   	pop    %ebx
801055f4:	5e                   	pop    %esi
801055f5:	5f                   	pop    %edi
801055f6:	5d                   	pop    %ebp
801055f7:	c3                   	ret    
801055f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055ff:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105600:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105604:	83 ec 08             	sub    $0x8,%esp
80105607:	50                   	push   %eax
80105608:	ff 33                	push   (%ebx)
8010560a:	e8 61 c0 ff ff       	call   80101670 <ialloc>
8010560f:	83 c4 10             	add    $0x10,%esp
80105612:	89 c6                	mov    %eax,%esi
80105614:	85 c0                	test   %eax,%eax
80105616:	0f 84 cd 00 00 00    	je     801056e9 <create+0x189>
  ilock(ip);
8010561c:	83 ec 0c             	sub    $0xc,%esp
8010561f:	50                   	push   %eax
80105620:	e8 bb c1 ff ff       	call   801017e0 <ilock>
  ip->major = major;
80105625:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105629:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010562d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105631:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105635:	b8 01 00 00 00       	mov    $0x1,%eax
8010563a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010563e:	89 34 24             	mov    %esi,(%esp)
80105641:	e8 ea c0 ff ff       	call   80101730 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105646:	83 c4 10             	add    $0x10,%esp
80105649:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010564e:	74 30                	je     80105680 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105650:	83 ec 04             	sub    $0x4,%esp
80105653:	ff 76 04             	push   0x4(%esi)
80105656:	57                   	push   %edi
80105657:	53                   	push   %ebx
80105658:	e8 e3 c9 ff ff       	call   80102040 <dirlink>
8010565d:	83 c4 10             	add    $0x10,%esp
80105660:	85 c0                	test   %eax,%eax
80105662:	78 78                	js     801056dc <create+0x17c>
  iunlockput(dp);
80105664:	83 ec 0c             	sub    $0xc,%esp
80105667:	53                   	push   %ebx
80105668:	e8 03 c4 ff ff       	call   80101a70 <iunlockput>
  return ip;
8010566d:	83 c4 10             	add    $0x10,%esp
}
80105670:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105673:	89 f0                	mov    %esi,%eax
80105675:	5b                   	pop    %ebx
80105676:	5e                   	pop    %esi
80105677:	5f                   	pop    %edi
80105678:	5d                   	pop    %ebp
80105679:	c3                   	ret    
8010567a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105680:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105683:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105688:	53                   	push   %ebx
80105689:	e8 a2 c0 ff ff       	call   80101730 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010568e:	83 c4 0c             	add    $0xc,%esp
80105691:	ff 76 04             	push   0x4(%esi)
80105694:	68 5c 85 10 80       	push   $0x8010855c
80105699:	56                   	push   %esi
8010569a:	e8 a1 c9 ff ff       	call   80102040 <dirlink>
8010569f:	83 c4 10             	add    $0x10,%esp
801056a2:	85 c0                	test   %eax,%eax
801056a4:	78 18                	js     801056be <create+0x15e>
801056a6:	83 ec 04             	sub    $0x4,%esp
801056a9:	ff 73 04             	push   0x4(%ebx)
801056ac:	68 5b 85 10 80       	push   $0x8010855b
801056b1:	56                   	push   %esi
801056b2:	e8 89 c9 ff ff       	call   80102040 <dirlink>
801056b7:	83 c4 10             	add    $0x10,%esp
801056ba:	85 c0                	test   %eax,%eax
801056bc:	79 92                	jns    80105650 <create+0xf0>
      panic("create dots");
801056be:	83 ec 0c             	sub    $0xc,%esp
801056c1:	68 4f 85 10 80       	push   $0x8010854f
801056c6:	e8 b5 ac ff ff       	call   80100380 <panic>
801056cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056cf:	90                   	nop
}
801056d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801056d3:	31 f6                	xor    %esi,%esi
}
801056d5:	5b                   	pop    %ebx
801056d6:	89 f0                	mov    %esi,%eax
801056d8:	5e                   	pop    %esi
801056d9:	5f                   	pop    %edi
801056da:	5d                   	pop    %ebp
801056db:	c3                   	ret    
    panic("create: dirlink");
801056dc:	83 ec 0c             	sub    $0xc,%esp
801056df:	68 5e 85 10 80       	push   $0x8010855e
801056e4:	e8 97 ac ff ff       	call   80100380 <panic>
    panic("create: ialloc");
801056e9:	83 ec 0c             	sub    $0xc,%esp
801056ec:	68 40 85 10 80       	push   $0x80108540
801056f1:	e8 8a ac ff ff       	call   80100380 <panic>
801056f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056fd:	8d 76 00             	lea    0x0(%esi),%esi

80105700 <sys_dup>:
{
80105700:	55                   	push   %ebp
80105701:	89 e5                	mov    %esp,%ebp
80105703:	56                   	push   %esi
80105704:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105705:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105708:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010570b:	50                   	push   %eax
8010570c:	6a 00                	push   $0x0
8010570e:	e8 9d fc ff ff       	call   801053b0 <argint>
80105713:	83 c4 10             	add    $0x10,%esp
80105716:	85 c0                	test   %eax,%eax
80105718:	78 36                	js     80105750 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010571a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010571e:	77 30                	ja     80105750 <sys_dup+0x50>
80105720:	e8 3b e3 ff ff       	call   80103a60 <myproc>
80105725:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105728:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010572c:	85 f6                	test   %esi,%esi
8010572e:	74 20                	je     80105750 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105730:	e8 2b e3 ff ff       	call   80103a60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105735:	31 db                	xor    %ebx,%ebx
80105737:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010573e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105740:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105744:	85 d2                	test   %edx,%edx
80105746:	74 18                	je     80105760 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105748:	83 c3 01             	add    $0x1,%ebx
8010574b:	83 fb 10             	cmp    $0x10,%ebx
8010574e:	75 f0                	jne    80105740 <sys_dup+0x40>
}
80105750:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105753:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105758:	89 d8                	mov    %ebx,%eax
8010575a:	5b                   	pop    %ebx
8010575b:	5e                   	pop    %esi
8010575c:	5d                   	pop    %ebp
8010575d:	c3                   	ret    
8010575e:	66 90                	xchg   %ax,%ax
  filedup(f);
80105760:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105763:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105767:	56                   	push   %esi
80105768:	e8 93 b7 ff ff       	call   80100f00 <filedup>
  return fd;
8010576d:	83 c4 10             	add    $0x10,%esp
}
80105770:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105773:	89 d8                	mov    %ebx,%eax
80105775:	5b                   	pop    %ebx
80105776:	5e                   	pop    %esi
80105777:	5d                   	pop    %ebp
80105778:	c3                   	ret    
80105779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105780 <sys_read>:
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	56                   	push   %esi
80105784:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105785:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105788:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010578b:	53                   	push   %ebx
8010578c:	6a 00                	push   $0x0
8010578e:	e8 1d fc ff ff       	call   801053b0 <argint>
80105793:	83 c4 10             	add    $0x10,%esp
80105796:	85 c0                	test   %eax,%eax
80105798:	78 5e                	js     801057f8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010579a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010579e:	77 58                	ja     801057f8 <sys_read+0x78>
801057a0:	e8 bb e2 ff ff       	call   80103a60 <myproc>
801057a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801057a8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801057ac:	85 f6                	test   %esi,%esi
801057ae:	74 48                	je     801057f8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801057b0:	83 ec 08             	sub    $0x8,%esp
801057b3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057b6:	50                   	push   %eax
801057b7:	6a 02                	push   $0x2
801057b9:	e8 f2 fb ff ff       	call   801053b0 <argint>
801057be:	83 c4 10             	add    $0x10,%esp
801057c1:	85 c0                	test   %eax,%eax
801057c3:	78 33                	js     801057f8 <sys_read+0x78>
801057c5:	83 ec 04             	sub    $0x4,%esp
801057c8:	ff 75 f0             	push   -0x10(%ebp)
801057cb:	53                   	push   %ebx
801057cc:	6a 01                	push   $0x1
801057ce:	e8 2d fc ff ff       	call   80105400 <argptr>
801057d3:	83 c4 10             	add    $0x10,%esp
801057d6:	85 c0                	test   %eax,%eax
801057d8:	78 1e                	js     801057f8 <sys_read+0x78>
  return fileread(f, p, n);
801057da:	83 ec 04             	sub    $0x4,%esp
801057dd:	ff 75 f0             	push   -0x10(%ebp)
801057e0:	ff 75 f4             	push   -0xc(%ebp)
801057e3:	56                   	push   %esi
801057e4:	e8 97 b8 ff ff       	call   80101080 <fileread>
801057e9:	83 c4 10             	add    $0x10,%esp
}
801057ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
801057ef:	5b                   	pop    %ebx
801057f0:	5e                   	pop    %esi
801057f1:	5d                   	pop    %ebp
801057f2:	c3                   	ret    
801057f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057f7:	90                   	nop
    return -1;
801057f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057fd:	eb ed                	jmp    801057ec <sys_read+0x6c>
801057ff:	90                   	nop

80105800 <sys_write>:
{
80105800:	55                   	push   %ebp
80105801:	89 e5                	mov    %esp,%ebp
80105803:	56                   	push   %esi
80105804:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105805:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105808:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010580b:	53                   	push   %ebx
8010580c:	6a 00                	push   $0x0
8010580e:	e8 9d fb ff ff       	call   801053b0 <argint>
80105813:	83 c4 10             	add    $0x10,%esp
80105816:	85 c0                	test   %eax,%eax
80105818:	78 5e                	js     80105878 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010581a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010581e:	77 58                	ja     80105878 <sys_write+0x78>
80105820:	e8 3b e2 ff ff       	call   80103a60 <myproc>
80105825:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105828:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010582c:	85 f6                	test   %esi,%esi
8010582e:	74 48                	je     80105878 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105830:	83 ec 08             	sub    $0x8,%esp
80105833:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105836:	50                   	push   %eax
80105837:	6a 02                	push   $0x2
80105839:	e8 72 fb ff ff       	call   801053b0 <argint>
8010583e:	83 c4 10             	add    $0x10,%esp
80105841:	85 c0                	test   %eax,%eax
80105843:	78 33                	js     80105878 <sys_write+0x78>
80105845:	83 ec 04             	sub    $0x4,%esp
80105848:	ff 75 f0             	push   -0x10(%ebp)
8010584b:	53                   	push   %ebx
8010584c:	6a 01                	push   $0x1
8010584e:	e8 ad fb ff ff       	call   80105400 <argptr>
80105853:	83 c4 10             	add    $0x10,%esp
80105856:	85 c0                	test   %eax,%eax
80105858:	78 1e                	js     80105878 <sys_write+0x78>
  return filewrite(f, p, n);
8010585a:	83 ec 04             	sub    $0x4,%esp
8010585d:	ff 75 f0             	push   -0x10(%ebp)
80105860:	ff 75 f4             	push   -0xc(%ebp)
80105863:	56                   	push   %esi
80105864:	e8 a7 b8 ff ff       	call   80101110 <filewrite>
80105869:	83 c4 10             	add    $0x10,%esp
}
8010586c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010586f:	5b                   	pop    %ebx
80105870:	5e                   	pop    %esi
80105871:	5d                   	pop    %ebp
80105872:	c3                   	ret    
80105873:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105877:	90                   	nop
    return -1;
80105878:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010587d:	eb ed                	jmp    8010586c <sys_write+0x6c>
8010587f:	90                   	nop

80105880 <sys_close>:
{
80105880:	55                   	push   %ebp
80105881:	89 e5                	mov    %esp,%ebp
80105883:	56                   	push   %esi
80105884:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105885:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105888:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010588b:	50                   	push   %eax
8010588c:	6a 00                	push   $0x0
8010588e:	e8 1d fb ff ff       	call   801053b0 <argint>
80105893:	83 c4 10             	add    $0x10,%esp
80105896:	85 c0                	test   %eax,%eax
80105898:	78 3e                	js     801058d8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010589a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010589e:	77 38                	ja     801058d8 <sys_close+0x58>
801058a0:	e8 bb e1 ff ff       	call   80103a60 <myproc>
801058a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801058a8:	8d 5a 08             	lea    0x8(%edx),%ebx
801058ab:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
801058af:	85 f6                	test   %esi,%esi
801058b1:	74 25                	je     801058d8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
801058b3:	e8 a8 e1 ff ff       	call   80103a60 <myproc>
  fileclose(f);
801058b8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801058bb:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
801058c2:	00 
  fileclose(f);
801058c3:	56                   	push   %esi
801058c4:	e8 87 b6 ff ff       	call   80100f50 <fileclose>
  return 0;
801058c9:	83 c4 10             	add    $0x10,%esp
801058cc:	31 c0                	xor    %eax,%eax
}
801058ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801058d1:	5b                   	pop    %ebx
801058d2:	5e                   	pop    %esi
801058d3:	5d                   	pop    %ebp
801058d4:	c3                   	ret    
801058d5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801058d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058dd:	eb ef                	jmp    801058ce <sys_close+0x4e>
801058df:	90                   	nop

801058e0 <sys_fstat>:
{
801058e0:	55                   	push   %ebp
801058e1:	89 e5                	mov    %esp,%ebp
801058e3:	56                   	push   %esi
801058e4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801058e5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801058e8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801058eb:	53                   	push   %ebx
801058ec:	6a 00                	push   $0x0
801058ee:	e8 bd fa ff ff       	call   801053b0 <argint>
801058f3:	83 c4 10             	add    $0x10,%esp
801058f6:	85 c0                	test   %eax,%eax
801058f8:	78 46                	js     80105940 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801058fa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801058fe:	77 40                	ja     80105940 <sys_fstat+0x60>
80105900:	e8 5b e1 ff ff       	call   80103a60 <myproc>
80105905:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105908:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010590c:	85 f6                	test   %esi,%esi
8010590e:	74 30                	je     80105940 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105910:	83 ec 04             	sub    $0x4,%esp
80105913:	6a 14                	push   $0x14
80105915:	53                   	push   %ebx
80105916:	6a 01                	push   $0x1
80105918:	e8 e3 fa ff ff       	call   80105400 <argptr>
8010591d:	83 c4 10             	add    $0x10,%esp
80105920:	85 c0                	test   %eax,%eax
80105922:	78 1c                	js     80105940 <sys_fstat+0x60>
  return filestat(f, st);
80105924:	83 ec 08             	sub    $0x8,%esp
80105927:	ff 75 f4             	push   -0xc(%ebp)
8010592a:	56                   	push   %esi
8010592b:	e8 00 b7 ff ff       	call   80101030 <filestat>
80105930:	83 c4 10             	add    $0x10,%esp
}
80105933:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105936:	5b                   	pop    %ebx
80105937:	5e                   	pop    %esi
80105938:	5d                   	pop    %ebp
80105939:	c3                   	ret    
8010593a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105940:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105945:	eb ec                	jmp    80105933 <sys_fstat+0x53>
80105947:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010594e:	66 90                	xchg   %ax,%ax

80105950 <sys_link>:
{
80105950:	55                   	push   %ebp
80105951:	89 e5                	mov    %esp,%ebp
80105953:	57                   	push   %edi
80105954:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105955:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105958:	53                   	push   %ebx
80105959:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010595c:	50                   	push   %eax
8010595d:	6a 00                	push   $0x0
8010595f:	e8 0c fb ff ff       	call   80105470 <argstr>
80105964:	83 c4 10             	add    $0x10,%esp
80105967:	85 c0                	test   %eax,%eax
80105969:	0f 88 fb 00 00 00    	js     80105a6a <sys_link+0x11a>
8010596f:	83 ec 08             	sub    $0x8,%esp
80105972:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105975:	50                   	push   %eax
80105976:	6a 01                	push   $0x1
80105978:	e8 f3 fa ff ff       	call   80105470 <argstr>
8010597d:	83 c4 10             	add    $0x10,%esp
80105980:	85 c0                	test   %eax,%eax
80105982:	0f 88 e2 00 00 00    	js     80105a6a <sys_link+0x11a>
  begin_op();
80105988:	e8 33 d4 ff ff       	call   80102dc0 <begin_op>
  if((ip = namei(old)) == 0){
8010598d:	83 ec 0c             	sub    $0xc,%esp
80105990:	ff 75 d4             	push   -0x2c(%ebp)
80105993:	e8 68 c7 ff ff       	call   80102100 <namei>
80105998:	83 c4 10             	add    $0x10,%esp
8010599b:	89 c3                	mov    %eax,%ebx
8010599d:	85 c0                	test   %eax,%eax
8010599f:	0f 84 e4 00 00 00    	je     80105a89 <sys_link+0x139>
  ilock(ip);
801059a5:	83 ec 0c             	sub    $0xc,%esp
801059a8:	50                   	push   %eax
801059a9:	e8 32 be ff ff       	call   801017e0 <ilock>
  if(ip->type == T_DIR){
801059ae:	83 c4 10             	add    $0x10,%esp
801059b1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801059b6:	0f 84 b5 00 00 00    	je     80105a71 <sys_link+0x121>
  iupdate(ip);
801059bc:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801059bf:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801059c4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801059c7:	53                   	push   %ebx
801059c8:	e8 63 bd ff ff       	call   80101730 <iupdate>
  iunlock(ip);
801059cd:	89 1c 24             	mov    %ebx,(%esp)
801059d0:	e8 eb be ff ff       	call   801018c0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801059d5:	58                   	pop    %eax
801059d6:	5a                   	pop    %edx
801059d7:	57                   	push   %edi
801059d8:	ff 75 d0             	push   -0x30(%ebp)
801059db:	e8 40 c7 ff ff       	call   80102120 <nameiparent>
801059e0:	83 c4 10             	add    $0x10,%esp
801059e3:	89 c6                	mov    %eax,%esi
801059e5:	85 c0                	test   %eax,%eax
801059e7:	74 5b                	je     80105a44 <sys_link+0xf4>
  ilock(dp);
801059e9:	83 ec 0c             	sub    $0xc,%esp
801059ec:	50                   	push   %eax
801059ed:	e8 ee bd ff ff       	call   801017e0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801059f2:	8b 03                	mov    (%ebx),%eax
801059f4:	83 c4 10             	add    $0x10,%esp
801059f7:	39 06                	cmp    %eax,(%esi)
801059f9:	75 3d                	jne    80105a38 <sys_link+0xe8>
801059fb:	83 ec 04             	sub    $0x4,%esp
801059fe:	ff 73 04             	push   0x4(%ebx)
80105a01:	57                   	push   %edi
80105a02:	56                   	push   %esi
80105a03:	e8 38 c6 ff ff       	call   80102040 <dirlink>
80105a08:	83 c4 10             	add    $0x10,%esp
80105a0b:	85 c0                	test   %eax,%eax
80105a0d:	78 29                	js     80105a38 <sys_link+0xe8>
  iunlockput(dp);
80105a0f:	83 ec 0c             	sub    $0xc,%esp
80105a12:	56                   	push   %esi
80105a13:	e8 58 c0 ff ff       	call   80101a70 <iunlockput>
  iput(ip);
80105a18:	89 1c 24             	mov    %ebx,(%esp)
80105a1b:	e8 f0 be ff ff       	call   80101910 <iput>
  end_op();
80105a20:	e8 0b d4 ff ff       	call   80102e30 <end_op>
  return 0;
80105a25:	83 c4 10             	add    $0x10,%esp
80105a28:	31 c0                	xor    %eax,%eax
}
80105a2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a2d:	5b                   	pop    %ebx
80105a2e:	5e                   	pop    %esi
80105a2f:	5f                   	pop    %edi
80105a30:	5d                   	pop    %ebp
80105a31:	c3                   	ret    
80105a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105a38:	83 ec 0c             	sub    $0xc,%esp
80105a3b:	56                   	push   %esi
80105a3c:	e8 2f c0 ff ff       	call   80101a70 <iunlockput>
    goto bad;
80105a41:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105a44:	83 ec 0c             	sub    $0xc,%esp
80105a47:	53                   	push   %ebx
80105a48:	e8 93 bd ff ff       	call   801017e0 <ilock>
  ip->nlink--;
80105a4d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105a52:	89 1c 24             	mov    %ebx,(%esp)
80105a55:	e8 d6 bc ff ff       	call   80101730 <iupdate>
  iunlockput(ip);
80105a5a:	89 1c 24             	mov    %ebx,(%esp)
80105a5d:	e8 0e c0 ff ff       	call   80101a70 <iunlockput>
  end_op();
80105a62:	e8 c9 d3 ff ff       	call   80102e30 <end_op>
  return -1;
80105a67:	83 c4 10             	add    $0x10,%esp
80105a6a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a6f:	eb b9                	jmp    80105a2a <sys_link+0xda>
    iunlockput(ip);
80105a71:	83 ec 0c             	sub    $0xc,%esp
80105a74:	53                   	push   %ebx
80105a75:	e8 f6 bf ff ff       	call   80101a70 <iunlockput>
    end_op();
80105a7a:	e8 b1 d3 ff ff       	call   80102e30 <end_op>
    return -1;
80105a7f:	83 c4 10             	add    $0x10,%esp
80105a82:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a87:	eb a1                	jmp    80105a2a <sys_link+0xda>
    end_op();
80105a89:	e8 a2 d3 ff ff       	call   80102e30 <end_op>
    return -1;
80105a8e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a93:	eb 95                	jmp    80105a2a <sys_link+0xda>
80105a95:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105aa0 <sys_unlink>:
{
80105aa0:	55                   	push   %ebp
80105aa1:	89 e5                	mov    %esp,%ebp
80105aa3:	57                   	push   %edi
80105aa4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105aa5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105aa8:	53                   	push   %ebx
80105aa9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105aac:	50                   	push   %eax
80105aad:	6a 00                	push   $0x0
80105aaf:	e8 bc f9 ff ff       	call   80105470 <argstr>
80105ab4:	83 c4 10             	add    $0x10,%esp
80105ab7:	85 c0                	test   %eax,%eax
80105ab9:	0f 88 7a 01 00 00    	js     80105c39 <sys_unlink+0x199>
  begin_op();
80105abf:	e8 fc d2 ff ff       	call   80102dc0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105ac4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105ac7:	83 ec 08             	sub    $0x8,%esp
80105aca:	53                   	push   %ebx
80105acb:	ff 75 c0             	push   -0x40(%ebp)
80105ace:	e8 4d c6 ff ff       	call   80102120 <nameiparent>
80105ad3:	83 c4 10             	add    $0x10,%esp
80105ad6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105ad9:	85 c0                	test   %eax,%eax
80105adb:	0f 84 62 01 00 00    	je     80105c43 <sys_unlink+0x1a3>
  ilock(dp);
80105ae1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105ae4:	83 ec 0c             	sub    $0xc,%esp
80105ae7:	57                   	push   %edi
80105ae8:	e8 f3 bc ff ff       	call   801017e0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105aed:	58                   	pop    %eax
80105aee:	5a                   	pop    %edx
80105aef:	68 5c 85 10 80       	push   $0x8010855c
80105af4:	53                   	push   %ebx
80105af5:	e8 26 c2 ff ff       	call   80101d20 <namecmp>
80105afa:	83 c4 10             	add    $0x10,%esp
80105afd:	85 c0                	test   %eax,%eax
80105aff:	0f 84 fb 00 00 00    	je     80105c00 <sys_unlink+0x160>
80105b05:	83 ec 08             	sub    $0x8,%esp
80105b08:	68 5b 85 10 80       	push   $0x8010855b
80105b0d:	53                   	push   %ebx
80105b0e:	e8 0d c2 ff ff       	call   80101d20 <namecmp>
80105b13:	83 c4 10             	add    $0x10,%esp
80105b16:	85 c0                	test   %eax,%eax
80105b18:	0f 84 e2 00 00 00    	je     80105c00 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
80105b1e:	83 ec 04             	sub    $0x4,%esp
80105b21:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105b24:	50                   	push   %eax
80105b25:	53                   	push   %ebx
80105b26:	57                   	push   %edi
80105b27:	e8 14 c2 ff ff       	call   80101d40 <dirlookup>
80105b2c:	83 c4 10             	add    $0x10,%esp
80105b2f:	89 c3                	mov    %eax,%ebx
80105b31:	85 c0                	test   %eax,%eax
80105b33:	0f 84 c7 00 00 00    	je     80105c00 <sys_unlink+0x160>
  ilock(ip);
80105b39:	83 ec 0c             	sub    $0xc,%esp
80105b3c:	50                   	push   %eax
80105b3d:	e8 9e bc ff ff       	call   801017e0 <ilock>
  if(ip->nlink < 1)
80105b42:	83 c4 10             	add    $0x10,%esp
80105b45:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105b4a:	0f 8e 1c 01 00 00    	jle    80105c6c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105b50:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105b55:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105b58:	74 66                	je     80105bc0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105b5a:	83 ec 04             	sub    $0x4,%esp
80105b5d:	6a 10                	push   $0x10
80105b5f:	6a 00                	push   $0x0
80105b61:	57                   	push   %edi
80105b62:	e8 89 f5 ff ff       	call   801050f0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105b67:	6a 10                	push   $0x10
80105b69:	ff 75 c4             	push   -0x3c(%ebp)
80105b6c:	57                   	push   %edi
80105b6d:	ff 75 b4             	push   -0x4c(%ebp)
80105b70:	e8 7b c0 ff ff       	call   80101bf0 <writei>
80105b75:	83 c4 20             	add    $0x20,%esp
80105b78:	83 f8 10             	cmp    $0x10,%eax
80105b7b:	0f 85 de 00 00 00    	jne    80105c5f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105b81:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105b86:	0f 84 94 00 00 00    	je     80105c20 <sys_unlink+0x180>
  iunlockput(dp);
80105b8c:	83 ec 0c             	sub    $0xc,%esp
80105b8f:	ff 75 b4             	push   -0x4c(%ebp)
80105b92:	e8 d9 be ff ff       	call   80101a70 <iunlockput>
  ip->nlink--;
80105b97:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105b9c:	89 1c 24             	mov    %ebx,(%esp)
80105b9f:	e8 8c bb ff ff       	call   80101730 <iupdate>
  iunlockput(ip);
80105ba4:	89 1c 24             	mov    %ebx,(%esp)
80105ba7:	e8 c4 be ff ff       	call   80101a70 <iunlockput>
  end_op();
80105bac:	e8 7f d2 ff ff       	call   80102e30 <end_op>
  return 0;
80105bb1:	83 c4 10             	add    $0x10,%esp
80105bb4:	31 c0                	xor    %eax,%eax
}
80105bb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bb9:	5b                   	pop    %ebx
80105bba:	5e                   	pop    %esi
80105bbb:	5f                   	pop    %edi
80105bbc:	5d                   	pop    %ebp
80105bbd:	c3                   	ret    
80105bbe:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105bc0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105bc4:	76 94                	jbe    80105b5a <sys_unlink+0xba>
80105bc6:	be 20 00 00 00       	mov    $0x20,%esi
80105bcb:	eb 0b                	jmp    80105bd8 <sys_unlink+0x138>
80105bcd:	8d 76 00             	lea    0x0(%esi),%esi
80105bd0:	83 c6 10             	add    $0x10,%esi
80105bd3:	3b 73 58             	cmp    0x58(%ebx),%esi
80105bd6:	73 82                	jae    80105b5a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105bd8:	6a 10                	push   $0x10
80105bda:	56                   	push   %esi
80105bdb:	57                   	push   %edi
80105bdc:	53                   	push   %ebx
80105bdd:	e8 0e bf ff ff       	call   80101af0 <readi>
80105be2:	83 c4 10             	add    $0x10,%esp
80105be5:	83 f8 10             	cmp    $0x10,%eax
80105be8:	75 68                	jne    80105c52 <sys_unlink+0x1b2>
    if(de.inum != 0)
80105bea:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105bef:	74 df                	je     80105bd0 <sys_unlink+0x130>
    iunlockput(ip);
80105bf1:	83 ec 0c             	sub    $0xc,%esp
80105bf4:	53                   	push   %ebx
80105bf5:	e8 76 be ff ff       	call   80101a70 <iunlockput>
    goto bad;
80105bfa:	83 c4 10             	add    $0x10,%esp
80105bfd:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105c00:	83 ec 0c             	sub    $0xc,%esp
80105c03:	ff 75 b4             	push   -0x4c(%ebp)
80105c06:	e8 65 be ff ff       	call   80101a70 <iunlockput>
  end_op();
80105c0b:	e8 20 d2 ff ff       	call   80102e30 <end_op>
  return -1;
80105c10:	83 c4 10             	add    $0x10,%esp
80105c13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c18:	eb 9c                	jmp    80105bb6 <sys_unlink+0x116>
80105c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105c20:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105c23:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105c26:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105c2b:	50                   	push   %eax
80105c2c:	e8 ff ba ff ff       	call   80101730 <iupdate>
80105c31:	83 c4 10             	add    $0x10,%esp
80105c34:	e9 53 ff ff ff       	jmp    80105b8c <sys_unlink+0xec>
    return -1;
80105c39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c3e:	e9 73 ff ff ff       	jmp    80105bb6 <sys_unlink+0x116>
    end_op();
80105c43:	e8 e8 d1 ff ff       	call   80102e30 <end_op>
    return -1;
80105c48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c4d:	e9 64 ff ff ff       	jmp    80105bb6 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105c52:	83 ec 0c             	sub    $0xc,%esp
80105c55:	68 80 85 10 80       	push   $0x80108580
80105c5a:	e8 21 a7 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
80105c5f:	83 ec 0c             	sub    $0xc,%esp
80105c62:	68 92 85 10 80       	push   $0x80108592
80105c67:	e8 14 a7 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
80105c6c:	83 ec 0c             	sub    $0xc,%esp
80105c6f:	68 6e 85 10 80       	push   $0x8010856e
80105c74:	e8 07 a7 ff ff       	call   80100380 <panic>
80105c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c80 <sys_open>:

int
sys_open(void)
{
80105c80:	55                   	push   %ebp
80105c81:	89 e5                	mov    %esp,%ebp
80105c83:	57                   	push   %edi
80105c84:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105c85:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105c88:	53                   	push   %ebx
80105c89:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105c8c:	50                   	push   %eax
80105c8d:	6a 00                	push   $0x0
80105c8f:	e8 dc f7 ff ff       	call   80105470 <argstr>
80105c94:	83 c4 10             	add    $0x10,%esp
80105c97:	85 c0                	test   %eax,%eax
80105c99:	0f 88 8e 00 00 00    	js     80105d2d <sys_open+0xad>
80105c9f:	83 ec 08             	sub    $0x8,%esp
80105ca2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ca5:	50                   	push   %eax
80105ca6:	6a 01                	push   $0x1
80105ca8:	e8 03 f7 ff ff       	call   801053b0 <argint>
80105cad:	83 c4 10             	add    $0x10,%esp
80105cb0:	85 c0                	test   %eax,%eax
80105cb2:	78 79                	js     80105d2d <sys_open+0xad>
    return -1;

  begin_op();
80105cb4:	e8 07 d1 ff ff       	call   80102dc0 <begin_op>

  if(omode & O_CREATE){
80105cb9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105cbd:	75 79                	jne    80105d38 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105cbf:	83 ec 0c             	sub    $0xc,%esp
80105cc2:	ff 75 e0             	push   -0x20(%ebp)
80105cc5:	e8 36 c4 ff ff       	call   80102100 <namei>
80105cca:	83 c4 10             	add    $0x10,%esp
80105ccd:	89 c6                	mov    %eax,%esi
80105ccf:	85 c0                	test   %eax,%eax
80105cd1:	0f 84 7e 00 00 00    	je     80105d55 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105cd7:	83 ec 0c             	sub    $0xc,%esp
80105cda:	50                   	push   %eax
80105cdb:	e8 00 bb ff ff       	call   801017e0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105ce0:	83 c4 10             	add    $0x10,%esp
80105ce3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105ce8:	0f 84 c2 00 00 00    	je     80105db0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105cee:	e8 9d b1 ff ff       	call   80100e90 <filealloc>
80105cf3:	89 c7                	mov    %eax,%edi
80105cf5:	85 c0                	test   %eax,%eax
80105cf7:	74 23                	je     80105d1c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105cf9:	e8 62 dd ff ff       	call   80103a60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105cfe:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105d00:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105d04:	85 d2                	test   %edx,%edx
80105d06:	74 60                	je     80105d68 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105d08:	83 c3 01             	add    $0x1,%ebx
80105d0b:	83 fb 10             	cmp    $0x10,%ebx
80105d0e:	75 f0                	jne    80105d00 <sys_open+0x80>
    if(f)
      fileclose(f);
80105d10:	83 ec 0c             	sub    $0xc,%esp
80105d13:	57                   	push   %edi
80105d14:	e8 37 b2 ff ff       	call   80100f50 <fileclose>
80105d19:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105d1c:	83 ec 0c             	sub    $0xc,%esp
80105d1f:	56                   	push   %esi
80105d20:	e8 4b bd ff ff       	call   80101a70 <iunlockput>
    end_op();
80105d25:	e8 06 d1 ff ff       	call   80102e30 <end_op>
    return -1;
80105d2a:	83 c4 10             	add    $0x10,%esp
80105d2d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105d32:	eb 6d                	jmp    80105da1 <sys_open+0x121>
80105d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105d38:	83 ec 0c             	sub    $0xc,%esp
80105d3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105d3e:	31 c9                	xor    %ecx,%ecx
80105d40:	ba 02 00 00 00       	mov    $0x2,%edx
80105d45:	6a 00                	push   $0x0
80105d47:	e8 14 f8 ff ff       	call   80105560 <create>
    if(ip == 0){
80105d4c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105d4f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105d51:	85 c0                	test   %eax,%eax
80105d53:	75 99                	jne    80105cee <sys_open+0x6e>
      end_op();
80105d55:	e8 d6 d0 ff ff       	call   80102e30 <end_op>
      return -1;
80105d5a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105d5f:	eb 40                	jmp    80105da1 <sys_open+0x121>
80105d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105d68:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105d6b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105d6f:	56                   	push   %esi
80105d70:	e8 4b bb ff ff       	call   801018c0 <iunlock>
  end_op();
80105d75:	e8 b6 d0 ff ff       	call   80102e30 <end_op>

  f->type = FD_INODE;
80105d7a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105d80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105d83:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105d86:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105d89:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105d8b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105d92:	f7 d0                	not    %eax
80105d94:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105d97:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105d9a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105d9d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105da1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105da4:	89 d8                	mov    %ebx,%eax
80105da6:	5b                   	pop    %ebx
80105da7:	5e                   	pop    %esi
80105da8:	5f                   	pop    %edi
80105da9:	5d                   	pop    %ebp
80105daa:	c3                   	ret    
80105dab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105daf:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105db0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105db3:	85 c9                	test   %ecx,%ecx
80105db5:	0f 84 33 ff ff ff    	je     80105cee <sys_open+0x6e>
80105dbb:	e9 5c ff ff ff       	jmp    80105d1c <sys_open+0x9c>

80105dc0 <sys_mkdir>:

int
sys_mkdir(void)
{
80105dc0:	55                   	push   %ebp
80105dc1:	89 e5                	mov    %esp,%ebp
80105dc3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105dc6:	e8 f5 cf ff ff       	call   80102dc0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105dcb:	83 ec 08             	sub    $0x8,%esp
80105dce:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105dd1:	50                   	push   %eax
80105dd2:	6a 00                	push   $0x0
80105dd4:	e8 97 f6 ff ff       	call   80105470 <argstr>
80105dd9:	83 c4 10             	add    $0x10,%esp
80105ddc:	85 c0                	test   %eax,%eax
80105dde:	78 30                	js     80105e10 <sys_mkdir+0x50>
80105de0:	83 ec 0c             	sub    $0xc,%esp
80105de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105de6:	31 c9                	xor    %ecx,%ecx
80105de8:	ba 01 00 00 00       	mov    $0x1,%edx
80105ded:	6a 00                	push   $0x0
80105def:	e8 6c f7 ff ff       	call   80105560 <create>
80105df4:	83 c4 10             	add    $0x10,%esp
80105df7:	85 c0                	test   %eax,%eax
80105df9:	74 15                	je     80105e10 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105dfb:	83 ec 0c             	sub    $0xc,%esp
80105dfe:	50                   	push   %eax
80105dff:	e8 6c bc ff ff       	call   80101a70 <iunlockput>
  end_op();
80105e04:	e8 27 d0 ff ff       	call   80102e30 <end_op>
  return 0;
80105e09:	83 c4 10             	add    $0x10,%esp
80105e0c:	31 c0                	xor    %eax,%eax
}
80105e0e:	c9                   	leave  
80105e0f:	c3                   	ret    
    end_op();
80105e10:	e8 1b d0 ff ff       	call   80102e30 <end_op>
    return -1;
80105e15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e1a:	c9                   	leave  
80105e1b:	c3                   	ret    
80105e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e20 <sys_mknod>:

int
sys_mknod(void)
{
80105e20:	55                   	push   %ebp
80105e21:	89 e5                	mov    %esp,%ebp
80105e23:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105e26:	e8 95 cf ff ff       	call   80102dc0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105e2b:	83 ec 08             	sub    $0x8,%esp
80105e2e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105e31:	50                   	push   %eax
80105e32:	6a 00                	push   $0x0
80105e34:	e8 37 f6 ff ff       	call   80105470 <argstr>
80105e39:	83 c4 10             	add    $0x10,%esp
80105e3c:	85 c0                	test   %eax,%eax
80105e3e:	78 60                	js     80105ea0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105e40:	83 ec 08             	sub    $0x8,%esp
80105e43:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e46:	50                   	push   %eax
80105e47:	6a 01                	push   $0x1
80105e49:	e8 62 f5 ff ff       	call   801053b0 <argint>
  if((argstr(0, &path)) < 0 ||
80105e4e:	83 c4 10             	add    $0x10,%esp
80105e51:	85 c0                	test   %eax,%eax
80105e53:	78 4b                	js     80105ea0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105e55:	83 ec 08             	sub    $0x8,%esp
80105e58:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e5b:	50                   	push   %eax
80105e5c:	6a 02                	push   $0x2
80105e5e:	e8 4d f5 ff ff       	call   801053b0 <argint>
     argint(1, &major) < 0 ||
80105e63:	83 c4 10             	add    $0x10,%esp
80105e66:	85 c0                	test   %eax,%eax
80105e68:	78 36                	js     80105ea0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105e6a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105e6e:	83 ec 0c             	sub    $0xc,%esp
80105e71:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105e75:	ba 03 00 00 00       	mov    $0x3,%edx
80105e7a:	50                   	push   %eax
80105e7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105e7e:	e8 dd f6 ff ff       	call   80105560 <create>
     argint(2, &minor) < 0 ||
80105e83:	83 c4 10             	add    $0x10,%esp
80105e86:	85 c0                	test   %eax,%eax
80105e88:	74 16                	je     80105ea0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105e8a:	83 ec 0c             	sub    $0xc,%esp
80105e8d:	50                   	push   %eax
80105e8e:	e8 dd bb ff ff       	call   80101a70 <iunlockput>
  end_op();
80105e93:	e8 98 cf ff ff       	call   80102e30 <end_op>
  return 0;
80105e98:	83 c4 10             	add    $0x10,%esp
80105e9b:	31 c0                	xor    %eax,%eax
}
80105e9d:	c9                   	leave  
80105e9e:	c3                   	ret    
80105e9f:	90                   	nop
    end_op();
80105ea0:	e8 8b cf ff ff       	call   80102e30 <end_op>
    return -1;
80105ea5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105eaa:	c9                   	leave  
80105eab:	c3                   	ret    
80105eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105eb0 <sys_chdir>:

int
sys_chdir(void)
{
80105eb0:	55                   	push   %ebp
80105eb1:	89 e5                	mov    %esp,%ebp
80105eb3:	56                   	push   %esi
80105eb4:	53                   	push   %ebx
80105eb5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105eb8:	e8 a3 db ff ff       	call   80103a60 <myproc>
80105ebd:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105ebf:	e8 fc ce ff ff       	call   80102dc0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105ec4:	83 ec 08             	sub    $0x8,%esp
80105ec7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105eca:	50                   	push   %eax
80105ecb:	6a 00                	push   $0x0
80105ecd:	e8 9e f5 ff ff       	call   80105470 <argstr>
80105ed2:	83 c4 10             	add    $0x10,%esp
80105ed5:	85 c0                	test   %eax,%eax
80105ed7:	78 77                	js     80105f50 <sys_chdir+0xa0>
80105ed9:	83 ec 0c             	sub    $0xc,%esp
80105edc:	ff 75 f4             	push   -0xc(%ebp)
80105edf:	e8 1c c2 ff ff       	call   80102100 <namei>
80105ee4:	83 c4 10             	add    $0x10,%esp
80105ee7:	89 c3                	mov    %eax,%ebx
80105ee9:	85 c0                	test   %eax,%eax
80105eeb:	74 63                	je     80105f50 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105eed:	83 ec 0c             	sub    $0xc,%esp
80105ef0:	50                   	push   %eax
80105ef1:	e8 ea b8 ff ff       	call   801017e0 <ilock>
  if(ip->type != T_DIR){
80105ef6:	83 c4 10             	add    $0x10,%esp
80105ef9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105efe:	75 30                	jne    80105f30 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105f00:	83 ec 0c             	sub    $0xc,%esp
80105f03:	53                   	push   %ebx
80105f04:	e8 b7 b9 ff ff       	call   801018c0 <iunlock>
  iput(curproc->cwd);
80105f09:	58                   	pop    %eax
80105f0a:	ff 76 68             	push   0x68(%esi)
80105f0d:	e8 fe b9 ff ff       	call   80101910 <iput>
  end_op();
80105f12:	e8 19 cf ff ff       	call   80102e30 <end_op>
  curproc->cwd = ip;
80105f17:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105f1a:	83 c4 10             	add    $0x10,%esp
80105f1d:	31 c0                	xor    %eax,%eax
}
80105f1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105f22:	5b                   	pop    %ebx
80105f23:	5e                   	pop    %esi
80105f24:	5d                   	pop    %ebp
80105f25:	c3                   	ret    
80105f26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f2d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105f30:	83 ec 0c             	sub    $0xc,%esp
80105f33:	53                   	push   %ebx
80105f34:	e8 37 bb ff ff       	call   80101a70 <iunlockput>
    end_op();
80105f39:	e8 f2 ce ff ff       	call   80102e30 <end_op>
    return -1;
80105f3e:	83 c4 10             	add    $0x10,%esp
80105f41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f46:	eb d7                	jmp    80105f1f <sys_chdir+0x6f>
80105f48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f4f:	90                   	nop
    end_op();
80105f50:	e8 db ce ff ff       	call   80102e30 <end_op>
    return -1;
80105f55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f5a:	eb c3                	jmp    80105f1f <sys_chdir+0x6f>
80105f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f60 <sys_exec>:

int
sys_exec(void)
{
80105f60:	55                   	push   %ebp
80105f61:	89 e5                	mov    %esp,%ebp
80105f63:	57                   	push   %edi
80105f64:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105f65:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105f6b:	53                   	push   %ebx
80105f6c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105f72:	50                   	push   %eax
80105f73:	6a 00                	push   $0x0
80105f75:	e8 f6 f4 ff ff       	call   80105470 <argstr>
80105f7a:	83 c4 10             	add    $0x10,%esp
80105f7d:	85 c0                	test   %eax,%eax
80105f7f:	0f 88 87 00 00 00    	js     8010600c <sys_exec+0xac>
80105f85:	83 ec 08             	sub    $0x8,%esp
80105f88:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105f8e:	50                   	push   %eax
80105f8f:	6a 01                	push   $0x1
80105f91:	e8 1a f4 ff ff       	call   801053b0 <argint>
80105f96:	83 c4 10             	add    $0x10,%esp
80105f99:	85 c0                	test   %eax,%eax
80105f9b:	78 6f                	js     8010600c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105f9d:	83 ec 04             	sub    $0x4,%esp
80105fa0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105fa6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105fa8:	68 80 00 00 00       	push   $0x80
80105fad:	6a 00                	push   $0x0
80105faf:	56                   	push   %esi
80105fb0:	e8 3b f1 ff ff       	call   801050f0 <memset>
80105fb5:	83 c4 10             	add    $0x10,%esp
80105fb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fbf:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105fc0:	83 ec 08             	sub    $0x8,%esp
80105fc3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105fc9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105fd0:	50                   	push   %eax
80105fd1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105fd7:	01 f8                	add    %edi,%eax
80105fd9:	50                   	push   %eax
80105fda:	e8 41 f3 ff ff       	call   80105320 <fetchint>
80105fdf:	83 c4 10             	add    $0x10,%esp
80105fe2:	85 c0                	test   %eax,%eax
80105fe4:	78 26                	js     8010600c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105fe6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105fec:	85 c0                	test   %eax,%eax
80105fee:	74 30                	je     80106020 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105ff0:	83 ec 08             	sub    $0x8,%esp
80105ff3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105ff6:	52                   	push   %edx
80105ff7:	50                   	push   %eax
80105ff8:	e8 63 f3 ff ff       	call   80105360 <fetchstr>
80105ffd:	83 c4 10             	add    $0x10,%esp
80106000:	85 c0                	test   %eax,%eax
80106002:	78 08                	js     8010600c <sys_exec+0xac>
  for(i=0;; i++){
80106004:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80106007:	83 fb 20             	cmp    $0x20,%ebx
8010600a:	75 b4                	jne    80105fc0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010600c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010600f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106014:	5b                   	pop    %ebx
80106015:	5e                   	pop    %esi
80106016:	5f                   	pop    %edi
80106017:	5d                   	pop    %ebp
80106018:	c3                   	ret    
80106019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80106020:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106027:	00 00 00 00 
  return exec(path, argv);
8010602b:	83 ec 08             	sub    $0x8,%esp
8010602e:	56                   	push   %esi
8010602f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80106035:	e8 76 aa ff ff       	call   80100ab0 <exec>
8010603a:	83 c4 10             	add    $0x10,%esp
}
8010603d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106040:	5b                   	pop    %ebx
80106041:	5e                   	pop    %esi
80106042:	5f                   	pop    %edi
80106043:	5d                   	pop    %ebp
80106044:	c3                   	ret    
80106045:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010604c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106050 <sys_pipe>:

int
sys_pipe(void)
{
80106050:	55                   	push   %ebp
80106051:	89 e5                	mov    %esp,%ebp
80106053:	57                   	push   %edi
80106054:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106055:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80106058:	53                   	push   %ebx
80106059:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010605c:	6a 08                	push   $0x8
8010605e:	50                   	push   %eax
8010605f:	6a 00                	push   $0x0
80106061:	e8 9a f3 ff ff       	call   80105400 <argptr>
80106066:	83 c4 10             	add    $0x10,%esp
80106069:	85 c0                	test   %eax,%eax
8010606b:	78 4a                	js     801060b7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010606d:	83 ec 08             	sub    $0x8,%esp
80106070:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106073:	50                   	push   %eax
80106074:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106077:	50                   	push   %eax
80106078:	e8 13 d4 ff ff       	call   80103490 <pipealloc>
8010607d:	83 c4 10             	add    $0x10,%esp
80106080:	85 c0                	test   %eax,%eax
80106082:	78 33                	js     801060b7 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106084:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80106087:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80106089:	e8 d2 d9 ff ff       	call   80103a60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010608e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80106090:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80106094:	85 f6                	test   %esi,%esi
80106096:	74 28                	je     801060c0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80106098:	83 c3 01             	add    $0x1,%ebx
8010609b:	83 fb 10             	cmp    $0x10,%ebx
8010609e:	75 f0                	jne    80106090 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801060a0:	83 ec 0c             	sub    $0xc,%esp
801060a3:	ff 75 e0             	push   -0x20(%ebp)
801060a6:	e8 a5 ae ff ff       	call   80100f50 <fileclose>
    fileclose(wf);
801060ab:	58                   	pop    %eax
801060ac:	ff 75 e4             	push   -0x1c(%ebp)
801060af:	e8 9c ae ff ff       	call   80100f50 <fileclose>
    return -1;
801060b4:	83 c4 10             	add    $0x10,%esp
801060b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060bc:	eb 53                	jmp    80106111 <sys_pipe+0xc1>
801060be:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801060c0:	8d 73 08             	lea    0x8(%ebx),%esi
801060c3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801060c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801060ca:	e8 91 d9 ff ff       	call   80103a60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801060cf:	31 d2                	xor    %edx,%edx
801060d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801060d8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801060dc:	85 c9                	test   %ecx,%ecx
801060de:	74 20                	je     80106100 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
801060e0:	83 c2 01             	add    $0x1,%edx
801060e3:	83 fa 10             	cmp    $0x10,%edx
801060e6:	75 f0                	jne    801060d8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
801060e8:	e8 73 d9 ff ff       	call   80103a60 <myproc>
801060ed:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801060f4:	00 
801060f5:	eb a9                	jmp    801060a0 <sys_pipe+0x50>
801060f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060fe:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106100:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80106104:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106107:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106109:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010610c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010610f:	31 c0                	xor    %eax,%eax
}
80106111:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106114:	5b                   	pop    %ebx
80106115:	5e                   	pop    %esi
80106116:	5f                   	pop    %edi
80106117:	5d                   	pop    %ebp
80106118:	c3                   	ret    
80106119:	66 90                	xchg   %ax,%ax
8010611b:	66 90                	xchg   %ax,%ax
8010611d:	66 90                	xchg   %ax,%ax
8010611f:	90                   	nop

80106120 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80106120:	e9 0b db ff ff       	jmp    80103c30 <fork>
80106125:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010612c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106130 <sys_exit>:
}

int
sys_exit(void)
{
80106130:	55                   	push   %ebp
80106131:	89 e5                	mov    %esp,%ebp
80106133:	83 ec 08             	sub    $0x8,%esp
  exit();
80106136:	e8 95 df ff ff       	call   801040d0 <exit>
  return 0;  // not reached
}
8010613b:	31 c0                	xor    %eax,%eax
8010613d:	c9                   	leave  
8010613e:	c3                   	ret    
8010613f:	90                   	nop

80106140 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80106140:	e9 0b e1 ff ff       	jmp    80104250 <wait>
80106145:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010614c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106150 <sys_kill>:
}

int
sys_kill(void)
{
80106150:	55                   	push   %ebp
80106151:	89 e5                	mov    %esp,%ebp
80106153:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106156:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106159:	50                   	push   %eax
8010615a:	6a 00                	push   $0x0
8010615c:	e8 4f f2 ff ff       	call   801053b0 <argint>
80106161:	83 c4 10             	add    $0x10,%esp
80106164:	85 c0                	test   %eax,%eax
80106166:	78 18                	js     80106180 <sys_kill+0x30>
    return -1;
  return kill(pid);
80106168:	83 ec 0c             	sub    $0xc,%esp
8010616b:	ff 75 f4             	push   -0xc(%ebp)
8010616e:	e8 ed e3 ff ff       	call   80104560 <kill>
80106173:	83 c4 10             	add    $0x10,%esp
}
80106176:	c9                   	leave  
80106177:	c3                   	ret    
80106178:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010617f:	90                   	nop
80106180:	c9                   	leave  
    return -1;
80106181:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106186:	c3                   	ret    
80106187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010618e:	66 90                	xchg   %ax,%ax

80106190 <sys_getpid>:

int
sys_getpid(void)
{
80106190:	55                   	push   %ebp
80106191:	89 e5                	mov    %esp,%ebp
80106193:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106196:	e8 c5 d8 ff ff       	call   80103a60 <myproc>
8010619b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010619e:	c9                   	leave  
8010619f:	c3                   	ret    

801061a0 <sys_sbrk>:

int
sys_sbrk(void)
{
801061a0:	55                   	push   %ebp
801061a1:	89 e5                	mov    %esp,%ebp
801061a3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801061a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801061a7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801061aa:	50                   	push   %eax
801061ab:	6a 00                	push   $0x0
801061ad:	e8 fe f1 ff ff       	call   801053b0 <argint>
801061b2:	83 c4 10             	add    $0x10,%esp
801061b5:	85 c0                	test   %eax,%eax
801061b7:	78 27                	js     801061e0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801061b9:	e8 a2 d8 ff ff       	call   80103a60 <myproc>
  if(growproc(n) < 0)
801061be:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801061c1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801061c3:	ff 75 f4             	push   -0xc(%ebp)
801061c6:	e8 e5 d9 ff ff       	call   80103bb0 <growproc>
801061cb:	83 c4 10             	add    $0x10,%esp
801061ce:	85 c0                	test   %eax,%eax
801061d0:	78 0e                	js     801061e0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801061d2:	89 d8                	mov    %ebx,%eax
801061d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801061d7:	c9                   	leave  
801061d8:	c3                   	ret    
801061d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801061e0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801061e5:	eb eb                	jmp    801061d2 <sys_sbrk+0x32>
801061e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061ee:	66 90                	xchg   %ax,%ax

801061f0 <sys_sleep>:

int
sys_sleep(void)
{
801061f0:	55                   	push   %ebp
801061f1:	89 e5                	mov    %esp,%ebp
801061f3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801061f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801061f7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801061fa:	50                   	push   %eax
801061fb:	6a 00                	push   $0x0
801061fd:	e8 ae f1 ff ff       	call   801053b0 <argint>
80106202:	83 c4 10             	add    $0x10,%esp
80106205:	85 c0                	test   %eax,%eax
80106207:	0f 88 8a 00 00 00    	js     80106297 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010620d:	83 ec 0c             	sub    $0xc,%esp
80106210:	68 a0 51 11 80       	push   $0x801151a0
80106215:	e8 16 ee ff ff       	call   80105030 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010621a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
8010621d:	8b 1d 80 51 11 80    	mov    0x80115180,%ebx
  while(ticks - ticks0 < n){
80106223:	83 c4 10             	add    $0x10,%esp
80106226:	85 d2                	test   %edx,%edx
80106228:	75 27                	jne    80106251 <sys_sleep+0x61>
8010622a:	eb 54                	jmp    80106280 <sys_sleep+0x90>
8010622c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106230:	83 ec 08             	sub    $0x8,%esp
80106233:	68 a0 51 11 80       	push   $0x801151a0
80106238:	68 80 51 11 80       	push   $0x80115180
8010623d:	e8 ce e1 ff ff       	call   80104410 <sleep>
  while(ticks - ticks0 < n){
80106242:	a1 80 51 11 80       	mov    0x80115180,%eax
80106247:	83 c4 10             	add    $0x10,%esp
8010624a:	29 d8                	sub    %ebx,%eax
8010624c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010624f:	73 2f                	jae    80106280 <sys_sleep+0x90>
    if(myproc()->killed){
80106251:	e8 0a d8 ff ff       	call   80103a60 <myproc>
80106256:	8b 40 24             	mov    0x24(%eax),%eax
80106259:	85 c0                	test   %eax,%eax
8010625b:	74 d3                	je     80106230 <sys_sleep+0x40>
      release(&tickslock);
8010625d:	83 ec 0c             	sub    $0xc,%esp
80106260:	68 a0 51 11 80       	push   $0x801151a0
80106265:	e8 66 ed ff ff       	call   80104fd0 <release>
  }
  release(&tickslock);
  return 0;
}
8010626a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010626d:	83 c4 10             	add    $0x10,%esp
80106270:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106275:	c9                   	leave  
80106276:	c3                   	ret    
80106277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010627e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106280:	83 ec 0c             	sub    $0xc,%esp
80106283:	68 a0 51 11 80       	push   $0x801151a0
80106288:	e8 43 ed ff ff       	call   80104fd0 <release>
  return 0;
8010628d:	83 c4 10             	add    $0x10,%esp
80106290:	31 c0                	xor    %eax,%eax
}
80106292:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106295:	c9                   	leave  
80106296:	c3                   	ret    
    return -1;
80106297:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010629c:	eb f4                	jmp    80106292 <sys_sleep+0xa2>
8010629e:	66 90                	xchg   %ax,%ax

801062a0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801062a0:	55                   	push   %ebp
801062a1:	89 e5                	mov    %esp,%ebp
801062a3:	53                   	push   %ebx
801062a4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801062a7:	68 a0 51 11 80       	push   $0x801151a0
801062ac:	e8 7f ed ff ff       	call   80105030 <acquire>
  xticks = ticks;
801062b1:	8b 1d 80 51 11 80    	mov    0x80115180,%ebx
  release(&tickslock);
801062b7:	c7 04 24 a0 51 11 80 	movl   $0x801151a0,(%esp)
801062be:	e8 0d ed ff ff       	call   80104fd0 <release>
  return xticks;
}
801062c3:	89 d8                	mov    %ebx,%eax
801062c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801062c8:	c9                   	leave  
801062c9:	c3                   	ret    
801062ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801062d0 <sys_printprocinfo>:


extern void printprocinfo(void);

int sys_printprocinfo(void){
801062d0:	55                   	push   %ebp
801062d1:	89 e5                	mov    %esp,%ebp
801062d3:	83 ec 08             	sub    $0x8,%esp
  printprocinfo();
801062d6:	e8 15 e6 ff ff       	call   801048f0 <printprocinfo>
  return 0;
}
801062db:	31 c0                	xor    %eax,%eax
801062dd:	c9                   	leave  
801062de:	c3                   	ret    

801062df <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801062df:	1e                   	push   %ds
  pushl %es
801062e0:	06                   	push   %es
  pushl %fs
801062e1:	0f a0                	push   %fs
  pushl %gs
801062e3:	0f a8                	push   %gs
  pushal
801062e5:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801062e6:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801062ea:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801062ec:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801062ee:	54                   	push   %esp
  call trap
801062ef:	e8 cc 00 00 00       	call   801063c0 <trap>
  addl $4, %esp
801062f4:	83 c4 04             	add    $0x4,%esp

801062f7 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801062f7:	61                   	popa   
  popl %gs
801062f8:	0f a9                	pop    %gs
  popl %fs
801062fa:	0f a1                	pop    %fs
  popl %es
801062fc:	07                   	pop    %es
  popl %ds
801062fd:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801062fe:	83 c4 08             	add    $0x8,%esp
  iret
80106301:	cf                   	iret   
80106302:	66 90                	xchg   %ax,%ax
80106304:	66 90                	xchg   %ax,%ax
80106306:	66 90                	xchg   %ax,%ax
80106308:	66 90                	xchg   %ax,%ax
8010630a:	66 90                	xchg   %ax,%ax
8010630c:	66 90                	xchg   %ax,%ax
8010630e:	66 90                	xchg   %ax,%ax

80106310 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106310:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106311:	31 c0                	xor    %eax,%eax
{
80106313:	89 e5                	mov    %esp,%ebp
80106315:	83 ec 08             	sub    $0x8,%esp
80106318:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010631f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106320:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106327:	c7 04 c5 e2 51 11 80 	movl   $0x8e000008,-0x7feeae1e(,%eax,8)
8010632e:	08 00 00 8e 
80106332:	66 89 14 c5 e0 51 11 	mov    %dx,-0x7feeae20(,%eax,8)
80106339:	80 
8010633a:	c1 ea 10             	shr    $0x10,%edx
8010633d:	66 89 14 c5 e6 51 11 	mov    %dx,-0x7feeae1a(,%eax,8)
80106344:	80 
  for(i = 0; i < 256; i++)
80106345:	83 c0 01             	add    $0x1,%eax
80106348:	3d 00 01 00 00       	cmp    $0x100,%eax
8010634d:	75 d1                	jne    80106320 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010634f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106352:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80106357:	c7 05 e2 53 11 80 08 	movl   $0xef000008,0x801153e2
8010635e:	00 00 ef 
  initlock(&tickslock, "time");
80106361:	68 72 82 10 80       	push   $0x80108272
80106366:	68 a0 51 11 80       	push   $0x801151a0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010636b:	66 a3 e0 53 11 80    	mov    %ax,0x801153e0
80106371:	c1 e8 10             	shr    $0x10,%eax
80106374:	66 a3 e6 53 11 80    	mov    %ax,0x801153e6
  initlock(&tickslock, "time");
8010637a:	e8 e1 ea ff ff       	call   80104e60 <initlock>
}
8010637f:	83 c4 10             	add    $0x10,%esp
80106382:	c9                   	leave  
80106383:	c3                   	ret    
80106384:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010638b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010638f:	90                   	nop

80106390 <idtinit>:

void
idtinit(void)
{
80106390:	55                   	push   %ebp
  pd[0] = size-1;
80106391:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106396:	89 e5                	mov    %esp,%ebp
80106398:	83 ec 10             	sub    $0x10,%esp
8010639b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010639f:	b8 e0 51 11 80       	mov    $0x801151e0,%eax
801063a4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801063a8:	c1 e8 10             	shr    $0x10,%eax
801063ab:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801063af:	8d 45 fa             	lea    -0x6(%ebp),%eax
801063b2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801063b5:	c9                   	leave  
801063b6:	c3                   	ret    
801063b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063be:	66 90                	xchg   %ax,%ax

801063c0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801063c0:	55                   	push   %ebp
801063c1:	89 e5                	mov    %esp,%ebp
801063c3:	57                   	push   %edi
801063c4:	56                   	push   %esi
801063c5:	53                   	push   %ebx
801063c6:	83 ec 1c             	sub    $0x1c,%esp
801063c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801063cc:	8b 43 30             	mov    0x30(%ebx),%eax
801063cf:	83 f8 40             	cmp    $0x40,%eax
801063d2:	0f 84 68 01 00 00    	je     80106540 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801063d8:	83 e8 20             	sub    $0x20,%eax
801063db:	83 f8 1f             	cmp    $0x1f,%eax
801063de:	0f 87 8c 00 00 00    	ja     80106470 <trap+0xb0>
801063e4:	ff 24 85 44 86 10 80 	jmp    *-0x7fef79bc(,%eax,4)
801063eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801063ef:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801063f0:	e8 ab be ff ff       	call   801022a0 <ideintr>
    lapiceoi();
801063f5:	e8 76 c5 ff ff       	call   80102970 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063fa:	e8 61 d6 ff ff       	call   80103a60 <myproc>
801063ff:	85 c0                	test   %eax,%eax
80106401:	74 1d                	je     80106420 <trap+0x60>
80106403:	e8 58 d6 ff ff       	call   80103a60 <myproc>
80106408:	8b 50 24             	mov    0x24(%eax),%edx
8010640b:	85 d2                	test   %edx,%edx
8010640d:	74 11                	je     80106420 <trap+0x60>
8010640f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106413:	83 e0 03             	and    $0x3,%eax
80106416:	66 83 f8 03          	cmp    $0x3,%ax
8010641a:	0f 84 e8 01 00 00    	je     80106608 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106420:	e8 3b d6 ff ff       	call   80103a60 <myproc>
80106425:	85 c0                	test   %eax,%eax
80106427:	74 0f                	je     80106438 <trap+0x78>
80106429:	e8 32 d6 ff ff       	call   80103a60 <myproc>
8010642e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106432:	0f 84 b8 00 00 00    	je     801064f0 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106438:	e8 23 d6 ff ff       	call   80103a60 <myproc>
8010643d:	85 c0                	test   %eax,%eax
8010643f:	74 1d                	je     8010645e <trap+0x9e>
80106441:	e8 1a d6 ff ff       	call   80103a60 <myproc>
80106446:	8b 40 24             	mov    0x24(%eax),%eax
80106449:	85 c0                	test   %eax,%eax
8010644b:	74 11                	je     8010645e <trap+0x9e>
8010644d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106451:	83 e0 03             	and    $0x3,%eax
80106454:	66 83 f8 03          	cmp    $0x3,%ax
80106458:	0f 84 0f 01 00 00    	je     8010656d <trap+0x1ad>
    exit();
}
8010645e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106461:	5b                   	pop    %ebx
80106462:	5e                   	pop    %esi
80106463:	5f                   	pop    %edi
80106464:	5d                   	pop    %ebp
80106465:	c3                   	ret    
80106466:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010646d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80106470:	e8 eb d5 ff ff       	call   80103a60 <myproc>
80106475:	8b 7b 38             	mov    0x38(%ebx),%edi
80106478:	85 c0                	test   %eax,%eax
8010647a:	0f 84 a2 01 00 00    	je     80106622 <trap+0x262>
80106480:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106484:	0f 84 98 01 00 00    	je     80106622 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010648a:	0f 20 d1             	mov    %cr2,%ecx
8010648d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106490:	e8 ab d5 ff ff       	call   80103a40 <cpuid>
80106495:	8b 73 30             	mov    0x30(%ebx),%esi
80106498:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010649b:	8b 43 34             	mov    0x34(%ebx),%eax
8010649e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
801064a1:	e8 ba d5 ff ff       	call   80103a60 <myproc>
801064a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801064a9:	e8 b2 d5 ff ff       	call   80103a60 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801064ae:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801064b1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801064b4:	51                   	push   %ecx
801064b5:	57                   	push   %edi
801064b6:	52                   	push   %edx
801064b7:	ff 75 e4             	push   -0x1c(%ebp)
801064ba:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801064bb:	8b 75 e0             	mov    -0x20(%ebp),%esi
801064be:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801064c1:	56                   	push   %esi
801064c2:	ff 70 10             	push   0x10(%eax)
801064c5:	68 00 86 10 80       	push   $0x80108600
801064ca:	e8 d1 a1 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
801064cf:	83 c4 20             	add    $0x20,%esp
801064d2:	e8 89 d5 ff ff       	call   80103a60 <myproc>
801064d7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801064de:	e8 7d d5 ff ff       	call   80103a60 <myproc>
801064e3:	85 c0                	test   %eax,%eax
801064e5:	0f 85 18 ff ff ff    	jne    80106403 <trap+0x43>
801064eb:	e9 30 ff ff ff       	jmp    80106420 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
801064f0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801064f4:	0f 85 3e ff ff ff    	jne    80106438 <trap+0x78>
    yield();
801064fa:	e8 81 de ff ff       	call   80104380 <yield>
801064ff:	e9 34 ff ff ff       	jmp    80106438 <trap+0x78>
80106504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106508:	8b 7b 38             	mov    0x38(%ebx),%edi
8010650b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
8010650f:	e8 2c d5 ff ff       	call   80103a40 <cpuid>
80106514:	57                   	push   %edi
80106515:	56                   	push   %esi
80106516:	50                   	push   %eax
80106517:	68 a8 85 10 80       	push   $0x801085a8
8010651c:	e8 7f a1 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80106521:	e8 4a c4 ff ff       	call   80102970 <lapiceoi>
    break;
80106526:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106529:	e8 32 d5 ff ff       	call   80103a60 <myproc>
8010652e:	85 c0                	test   %eax,%eax
80106530:	0f 85 cd fe ff ff    	jne    80106403 <trap+0x43>
80106536:	e9 e5 fe ff ff       	jmp    80106420 <trap+0x60>
8010653b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010653f:	90                   	nop
    if(myproc()->killed)
80106540:	e8 1b d5 ff ff       	call   80103a60 <myproc>
80106545:	8b 70 24             	mov    0x24(%eax),%esi
80106548:	85 f6                	test   %esi,%esi
8010654a:	0f 85 c8 00 00 00    	jne    80106618 <trap+0x258>
    myproc()->tf = tf;
80106550:	e8 0b d5 ff ff       	call   80103a60 <myproc>
80106555:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106558:	e8 93 ef ff ff       	call   801054f0 <syscall>
    if(myproc()->killed)
8010655d:	e8 fe d4 ff ff       	call   80103a60 <myproc>
80106562:	8b 48 24             	mov    0x24(%eax),%ecx
80106565:	85 c9                	test   %ecx,%ecx
80106567:	0f 84 f1 fe ff ff    	je     8010645e <trap+0x9e>
}
8010656d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106570:	5b                   	pop    %ebx
80106571:	5e                   	pop    %esi
80106572:	5f                   	pop    %edi
80106573:	5d                   	pop    %ebp
      exit();
80106574:	e9 57 db ff ff       	jmp    801040d0 <exit>
80106579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106580:	e8 3b 02 00 00       	call   801067c0 <uartintr>
    lapiceoi();
80106585:	e8 e6 c3 ff ff       	call   80102970 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010658a:	e8 d1 d4 ff ff       	call   80103a60 <myproc>
8010658f:	85 c0                	test   %eax,%eax
80106591:	0f 85 6c fe ff ff    	jne    80106403 <trap+0x43>
80106597:	e9 84 fe ff ff       	jmp    80106420 <trap+0x60>
8010659c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
801065a0:	e8 8b c2 ff ff       	call   80102830 <kbdintr>
    lapiceoi();
801065a5:	e8 c6 c3 ff ff       	call   80102970 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801065aa:	e8 b1 d4 ff ff       	call   80103a60 <myproc>
801065af:	85 c0                	test   %eax,%eax
801065b1:	0f 85 4c fe ff ff    	jne    80106403 <trap+0x43>
801065b7:	e9 64 fe ff ff       	jmp    80106420 <trap+0x60>
801065bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
801065c0:	e8 7b d4 ff ff       	call   80103a40 <cpuid>
801065c5:	85 c0                	test   %eax,%eax
801065c7:	0f 85 28 fe ff ff    	jne    801063f5 <trap+0x35>
      acquire(&tickslock);
801065cd:	83 ec 0c             	sub    $0xc,%esp
801065d0:	68 a0 51 11 80       	push   $0x801151a0
801065d5:	e8 56 ea ff ff       	call   80105030 <acquire>
      wakeup(&ticks);
801065da:	c7 04 24 80 51 11 80 	movl   $0x80115180,(%esp)
      ticks++;
801065e1:	83 05 80 51 11 80 01 	addl   $0x1,0x80115180
      wakeup(&ticks);
801065e8:	e8 e3 de ff ff       	call   801044d0 <wakeup>
      release(&tickslock);
801065ed:	c7 04 24 a0 51 11 80 	movl   $0x801151a0,(%esp)
801065f4:	e8 d7 e9 ff ff       	call   80104fd0 <release>
801065f9:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801065fc:	e9 f4 fd ff ff       	jmp    801063f5 <trap+0x35>
80106601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80106608:	e8 c3 da ff ff       	call   801040d0 <exit>
8010660d:	e9 0e fe ff ff       	jmp    80106420 <trap+0x60>
80106612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106618:	e8 b3 da ff ff       	call   801040d0 <exit>
8010661d:	e9 2e ff ff ff       	jmp    80106550 <trap+0x190>
80106622:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106625:	e8 16 d4 ff ff       	call   80103a40 <cpuid>
8010662a:	83 ec 0c             	sub    $0xc,%esp
8010662d:	56                   	push   %esi
8010662e:	57                   	push   %edi
8010662f:	50                   	push   %eax
80106630:	ff 73 30             	push   0x30(%ebx)
80106633:	68 cc 85 10 80       	push   $0x801085cc
80106638:	e8 63 a0 ff ff       	call   801006a0 <cprintf>
      panic("trap");
8010663d:	83 c4 14             	add    $0x14,%esp
80106640:	68 a1 85 10 80       	push   $0x801085a1
80106645:	e8 36 9d ff ff       	call   80100380 <panic>
8010664a:	66 90                	xchg   %ax,%ax
8010664c:	66 90                	xchg   %ax,%ax
8010664e:	66 90                	xchg   %ax,%ax

80106650 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106650:	a1 e0 59 11 80       	mov    0x801159e0,%eax
80106655:	85 c0                	test   %eax,%eax
80106657:	74 17                	je     80106670 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106659:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010665e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010665f:	a8 01                	test   $0x1,%al
80106661:	74 0d                	je     80106670 <uartgetc+0x20>
80106663:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106668:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106669:	0f b6 c0             	movzbl %al,%eax
8010666c:	c3                   	ret    
8010666d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106670:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106675:	c3                   	ret    
80106676:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010667d:	8d 76 00             	lea    0x0(%esi),%esi

80106680 <uartinit>:
{
80106680:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106681:	31 c9                	xor    %ecx,%ecx
80106683:	89 c8                	mov    %ecx,%eax
80106685:	89 e5                	mov    %esp,%ebp
80106687:	57                   	push   %edi
80106688:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010668d:	56                   	push   %esi
8010668e:	89 fa                	mov    %edi,%edx
80106690:	53                   	push   %ebx
80106691:	83 ec 1c             	sub    $0x1c,%esp
80106694:	ee                   	out    %al,(%dx)
80106695:	be fb 03 00 00       	mov    $0x3fb,%esi
8010669a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010669f:	89 f2                	mov    %esi,%edx
801066a1:	ee                   	out    %al,(%dx)
801066a2:	b8 0c 00 00 00       	mov    $0xc,%eax
801066a7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801066ac:	ee                   	out    %al,(%dx)
801066ad:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801066b2:	89 c8                	mov    %ecx,%eax
801066b4:	89 da                	mov    %ebx,%edx
801066b6:	ee                   	out    %al,(%dx)
801066b7:	b8 03 00 00 00       	mov    $0x3,%eax
801066bc:	89 f2                	mov    %esi,%edx
801066be:	ee                   	out    %al,(%dx)
801066bf:	ba fc 03 00 00       	mov    $0x3fc,%edx
801066c4:	89 c8                	mov    %ecx,%eax
801066c6:	ee                   	out    %al,(%dx)
801066c7:	b8 01 00 00 00       	mov    $0x1,%eax
801066cc:	89 da                	mov    %ebx,%edx
801066ce:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801066cf:	ba fd 03 00 00       	mov    $0x3fd,%edx
801066d4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801066d5:	3c ff                	cmp    $0xff,%al
801066d7:	74 78                	je     80106751 <uartinit+0xd1>
  uart = 1;
801066d9:	c7 05 e0 59 11 80 01 	movl   $0x1,0x801159e0
801066e0:	00 00 00 
801066e3:	89 fa                	mov    %edi,%edx
801066e5:	ec                   	in     (%dx),%al
801066e6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801066eb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801066ec:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801066ef:	bf c4 86 10 80       	mov    $0x801086c4,%edi
801066f4:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
801066f9:	6a 00                	push   $0x0
801066fb:	6a 04                	push   $0x4
801066fd:	e8 de bd ff ff       	call   801024e0 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106702:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106706:	83 c4 10             	add    $0x10,%esp
80106709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106710:	a1 e0 59 11 80       	mov    0x801159e0,%eax
80106715:	bb 80 00 00 00       	mov    $0x80,%ebx
8010671a:	85 c0                	test   %eax,%eax
8010671c:	75 14                	jne    80106732 <uartinit+0xb2>
8010671e:	eb 23                	jmp    80106743 <uartinit+0xc3>
    microdelay(10);
80106720:	83 ec 0c             	sub    $0xc,%esp
80106723:	6a 0a                	push   $0xa
80106725:	e8 66 c2 ff ff       	call   80102990 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010672a:	83 c4 10             	add    $0x10,%esp
8010672d:	83 eb 01             	sub    $0x1,%ebx
80106730:	74 07                	je     80106739 <uartinit+0xb9>
80106732:	89 f2                	mov    %esi,%edx
80106734:	ec                   	in     (%dx),%al
80106735:	a8 20                	test   $0x20,%al
80106737:	74 e7                	je     80106720 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106739:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010673d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106742:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106743:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106747:	83 c7 01             	add    $0x1,%edi
8010674a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010674d:	84 c0                	test   %al,%al
8010674f:	75 bf                	jne    80106710 <uartinit+0x90>
}
80106751:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106754:	5b                   	pop    %ebx
80106755:	5e                   	pop    %esi
80106756:	5f                   	pop    %edi
80106757:	5d                   	pop    %ebp
80106758:	c3                   	ret    
80106759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106760 <uartputc>:
  if(!uart)
80106760:	a1 e0 59 11 80       	mov    0x801159e0,%eax
80106765:	85 c0                	test   %eax,%eax
80106767:	74 47                	je     801067b0 <uartputc+0x50>
{
80106769:	55                   	push   %ebp
8010676a:	89 e5                	mov    %esp,%ebp
8010676c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010676d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106772:	53                   	push   %ebx
80106773:	bb 80 00 00 00       	mov    $0x80,%ebx
80106778:	eb 18                	jmp    80106792 <uartputc+0x32>
8010677a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106780:	83 ec 0c             	sub    $0xc,%esp
80106783:	6a 0a                	push   $0xa
80106785:	e8 06 c2 ff ff       	call   80102990 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010678a:	83 c4 10             	add    $0x10,%esp
8010678d:	83 eb 01             	sub    $0x1,%ebx
80106790:	74 07                	je     80106799 <uartputc+0x39>
80106792:	89 f2                	mov    %esi,%edx
80106794:	ec                   	in     (%dx),%al
80106795:	a8 20                	test   $0x20,%al
80106797:	74 e7                	je     80106780 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106799:	8b 45 08             	mov    0x8(%ebp),%eax
8010679c:	ba f8 03 00 00       	mov    $0x3f8,%edx
801067a1:	ee                   	out    %al,(%dx)
}
801067a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801067a5:	5b                   	pop    %ebx
801067a6:	5e                   	pop    %esi
801067a7:	5d                   	pop    %ebp
801067a8:	c3                   	ret    
801067a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067b0:	c3                   	ret    
801067b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067bf:	90                   	nop

801067c0 <uartintr>:

void
uartintr(void)
{
801067c0:	55                   	push   %ebp
801067c1:	89 e5                	mov    %esp,%ebp
801067c3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801067c6:	68 50 66 10 80       	push   $0x80106650
801067cb:	e8 b0 a0 ff ff       	call   80100880 <consoleintr>
}
801067d0:	83 c4 10             	add    $0x10,%esp
801067d3:	c9                   	leave  
801067d4:	c3                   	ret    

801067d5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801067d5:	6a 00                	push   $0x0
  pushl $0
801067d7:	6a 00                	push   $0x0
  jmp alltraps
801067d9:	e9 01 fb ff ff       	jmp    801062df <alltraps>

801067de <vector1>:
.globl vector1
vector1:
  pushl $0
801067de:	6a 00                	push   $0x0
  pushl $1
801067e0:	6a 01                	push   $0x1
  jmp alltraps
801067e2:	e9 f8 fa ff ff       	jmp    801062df <alltraps>

801067e7 <vector2>:
.globl vector2
vector2:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $2
801067e9:	6a 02                	push   $0x2
  jmp alltraps
801067eb:	e9 ef fa ff ff       	jmp    801062df <alltraps>

801067f0 <vector3>:
.globl vector3
vector3:
  pushl $0
801067f0:	6a 00                	push   $0x0
  pushl $3
801067f2:	6a 03                	push   $0x3
  jmp alltraps
801067f4:	e9 e6 fa ff ff       	jmp    801062df <alltraps>

801067f9 <vector4>:
.globl vector4
vector4:
  pushl $0
801067f9:	6a 00                	push   $0x0
  pushl $4
801067fb:	6a 04                	push   $0x4
  jmp alltraps
801067fd:	e9 dd fa ff ff       	jmp    801062df <alltraps>

80106802 <vector5>:
.globl vector5
vector5:
  pushl $0
80106802:	6a 00                	push   $0x0
  pushl $5
80106804:	6a 05                	push   $0x5
  jmp alltraps
80106806:	e9 d4 fa ff ff       	jmp    801062df <alltraps>

8010680b <vector6>:
.globl vector6
vector6:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $6
8010680d:	6a 06                	push   $0x6
  jmp alltraps
8010680f:	e9 cb fa ff ff       	jmp    801062df <alltraps>

80106814 <vector7>:
.globl vector7
vector7:
  pushl $0
80106814:	6a 00                	push   $0x0
  pushl $7
80106816:	6a 07                	push   $0x7
  jmp alltraps
80106818:	e9 c2 fa ff ff       	jmp    801062df <alltraps>

8010681d <vector8>:
.globl vector8
vector8:
  pushl $8
8010681d:	6a 08                	push   $0x8
  jmp alltraps
8010681f:	e9 bb fa ff ff       	jmp    801062df <alltraps>

80106824 <vector9>:
.globl vector9
vector9:
  pushl $0
80106824:	6a 00                	push   $0x0
  pushl $9
80106826:	6a 09                	push   $0x9
  jmp alltraps
80106828:	e9 b2 fa ff ff       	jmp    801062df <alltraps>

8010682d <vector10>:
.globl vector10
vector10:
  pushl $10
8010682d:	6a 0a                	push   $0xa
  jmp alltraps
8010682f:	e9 ab fa ff ff       	jmp    801062df <alltraps>

80106834 <vector11>:
.globl vector11
vector11:
  pushl $11
80106834:	6a 0b                	push   $0xb
  jmp alltraps
80106836:	e9 a4 fa ff ff       	jmp    801062df <alltraps>

8010683b <vector12>:
.globl vector12
vector12:
  pushl $12
8010683b:	6a 0c                	push   $0xc
  jmp alltraps
8010683d:	e9 9d fa ff ff       	jmp    801062df <alltraps>

80106842 <vector13>:
.globl vector13
vector13:
  pushl $13
80106842:	6a 0d                	push   $0xd
  jmp alltraps
80106844:	e9 96 fa ff ff       	jmp    801062df <alltraps>

80106849 <vector14>:
.globl vector14
vector14:
  pushl $14
80106849:	6a 0e                	push   $0xe
  jmp alltraps
8010684b:	e9 8f fa ff ff       	jmp    801062df <alltraps>

80106850 <vector15>:
.globl vector15
vector15:
  pushl $0
80106850:	6a 00                	push   $0x0
  pushl $15
80106852:	6a 0f                	push   $0xf
  jmp alltraps
80106854:	e9 86 fa ff ff       	jmp    801062df <alltraps>

80106859 <vector16>:
.globl vector16
vector16:
  pushl $0
80106859:	6a 00                	push   $0x0
  pushl $16
8010685b:	6a 10                	push   $0x10
  jmp alltraps
8010685d:	e9 7d fa ff ff       	jmp    801062df <alltraps>

80106862 <vector17>:
.globl vector17
vector17:
  pushl $17
80106862:	6a 11                	push   $0x11
  jmp alltraps
80106864:	e9 76 fa ff ff       	jmp    801062df <alltraps>

80106869 <vector18>:
.globl vector18
vector18:
  pushl $0
80106869:	6a 00                	push   $0x0
  pushl $18
8010686b:	6a 12                	push   $0x12
  jmp alltraps
8010686d:	e9 6d fa ff ff       	jmp    801062df <alltraps>

80106872 <vector19>:
.globl vector19
vector19:
  pushl $0
80106872:	6a 00                	push   $0x0
  pushl $19
80106874:	6a 13                	push   $0x13
  jmp alltraps
80106876:	e9 64 fa ff ff       	jmp    801062df <alltraps>

8010687b <vector20>:
.globl vector20
vector20:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $20
8010687d:	6a 14                	push   $0x14
  jmp alltraps
8010687f:	e9 5b fa ff ff       	jmp    801062df <alltraps>

80106884 <vector21>:
.globl vector21
vector21:
  pushl $0
80106884:	6a 00                	push   $0x0
  pushl $21
80106886:	6a 15                	push   $0x15
  jmp alltraps
80106888:	e9 52 fa ff ff       	jmp    801062df <alltraps>

8010688d <vector22>:
.globl vector22
vector22:
  pushl $0
8010688d:	6a 00                	push   $0x0
  pushl $22
8010688f:	6a 16                	push   $0x16
  jmp alltraps
80106891:	e9 49 fa ff ff       	jmp    801062df <alltraps>

80106896 <vector23>:
.globl vector23
vector23:
  pushl $0
80106896:	6a 00                	push   $0x0
  pushl $23
80106898:	6a 17                	push   $0x17
  jmp alltraps
8010689a:	e9 40 fa ff ff       	jmp    801062df <alltraps>

8010689f <vector24>:
.globl vector24
vector24:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $24
801068a1:	6a 18                	push   $0x18
  jmp alltraps
801068a3:	e9 37 fa ff ff       	jmp    801062df <alltraps>

801068a8 <vector25>:
.globl vector25
vector25:
  pushl $0
801068a8:	6a 00                	push   $0x0
  pushl $25
801068aa:	6a 19                	push   $0x19
  jmp alltraps
801068ac:	e9 2e fa ff ff       	jmp    801062df <alltraps>

801068b1 <vector26>:
.globl vector26
vector26:
  pushl $0
801068b1:	6a 00                	push   $0x0
  pushl $26
801068b3:	6a 1a                	push   $0x1a
  jmp alltraps
801068b5:	e9 25 fa ff ff       	jmp    801062df <alltraps>

801068ba <vector27>:
.globl vector27
vector27:
  pushl $0
801068ba:	6a 00                	push   $0x0
  pushl $27
801068bc:	6a 1b                	push   $0x1b
  jmp alltraps
801068be:	e9 1c fa ff ff       	jmp    801062df <alltraps>

801068c3 <vector28>:
.globl vector28
vector28:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $28
801068c5:	6a 1c                	push   $0x1c
  jmp alltraps
801068c7:	e9 13 fa ff ff       	jmp    801062df <alltraps>

801068cc <vector29>:
.globl vector29
vector29:
  pushl $0
801068cc:	6a 00                	push   $0x0
  pushl $29
801068ce:	6a 1d                	push   $0x1d
  jmp alltraps
801068d0:	e9 0a fa ff ff       	jmp    801062df <alltraps>

801068d5 <vector30>:
.globl vector30
vector30:
  pushl $0
801068d5:	6a 00                	push   $0x0
  pushl $30
801068d7:	6a 1e                	push   $0x1e
  jmp alltraps
801068d9:	e9 01 fa ff ff       	jmp    801062df <alltraps>

801068de <vector31>:
.globl vector31
vector31:
  pushl $0
801068de:	6a 00                	push   $0x0
  pushl $31
801068e0:	6a 1f                	push   $0x1f
  jmp alltraps
801068e2:	e9 f8 f9 ff ff       	jmp    801062df <alltraps>

801068e7 <vector32>:
.globl vector32
vector32:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $32
801068e9:	6a 20                	push   $0x20
  jmp alltraps
801068eb:	e9 ef f9 ff ff       	jmp    801062df <alltraps>

801068f0 <vector33>:
.globl vector33
vector33:
  pushl $0
801068f0:	6a 00                	push   $0x0
  pushl $33
801068f2:	6a 21                	push   $0x21
  jmp alltraps
801068f4:	e9 e6 f9 ff ff       	jmp    801062df <alltraps>

801068f9 <vector34>:
.globl vector34
vector34:
  pushl $0
801068f9:	6a 00                	push   $0x0
  pushl $34
801068fb:	6a 22                	push   $0x22
  jmp alltraps
801068fd:	e9 dd f9 ff ff       	jmp    801062df <alltraps>

80106902 <vector35>:
.globl vector35
vector35:
  pushl $0
80106902:	6a 00                	push   $0x0
  pushl $35
80106904:	6a 23                	push   $0x23
  jmp alltraps
80106906:	e9 d4 f9 ff ff       	jmp    801062df <alltraps>

8010690b <vector36>:
.globl vector36
vector36:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $36
8010690d:	6a 24                	push   $0x24
  jmp alltraps
8010690f:	e9 cb f9 ff ff       	jmp    801062df <alltraps>

80106914 <vector37>:
.globl vector37
vector37:
  pushl $0
80106914:	6a 00                	push   $0x0
  pushl $37
80106916:	6a 25                	push   $0x25
  jmp alltraps
80106918:	e9 c2 f9 ff ff       	jmp    801062df <alltraps>

8010691d <vector38>:
.globl vector38
vector38:
  pushl $0
8010691d:	6a 00                	push   $0x0
  pushl $38
8010691f:	6a 26                	push   $0x26
  jmp alltraps
80106921:	e9 b9 f9 ff ff       	jmp    801062df <alltraps>

80106926 <vector39>:
.globl vector39
vector39:
  pushl $0
80106926:	6a 00                	push   $0x0
  pushl $39
80106928:	6a 27                	push   $0x27
  jmp alltraps
8010692a:	e9 b0 f9 ff ff       	jmp    801062df <alltraps>

8010692f <vector40>:
.globl vector40
vector40:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $40
80106931:	6a 28                	push   $0x28
  jmp alltraps
80106933:	e9 a7 f9 ff ff       	jmp    801062df <alltraps>

80106938 <vector41>:
.globl vector41
vector41:
  pushl $0
80106938:	6a 00                	push   $0x0
  pushl $41
8010693a:	6a 29                	push   $0x29
  jmp alltraps
8010693c:	e9 9e f9 ff ff       	jmp    801062df <alltraps>

80106941 <vector42>:
.globl vector42
vector42:
  pushl $0
80106941:	6a 00                	push   $0x0
  pushl $42
80106943:	6a 2a                	push   $0x2a
  jmp alltraps
80106945:	e9 95 f9 ff ff       	jmp    801062df <alltraps>

8010694a <vector43>:
.globl vector43
vector43:
  pushl $0
8010694a:	6a 00                	push   $0x0
  pushl $43
8010694c:	6a 2b                	push   $0x2b
  jmp alltraps
8010694e:	e9 8c f9 ff ff       	jmp    801062df <alltraps>

80106953 <vector44>:
.globl vector44
vector44:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $44
80106955:	6a 2c                	push   $0x2c
  jmp alltraps
80106957:	e9 83 f9 ff ff       	jmp    801062df <alltraps>

8010695c <vector45>:
.globl vector45
vector45:
  pushl $0
8010695c:	6a 00                	push   $0x0
  pushl $45
8010695e:	6a 2d                	push   $0x2d
  jmp alltraps
80106960:	e9 7a f9 ff ff       	jmp    801062df <alltraps>

80106965 <vector46>:
.globl vector46
vector46:
  pushl $0
80106965:	6a 00                	push   $0x0
  pushl $46
80106967:	6a 2e                	push   $0x2e
  jmp alltraps
80106969:	e9 71 f9 ff ff       	jmp    801062df <alltraps>

8010696e <vector47>:
.globl vector47
vector47:
  pushl $0
8010696e:	6a 00                	push   $0x0
  pushl $47
80106970:	6a 2f                	push   $0x2f
  jmp alltraps
80106972:	e9 68 f9 ff ff       	jmp    801062df <alltraps>

80106977 <vector48>:
.globl vector48
vector48:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $48
80106979:	6a 30                	push   $0x30
  jmp alltraps
8010697b:	e9 5f f9 ff ff       	jmp    801062df <alltraps>

80106980 <vector49>:
.globl vector49
vector49:
  pushl $0
80106980:	6a 00                	push   $0x0
  pushl $49
80106982:	6a 31                	push   $0x31
  jmp alltraps
80106984:	e9 56 f9 ff ff       	jmp    801062df <alltraps>

80106989 <vector50>:
.globl vector50
vector50:
  pushl $0
80106989:	6a 00                	push   $0x0
  pushl $50
8010698b:	6a 32                	push   $0x32
  jmp alltraps
8010698d:	e9 4d f9 ff ff       	jmp    801062df <alltraps>

80106992 <vector51>:
.globl vector51
vector51:
  pushl $0
80106992:	6a 00                	push   $0x0
  pushl $51
80106994:	6a 33                	push   $0x33
  jmp alltraps
80106996:	e9 44 f9 ff ff       	jmp    801062df <alltraps>

8010699b <vector52>:
.globl vector52
vector52:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $52
8010699d:	6a 34                	push   $0x34
  jmp alltraps
8010699f:	e9 3b f9 ff ff       	jmp    801062df <alltraps>

801069a4 <vector53>:
.globl vector53
vector53:
  pushl $0
801069a4:	6a 00                	push   $0x0
  pushl $53
801069a6:	6a 35                	push   $0x35
  jmp alltraps
801069a8:	e9 32 f9 ff ff       	jmp    801062df <alltraps>

801069ad <vector54>:
.globl vector54
vector54:
  pushl $0
801069ad:	6a 00                	push   $0x0
  pushl $54
801069af:	6a 36                	push   $0x36
  jmp alltraps
801069b1:	e9 29 f9 ff ff       	jmp    801062df <alltraps>

801069b6 <vector55>:
.globl vector55
vector55:
  pushl $0
801069b6:	6a 00                	push   $0x0
  pushl $55
801069b8:	6a 37                	push   $0x37
  jmp alltraps
801069ba:	e9 20 f9 ff ff       	jmp    801062df <alltraps>

801069bf <vector56>:
.globl vector56
vector56:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $56
801069c1:	6a 38                	push   $0x38
  jmp alltraps
801069c3:	e9 17 f9 ff ff       	jmp    801062df <alltraps>

801069c8 <vector57>:
.globl vector57
vector57:
  pushl $0
801069c8:	6a 00                	push   $0x0
  pushl $57
801069ca:	6a 39                	push   $0x39
  jmp alltraps
801069cc:	e9 0e f9 ff ff       	jmp    801062df <alltraps>

801069d1 <vector58>:
.globl vector58
vector58:
  pushl $0
801069d1:	6a 00                	push   $0x0
  pushl $58
801069d3:	6a 3a                	push   $0x3a
  jmp alltraps
801069d5:	e9 05 f9 ff ff       	jmp    801062df <alltraps>

801069da <vector59>:
.globl vector59
vector59:
  pushl $0
801069da:	6a 00                	push   $0x0
  pushl $59
801069dc:	6a 3b                	push   $0x3b
  jmp alltraps
801069de:	e9 fc f8 ff ff       	jmp    801062df <alltraps>

801069e3 <vector60>:
.globl vector60
vector60:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $60
801069e5:	6a 3c                	push   $0x3c
  jmp alltraps
801069e7:	e9 f3 f8 ff ff       	jmp    801062df <alltraps>

801069ec <vector61>:
.globl vector61
vector61:
  pushl $0
801069ec:	6a 00                	push   $0x0
  pushl $61
801069ee:	6a 3d                	push   $0x3d
  jmp alltraps
801069f0:	e9 ea f8 ff ff       	jmp    801062df <alltraps>

801069f5 <vector62>:
.globl vector62
vector62:
  pushl $0
801069f5:	6a 00                	push   $0x0
  pushl $62
801069f7:	6a 3e                	push   $0x3e
  jmp alltraps
801069f9:	e9 e1 f8 ff ff       	jmp    801062df <alltraps>

801069fe <vector63>:
.globl vector63
vector63:
  pushl $0
801069fe:	6a 00                	push   $0x0
  pushl $63
80106a00:	6a 3f                	push   $0x3f
  jmp alltraps
80106a02:	e9 d8 f8 ff ff       	jmp    801062df <alltraps>

80106a07 <vector64>:
.globl vector64
vector64:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $64
80106a09:	6a 40                	push   $0x40
  jmp alltraps
80106a0b:	e9 cf f8 ff ff       	jmp    801062df <alltraps>

80106a10 <vector65>:
.globl vector65
vector65:
  pushl $0
80106a10:	6a 00                	push   $0x0
  pushl $65
80106a12:	6a 41                	push   $0x41
  jmp alltraps
80106a14:	e9 c6 f8 ff ff       	jmp    801062df <alltraps>

80106a19 <vector66>:
.globl vector66
vector66:
  pushl $0
80106a19:	6a 00                	push   $0x0
  pushl $66
80106a1b:	6a 42                	push   $0x42
  jmp alltraps
80106a1d:	e9 bd f8 ff ff       	jmp    801062df <alltraps>

80106a22 <vector67>:
.globl vector67
vector67:
  pushl $0
80106a22:	6a 00                	push   $0x0
  pushl $67
80106a24:	6a 43                	push   $0x43
  jmp alltraps
80106a26:	e9 b4 f8 ff ff       	jmp    801062df <alltraps>

80106a2b <vector68>:
.globl vector68
vector68:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $68
80106a2d:	6a 44                	push   $0x44
  jmp alltraps
80106a2f:	e9 ab f8 ff ff       	jmp    801062df <alltraps>

80106a34 <vector69>:
.globl vector69
vector69:
  pushl $0
80106a34:	6a 00                	push   $0x0
  pushl $69
80106a36:	6a 45                	push   $0x45
  jmp alltraps
80106a38:	e9 a2 f8 ff ff       	jmp    801062df <alltraps>

80106a3d <vector70>:
.globl vector70
vector70:
  pushl $0
80106a3d:	6a 00                	push   $0x0
  pushl $70
80106a3f:	6a 46                	push   $0x46
  jmp alltraps
80106a41:	e9 99 f8 ff ff       	jmp    801062df <alltraps>

80106a46 <vector71>:
.globl vector71
vector71:
  pushl $0
80106a46:	6a 00                	push   $0x0
  pushl $71
80106a48:	6a 47                	push   $0x47
  jmp alltraps
80106a4a:	e9 90 f8 ff ff       	jmp    801062df <alltraps>

80106a4f <vector72>:
.globl vector72
vector72:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $72
80106a51:	6a 48                	push   $0x48
  jmp alltraps
80106a53:	e9 87 f8 ff ff       	jmp    801062df <alltraps>

80106a58 <vector73>:
.globl vector73
vector73:
  pushl $0
80106a58:	6a 00                	push   $0x0
  pushl $73
80106a5a:	6a 49                	push   $0x49
  jmp alltraps
80106a5c:	e9 7e f8 ff ff       	jmp    801062df <alltraps>

80106a61 <vector74>:
.globl vector74
vector74:
  pushl $0
80106a61:	6a 00                	push   $0x0
  pushl $74
80106a63:	6a 4a                	push   $0x4a
  jmp alltraps
80106a65:	e9 75 f8 ff ff       	jmp    801062df <alltraps>

80106a6a <vector75>:
.globl vector75
vector75:
  pushl $0
80106a6a:	6a 00                	push   $0x0
  pushl $75
80106a6c:	6a 4b                	push   $0x4b
  jmp alltraps
80106a6e:	e9 6c f8 ff ff       	jmp    801062df <alltraps>

80106a73 <vector76>:
.globl vector76
vector76:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $76
80106a75:	6a 4c                	push   $0x4c
  jmp alltraps
80106a77:	e9 63 f8 ff ff       	jmp    801062df <alltraps>

80106a7c <vector77>:
.globl vector77
vector77:
  pushl $0
80106a7c:	6a 00                	push   $0x0
  pushl $77
80106a7e:	6a 4d                	push   $0x4d
  jmp alltraps
80106a80:	e9 5a f8 ff ff       	jmp    801062df <alltraps>

80106a85 <vector78>:
.globl vector78
vector78:
  pushl $0
80106a85:	6a 00                	push   $0x0
  pushl $78
80106a87:	6a 4e                	push   $0x4e
  jmp alltraps
80106a89:	e9 51 f8 ff ff       	jmp    801062df <alltraps>

80106a8e <vector79>:
.globl vector79
vector79:
  pushl $0
80106a8e:	6a 00                	push   $0x0
  pushl $79
80106a90:	6a 4f                	push   $0x4f
  jmp alltraps
80106a92:	e9 48 f8 ff ff       	jmp    801062df <alltraps>

80106a97 <vector80>:
.globl vector80
vector80:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $80
80106a99:	6a 50                	push   $0x50
  jmp alltraps
80106a9b:	e9 3f f8 ff ff       	jmp    801062df <alltraps>

80106aa0 <vector81>:
.globl vector81
vector81:
  pushl $0
80106aa0:	6a 00                	push   $0x0
  pushl $81
80106aa2:	6a 51                	push   $0x51
  jmp alltraps
80106aa4:	e9 36 f8 ff ff       	jmp    801062df <alltraps>

80106aa9 <vector82>:
.globl vector82
vector82:
  pushl $0
80106aa9:	6a 00                	push   $0x0
  pushl $82
80106aab:	6a 52                	push   $0x52
  jmp alltraps
80106aad:	e9 2d f8 ff ff       	jmp    801062df <alltraps>

80106ab2 <vector83>:
.globl vector83
vector83:
  pushl $0
80106ab2:	6a 00                	push   $0x0
  pushl $83
80106ab4:	6a 53                	push   $0x53
  jmp alltraps
80106ab6:	e9 24 f8 ff ff       	jmp    801062df <alltraps>

80106abb <vector84>:
.globl vector84
vector84:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $84
80106abd:	6a 54                	push   $0x54
  jmp alltraps
80106abf:	e9 1b f8 ff ff       	jmp    801062df <alltraps>

80106ac4 <vector85>:
.globl vector85
vector85:
  pushl $0
80106ac4:	6a 00                	push   $0x0
  pushl $85
80106ac6:	6a 55                	push   $0x55
  jmp alltraps
80106ac8:	e9 12 f8 ff ff       	jmp    801062df <alltraps>

80106acd <vector86>:
.globl vector86
vector86:
  pushl $0
80106acd:	6a 00                	push   $0x0
  pushl $86
80106acf:	6a 56                	push   $0x56
  jmp alltraps
80106ad1:	e9 09 f8 ff ff       	jmp    801062df <alltraps>

80106ad6 <vector87>:
.globl vector87
vector87:
  pushl $0
80106ad6:	6a 00                	push   $0x0
  pushl $87
80106ad8:	6a 57                	push   $0x57
  jmp alltraps
80106ada:	e9 00 f8 ff ff       	jmp    801062df <alltraps>

80106adf <vector88>:
.globl vector88
vector88:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $88
80106ae1:	6a 58                	push   $0x58
  jmp alltraps
80106ae3:	e9 f7 f7 ff ff       	jmp    801062df <alltraps>

80106ae8 <vector89>:
.globl vector89
vector89:
  pushl $0
80106ae8:	6a 00                	push   $0x0
  pushl $89
80106aea:	6a 59                	push   $0x59
  jmp alltraps
80106aec:	e9 ee f7 ff ff       	jmp    801062df <alltraps>

80106af1 <vector90>:
.globl vector90
vector90:
  pushl $0
80106af1:	6a 00                	push   $0x0
  pushl $90
80106af3:	6a 5a                	push   $0x5a
  jmp alltraps
80106af5:	e9 e5 f7 ff ff       	jmp    801062df <alltraps>

80106afa <vector91>:
.globl vector91
vector91:
  pushl $0
80106afa:	6a 00                	push   $0x0
  pushl $91
80106afc:	6a 5b                	push   $0x5b
  jmp alltraps
80106afe:	e9 dc f7 ff ff       	jmp    801062df <alltraps>

80106b03 <vector92>:
.globl vector92
vector92:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $92
80106b05:	6a 5c                	push   $0x5c
  jmp alltraps
80106b07:	e9 d3 f7 ff ff       	jmp    801062df <alltraps>

80106b0c <vector93>:
.globl vector93
vector93:
  pushl $0
80106b0c:	6a 00                	push   $0x0
  pushl $93
80106b0e:	6a 5d                	push   $0x5d
  jmp alltraps
80106b10:	e9 ca f7 ff ff       	jmp    801062df <alltraps>

80106b15 <vector94>:
.globl vector94
vector94:
  pushl $0
80106b15:	6a 00                	push   $0x0
  pushl $94
80106b17:	6a 5e                	push   $0x5e
  jmp alltraps
80106b19:	e9 c1 f7 ff ff       	jmp    801062df <alltraps>

80106b1e <vector95>:
.globl vector95
vector95:
  pushl $0
80106b1e:	6a 00                	push   $0x0
  pushl $95
80106b20:	6a 5f                	push   $0x5f
  jmp alltraps
80106b22:	e9 b8 f7 ff ff       	jmp    801062df <alltraps>

80106b27 <vector96>:
.globl vector96
vector96:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $96
80106b29:	6a 60                	push   $0x60
  jmp alltraps
80106b2b:	e9 af f7 ff ff       	jmp    801062df <alltraps>

80106b30 <vector97>:
.globl vector97
vector97:
  pushl $0
80106b30:	6a 00                	push   $0x0
  pushl $97
80106b32:	6a 61                	push   $0x61
  jmp alltraps
80106b34:	e9 a6 f7 ff ff       	jmp    801062df <alltraps>

80106b39 <vector98>:
.globl vector98
vector98:
  pushl $0
80106b39:	6a 00                	push   $0x0
  pushl $98
80106b3b:	6a 62                	push   $0x62
  jmp alltraps
80106b3d:	e9 9d f7 ff ff       	jmp    801062df <alltraps>

80106b42 <vector99>:
.globl vector99
vector99:
  pushl $0
80106b42:	6a 00                	push   $0x0
  pushl $99
80106b44:	6a 63                	push   $0x63
  jmp alltraps
80106b46:	e9 94 f7 ff ff       	jmp    801062df <alltraps>

80106b4b <vector100>:
.globl vector100
vector100:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $100
80106b4d:	6a 64                	push   $0x64
  jmp alltraps
80106b4f:	e9 8b f7 ff ff       	jmp    801062df <alltraps>

80106b54 <vector101>:
.globl vector101
vector101:
  pushl $0
80106b54:	6a 00                	push   $0x0
  pushl $101
80106b56:	6a 65                	push   $0x65
  jmp alltraps
80106b58:	e9 82 f7 ff ff       	jmp    801062df <alltraps>

80106b5d <vector102>:
.globl vector102
vector102:
  pushl $0
80106b5d:	6a 00                	push   $0x0
  pushl $102
80106b5f:	6a 66                	push   $0x66
  jmp alltraps
80106b61:	e9 79 f7 ff ff       	jmp    801062df <alltraps>

80106b66 <vector103>:
.globl vector103
vector103:
  pushl $0
80106b66:	6a 00                	push   $0x0
  pushl $103
80106b68:	6a 67                	push   $0x67
  jmp alltraps
80106b6a:	e9 70 f7 ff ff       	jmp    801062df <alltraps>

80106b6f <vector104>:
.globl vector104
vector104:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $104
80106b71:	6a 68                	push   $0x68
  jmp alltraps
80106b73:	e9 67 f7 ff ff       	jmp    801062df <alltraps>

80106b78 <vector105>:
.globl vector105
vector105:
  pushl $0
80106b78:	6a 00                	push   $0x0
  pushl $105
80106b7a:	6a 69                	push   $0x69
  jmp alltraps
80106b7c:	e9 5e f7 ff ff       	jmp    801062df <alltraps>

80106b81 <vector106>:
.globl vector106
vector106:
  pushl $0
80106b81:	6a 00                	push   $0x0
  pushl $106
80106b83:	6a 6a                	push   $0x6a
  jmp alltraps
80106b85:	e9 55 f7 ff ff       	jmp    801062df <alltraps>

80106b8a <vector107>:
.globl vector107
vector107:
  pushl $0
80106b8a:	6a 00                	push   $0x0
  pushl $107
80106b8c:	6a 6b                	push   $0x6b
  jmp alltraps
80106b8e:	e9 4c f7 ff ff       	jmp    801062df <alltraps>

80106b93 <vector108>:
.globl vector108
vector108:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $108
80106b95:	6a 6c                	push   $0x6c
  jmp alltraps
80106b97:	e9 43 f7 ff ff       	jmp    801062df <alltraps>

80106b9c <vector109>:
.globl vector109
vector109:
  pushl $0
80106b9c:	6a 00                	push   $0x0
  pushl $109
80106b9e:	6a 6d                	push   $0x6d
  jmp alltraps
80106ba0:	e9 3a f7 ff ff       	jmp    801062df <alltraps>

80106ba5 <vector110>:
.globl vector110
vector110:
  pushl $0
80106ba5:	6a 00                	push   $0x0
  pushl $110
80106ba7:	6a 6e                	push   $0x6e
  jmp alltraps
80106ba9:	e9 31 f7 ff ff       	jmp    801062df <alltraps>

80106bae <vector111>:
.globl vector111
vector111:
  pushl $0
80106bae:	6a 00                	push   $0x0
  pushl $111
80106bb0:	6a 6f                	push   $0x6f
  jmp alltraps
80106bb2:	e9 28 f7 ff ff       	jmp    801062df <alltraps>

80106bb7 <vector112>:
.globl vector112
vector112:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $112
80106bb9:	6a 70                	push   $0x70
  jmp alltraps
80106bbb:	e9 1f f7 ff ff       	jmp    801062df <alltraps>

80106bc0 <vector113>:
.globl vector113
vector113:
  pushl $0
80106bc0:	6a 00                	push   $0x0
  pushl $113
80106bc2:	6a 71                	push   $0x71
  jmp alltraps
80106bc4:	e9 16 f7 ff ff       	jmp    801062df <alltraps>

80106bc9 <vector114>:
.globl vector114
vector114:
  pushl $0
80106bc9:	6a 00                	push   $0x0
  pushl $114
80106bcb:	6a 72                	push   $0x72
  jmp alltraps
80106bcd:	e9 0d f7 ff ff       	jmp    801062df <alltraps>

80106bd2 <vector115>:
.globl vector115
vector115:
  pushl $0
80106bd2:	6a 00                	push   $0x0
  pushl $115
80106bd4:	6a 73                	push   $0x73
  jmp alltraps
80106bd6:	e9 04 f7 ff ff       	jmp    801062df <alltraps>

80106bdb <vector116>:
.globl vector116
vector116:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $116
80106bdd:	6a 74                	push   $0x74
  jmp alltraps
80106bdf:	e9 fb f6 ff ff       	jmp    801062df <alltraps>

80106be4 <vector117>:
.globl vector117
vector117:
  pushl $0
80106be4:	6a 00                	push   $0x0
  pushl $117
80106be6:	6a 75                	push   $0x75
  jmp alltraps
80106be8:	e9 f2 f6 ff ff       	jmp    801062df <alltraps>

80106bed <vector118>:
.globl vector118
vector118:
  pushl $0
80106bed:	6a 00                	push   $0x0
  pushl $118
80106bef:	6a 76                	push   $0x76
  jmp alltraps
80106bf1:	e9 e9 f6 ff ff       	jmp    801062df <alltraps>

80106bf6 <vector119>:
.globl vector119
vector119:
  pushl $0
80106bf6:	6a 00                	push   $0x0
  pushl $119
80106bf8:	6a 77                	push   $0x77
  jmp alltraps
80106bfa:	e9 e0 f6 ff ff       	jmp    801062df <alltraps>

80106bff <vector120>:
.globl vector120
vector120:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $120
80106c01:	6a 78                	push   $0x78
  jmp alltraps
80106c03:	e9 d7 f6 ff ff       	jmp    801062df <alltraps>

80106c08 <vector121>:
.globl vector121
vector121:
  pushl $0
80106c08:	6a 00                	push   $0x0
  pushl $121
80106c0a:	6a 79                	push   $0x79
  jmp alltraps
80106c0c:	e9 ce f6 ff ff       	jmp    801062df <alltraps>

80106c11 <vector122>:
.globl vector122
vector122:
  pushl $0
80106c11:	6a 00                	push   $0x0
  pushl $122
80106c13:	6a 7a                	push   $0x7a
  jmp alltraps
80106c15:	e9 c5 f6 ff ff       	jmp    801062df <alltraps>

80106c1a <vector123>:
.globl vector123
vector123:
  pushl $0
80106c1a:	6a 00                	push   $0x0
  pushl $123
80106c1c:	6a 7b                	push   $0x7b
  jmp alltraps
80106c1e:	e9 bc f6 ff ff       	jmp    801062df <alltraps>

80106c23 <vector124>:
.globl vector124
vector124:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $124
80106c25:	6a 7c                	push   $0x7c
  jmp alltraps
80106c27:	e9 b3 f6 ff ff       	jmp    801062df <alltraps>

80106c2c <vector125>:
.globl vector125
vector125:
  pushl $0
80106c2c:	6a 00                	push   $0x0
  pushl $125
80106c2e:	6a 7d                	push   $0x7d
  jmp alltraps
80106c30:	e9 aa f6 ff ff       	jmp    801062df <alltraps>

80106c35 <vector126>:
.globl vector126
vector126:
  pushl $0
80106c35:	6a 00                	push   $0x0
  pushl $126
80106c37:	6a 7e                	push   $0x7e
  jmp alltraps
80106c39:	e9 a1 f6 ff ff       	jmp    801062df <alltraps>

80106c3e <vector127>:
.globl vector127
vector127:
  pushl $0
80106c3e:	6a 00                	push   $0x0
  pushl $127
80106c40:	6a 7f                	push   $0x7f
  jmp alltraps
80106c42:	e9 98 f6 ff ff       	jmp    801062df <alltraps>

80106c47 <vector128>:
.globl vector128
vector128:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $128
80106c49:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106c4e:	e9 8c f6 ff ff       	jmp    801062df <alltraps>

80106c53 <vector129>:
.globl vector129
vector129:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $129
80106c55:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106c5a:	e9 80 f6 ff ff       	jmp    801062df <alltraps>

80106c5f <vector130>:
.globl vector130
vector130:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $130
80106c61:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106c66:	e9 74 f6 ff ff       	jmp    801062df <alltraps>

80106c6b <vector131>:
.globl vector131
vector131:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $131
80106c6d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106c72:	e9 68 f6 ff ff       	jmp    801062df <alltraps>

80106c77 <vector132>:
.globl vector132
vector132:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $132
80106c79:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106c7e:	e9 5c f6 ff ff       	jmp    801062df <alltraps>

80106c83 <vector133>:
.globl vector133
vector133:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $133
80106c85:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106c8a:	e9 50 f6 ff ff       	jmp    801062df <alltraps>

80106c8f <vector134>:
.globl vector134
vector134:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $134
80106c91:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106c96:	e9 44 f6 ff ff       	jmp    801062df <alltraps>

80106c9b <vector135>:
.globl vector135
vector135:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $135
80106c9d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106ca2:	e9 38 f6 ff ff       	jmp    801062df <alltraps>

80106ca7 <vector136>:
.globl vector136
vector136:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $136
80106ca9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106cae:	e9 2c f6 ff ff       	jmp    801062df <alltraps>

80106cb3 <vector137>:
.globl vector137
vector137:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $137
80106cb5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106cba:	e9 20 f6 ff ff       	jmp    801062df <alltraps>

80106cbf <vector138>:
.globl vector138
vector138:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $138
80106cc1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106cc6:	e9 14 f6 ff ff       	jmp    801062df <alltraps>

80106ccb <vector139>:
.globl vector139
vector139:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $139
80106ccd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106cd2:	e9 08 f6 ff ff       	jmp    801062df <alltraps>

80106cd7 <vector140>:
.globl vector140
vector140:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $140
80106cd9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106cde:	e9 fc f5 ff ff       	jmp    801062df <alltraps>

80106ce3 <vector141>:
.globl vector141
vector141:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $141
80106ce5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106cea:	e9 f0 f5 ff ff       	jmp    801062df <alltraps>

80106cef <vector142>:
.globl vector142
vector142:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $142
80106cf1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106cf6:	e9 e4 f5 ff ff       	jmp    801062df <alltraps>

80106cfb <vector143>:
.globl vector143
vector143:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $143
80106cfd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106d02:	e9 d8 f5 ff ff       	jmp    801062df <alltraps>

80106d07 <vector144>:
.globl vector144
vector144:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $144
80106d09:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106d0e:	e9 cc f5 ff ff       	jmp    801062df <alltraps>

80106d13 <vector145>:
.globl vector145
vector145:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $145
80106d15:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106d1a:	e9 c0 f5 ff ff       	jmp    801062df <alltraps>

80106d1f <vector146>:
.globl vector146
vector146:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $146
80106d21:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106d26:	e9 b4 f5 ff ff       	jmp    801062df <alltraps>

80106d2b <vector147>:
.globl vector147
vector147:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $147
80106d2d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106d32:	e9 a8 f5 ff ff       	jmp    801062df <alltraps>

80106d37 <vector148>:
.globl vector148
vector148:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $148
80106d39:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106d3e:	e9 9c f5 ff ff       	jmp    801062df <alltraps>

80106d43 <vector149>:
.globl vector149
vector149:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $149
80106d45:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106d4a:	e9 90 f5 ff ff       	jmp    801062df <alltraps>

80106d4f <vector150>:
.globl vector150
vector150:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $150
80106d51:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106d56:	e9 84 f5 ff ff       	jmp    801062df <alltraps>

80106d5b <vector151>:
.globl vector151
vector151:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $151
80106d5d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106d62:	e9 78 f5 ff ff       	jmp    801062df <alltraps>

80106d67 <vector152>:
.globl vector152
vector152:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $152
80106d69:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106d6e:	e9 6c f5 ff ff       	jmp    801062df <alltraps>

80106d73 <vector153>:
.globl vector153
vector153:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $153
80106d75:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106d7a:	e9 60 f5 ff ff       	jmp    801062df <alltraps>

80106d7f <vector154>:
.globl vector154
vector154:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $154
80106d81:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106d86:	e9 54 f5 ff ff       	jmp    801062df <alltraps>

80106d8b <vector155>:
.globl vector155
vector155:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $155
80106d8d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106d92:	e9 48 f5 ff ff       	jmp    801062df <alltraps>

80106d97 <vector156>:
.globl vector156
vector156:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $156
80106d99:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106d9e:	e9 3c f5 ff ff       	jmp    801062df <alltraps>

80106da3 <vector157>:
.globl vector157
vector157:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $157
80106da5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106daa:	e9 30 f5 ff ff       	jmp    801062df <alltraps>

80106daf <vector158>:
.globl vector158
vector158:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $158
80106db1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106db6:	e9 24 f5 ff ff       	jmp    801062df <alltraps>

80106dbb <vector159>:
.globl vector159
vector159:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $159
80106dbd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106dc2:	e9 18 f5 ff ff       	jmp    801062df <alltraps>

80106dc7 <vector160>:
.globl vector160
vector160:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $160
80106dc9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106dce:	e9 0c f5 ff ff       	jmp    801062df <alltraps>

80106dd3 <vector161>:
.globl vector161
vector161:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $161
80106dd5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106dda:	e9 00 f5 ff ff       	jmp    801062df <alltraps>

80106ddf <vector162>:
.globl vector162
vector162:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $162
80106de1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106de6:	e9 f4 f4 ff ff       	jmp    801062df <alltraps>

80106deb <vector163>:
.globl vector163
vector163:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $163
80106ded:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106df2:	e9 e8 f4 ff ff       	jmp    801062df <alltraps>

80106df7 <vector164>:
.globl vector164
vector164:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $164
80106df9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106dfe:	e9 dc f4 ff ff       	jmp    801062df <alltraps>

80106e03 <vector165>:
.globl vector165
vector165:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $165
80106e05:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106e0a:	e9 d0 f4 ff ff       	jmp    801062df <alltraps>

80106e0f <vector166>:
.globl vector166
vector166:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $166
80106e11:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106e16:	e9 c4 f4 ff ff       	jmp    801062df <alltraps>

80106e1b <vector167>:
.globl vector167
vector167:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $167
80106e1d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106e22:	e9 b8 f4 ff ff       	jmp    801062df <alltraps>

80106e27 <vector168>:
.globl vector168
vector168:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $168
80106e29:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106e2e:	e9 ac f4 ff ff       	jmp    801062df <alltraps>

80106e33 <vector169>:
.globl vector169
vector169:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $169
80106e35:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106e3a:	e9 a0 f4 ff ff       	jmp    801062df <alltraps>

80106e3f <vector170>:
.globl vector170
vector170:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $170
80106e41:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106e46:	e9 94 f4 ff ff       	jmp    801062df <alltraps>

80106e4b <vector171>:
.globl vector171
vector171:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $171
80106e4d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106e52:	e9 88 f4 ff ff       	jmp    801062df <alltraps>

80106e57 <vector172>:
.globl vector172
vector172:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $172
80106e59:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106e5e:	e9 7c f4 ff ff       	jmp    801062df <alltraps>

80106e63 <vector173>:
.globl vector173
vector173:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $173
80106e65:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106e6a:	e9 70 f4 ff ff       	jmp    801062df <alltraps>

80106e6f <vector174>:
.globl vector174
vector174:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $174
80106e71:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106e76:	e9 64 f4 ff ff       	jmp    801062df <alltraps>

80106e7b <vector175>:
.globl vector175
vector175:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $175
80106e7d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106e82:	e9 58 f4 ff ff       	jmp    801062df <alltraps>

80106e87 <vector176>:
.globl vector176
vector176:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $176
80106e89:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106e8e:	e9 4c f4 ff ff       	jmp    801062df <alltraps>

80106e93 <vector177>:
.globl vector177
vector177:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $177
80106e95:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106e9a:	e9 40 f4 ff ff       	jmp    801062df <alltraps>

80106e9f <vector178>:
.globl vector178
vector178:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $178
80106ea1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106ea6:	e9 34 f4 ff ff       	jmp    801062df <alltraps>

80106eab <vector179>:
.globl vector179
vector179:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $179
80106ead:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106eb2:	e9 28 f4 ff ff       	jmp    801062df <alltraps>

80106eb7 <vector180>:
.globl vector180
vector180:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $180
80106eb9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106ebe:	e9 1c f4 ff ff       	jmp    801062df <alltraps>

80106ec3 <vector181>:
.globl vector181
vector181:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $181
80106ec5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106eca:	e9 10 f4 ff ff       	jmp    801062df <alltraps>

80106ecf <vector182>:
.globl vector182
vector182:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $182
80106ed1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106ed6:	e9 04 f4 ff ff       	jmp    801062df <alltraps>

80106edb <vector183>:
.globl vector183
vector183:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $183
80106edd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106ee2:	e9 f8 f3 ff ff       	jmp    801062df <alltraps>

80106ee7 <vector184>:
.globl vector184
vector184:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $184
80106ee9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106eee:	e9 ec f3 ff ff       	jmp    801062df <alltraps>

80106ef3 <vector185>:
.globl vector185
vector185:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $185
80106ef5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106efa:	e9 e0 f3 ff ff       	jmp    801062df <alltraps>

80106eff <vector186>:
.globl vector186
vector186:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $186
80106f01:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106f06:	e9 d4 f3 ff ff       	jmp    801062df <alltraps>

80106f0b <vector187>:
.globl vector187
vector187:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $187
80106f0d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106f12:	e9 c8 f3 ff ff       	jmp    801062df <alltraps>

80106f17 <vector188>:
.globl vector188
vector188:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $188
80106f19:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106f1e:	e9 bc f3 ff ff       	jmp    801062df <alltraps>

80106f23 <vector189>:
.globl vector189
vector189:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $189
80106f25:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106f2a:	e9 b0 f3 ff ff       	jmp    801062df <alltraps>

80106f2f <vector190>:
.globl vector190
vector190:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $190
80106f31:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106f36:	e9 a4 f3 ff ff       	jmp    801062df <alltraps>

80106f3b <vector191>:
.globl vector191
vector191:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $191
80106f3d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106f42:	e9 98 f3 ff ff       	jmp    801062df <alltraps>

80106f47 <vector192>:
.globl vector192
vector192:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $192
80106f49:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106f4e:	e9 8c f3 ff ff       	jmp    801062df <alltraps>

80106f53 <vector193>:
.globl vector193
vector193:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $193
80106f55:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106f5a:	e9 80 f3 ff ff       	jmp    801062df <alltraps>

80106f5f <vector194>:
.globl vector194
vector194:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $194
80106f61:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106f66:	e9 74 f3 ff ff       	jmp    801062df <alltraps>

80106f6b <vector195>:
.globl vector195
vector195:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $195
80106f6d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106f72:	e9 68 f3 ff ff       	jmp    801062df <alltraps>

80106f77 <vector196>:
.globl vector196
vector196:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $196
80106f79:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106f7e:	e9 5c f3 ff ff       	jmp    801062df <alltraps>

80106f83 <vector197>:
.globl vector197
vector197:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $197
80106f85:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106f8a:	e9 50 f3 ff ff       	jmp    801062df <alltraps>

80106f8f <vector198>:
.globl vector198
vector198:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $198
80106f91:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106f96:	e9 44 f3 ff ff       	jmp    801062df <alltraps>

80106f9b <vector199>:
.globl vector199
vector199:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $199
80106f9d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106fa2:	e9 38 f3 ff ff       	jmp    801062df <alltraps>

80106fa7 <vector200>:
.globl vector200
vector200:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $200
80106fa9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106fae:	e9 2c f3 ff ff       	jmp    801062df <alltraps>

80106fb3 <vector201>:
.globl vector201
vector201:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $201
80106fb5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106fba:	e9 20 f3 ff ff       	jmp    801062df <alltraps>

80106fbf <vector202>:
.globl vector202
vector202:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $202
80106fc1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106fc6:	e9 14 f3 ff ff       	jmp    801062df <alltraps>

80106fcb <vector203>:
.globl vector203
vector203:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $203
80106fcd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106fd2:	e9 08 f3 ff ff       	jmp    801062df <alltraps>

80106fd7 <vector204>:
.globl vector204
vector204:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $204
80106fd9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106fde:	e9 fc f2 ff ff       	jmp    801062df <alltraps>

80106fe3 <vector205>:
.globl vector205
vector205:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $205
80106fe5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106fea:	e9 f0 f2 ff ff       	jmp    801062df <alltraps>

80106fef <vector206>:
.globl vector206
vector206:
  pushl $0
80106fef:	6a 00                	push   $0x0
  pushl $206
80106ff1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106ff6:	e9 e4 f2 ff ff       	jmp    801062df <alltraps>

80106ffb <vector207>:
.globl vector207
vector207:
  pushl $0
80106ffb:	6a 00                	push   $0x0
  pushl $207
80106ffd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107002:	e9 d8 f2 ff ff       	jmp    801062df <alltraps>

80107007 <vector208>:
.globl vector208
vector208:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $208
80107009:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010700e:	e9 cc f2 ff ff       	jmp    801062df <alltraps>

80107013 <vector209>:
.globl vector209
vector209:
  pushl $0
80107013:	6a 00                	push   $0x0
  pushl $209
80107015:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010701a:	e9 c0 f2 ff ff       	jmp    801062df <alltraps>

8010701f <vector210>:
.globl vector210
vector210:
  pushl $0
8010701f:	6a 00                	push   $0x0
  pushl $210
80107021:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107026:	e9 b4 f2 ff ff       	jmp    801062df <alltraps>

8010702b <vector211>:
.globl vector211
vector211:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $211
8010702d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107032:	e9 a8 f2 ff ff       	jmp    801062df <alltraps>

80107037 <vector212>:
.globl vector212
vector212:
  pushl $0
80107037:	6a 00                	push   $0x0
  pushl $212
80107039:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010703e:	e9 9c f2 ff ff       	jmp    801062df <alltraps>

80107043 <vector213>:
.globl vector213
vector213:
  pushl $0
80107043:	6a 00                	push   $0x0
  pushl $213
80107045:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010704a:	e9 90 f2 ff ff       	jmp    801062df <alltraps>

8010704f <vector214>:
.globl vector214
vector214:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $214
80107051:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107056:	e9 84 f2 ff ff       	jmp    801062df <alltraps>

8010705b <vector215>:
.globl vector215
vector215:
  pushl $0
8010705b:	6a 00                	push   $0x0
  pushl $215
8010705d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107062:	e9 78 f2 ff ff       	jmp    801062df <alltraps>

80107067 <vector216>:
.globl vector216
vector216:
  pushl $0
80107067:	6a 00                	push   $0x0
  pushl $216
80107069:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010706e:	e9 6c f2 ff ff       	jmp    801062df <alltraps>

80107073 <vector217>:
.globl vector217
vector217:
  pushl $0
80107073:	6a 00                	push   $0x0
  pushl $217
80107075:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010707a:	e9 60 f2 ff ff       	jmp    801062df <alltraps>

8010707f <vector218>:
.globl vector218
vector218:
  pushl $0
8010707f:	6a 00                	push   $0x0
  pushl $218
80107081:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107086:	e9 54 f2 ff ff       	jmp    801062df <alltraps>

8010708b <vector219>:
.globl vector219
vector219:
  pushl $0
8010708b:	6a 00                	push   $0x0
  pushl $219
8010708d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107092:	e9 48 f2 ff ff       	jmp    801062df <alltraps>

80107097 <vector220>:
.globl vector220
vector220:
  pushl $0
80107097:	6a 00                	push   $0x0
  pushl $220
80107099:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010709e:	e9 3c f2 ff ff       	jmp    801062df <alltraps>

801070a3 <vector221>:
.globl vector221
vector221:
  pushl $0
801070a3:	6a 00                	push   $0x0
  pushl $221
801070a5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801070aa:	e9 30 f2 ff ff       	jmp    801062df <alltraps>

801070af <vector222>:
.globl vector222
vector222:
  pushl $0
801070af:	6a 00                	push   $0x0
  pushl $222
801070b1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801070b6:	e9 24 f2 ff ff       	jmp    801062df <alltraps>

801070bb <vector223>:
.globl vector223
vector223:
  pushl $0
801070bb:	6a 00                	push   $0x0
  pushl $223
801070bd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801070c2:	e9 18 f2 ff ff       	jmp    801062df <alltraps>

801070c7 <vector224>:
.globl vector224
vector224:
  pushl $0
801070c7:	6a 00                	push   $0x0
  pushl $224
801070c9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801070ce:	e9 0c f2 ff ff       	jmp    801062df <alltraps>

801070d3 <vector225>:
.globl vector225
vector225:
  pushl $0
801070d3:	6a 00                	push   $0x0
  pushl $225
801070d5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801070da:	e9 00 f2 ff ff       	jmp    801062df <alltraps>

801070df <vector226>:
.globl vector226
vector226:
  pushl $0
801070df:	6a 00                	push   $0x0
  pushl $226
801070e1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801070e6:	e9 f4 f1 ff ff       	jmp    801062df <alltraps>

801070eb <vector227>:
.globl vector227
vector227:
  pushl $0
801070eb:	6a 00                	push   $0x0
  pushl $227
801070ed:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801070f2:	e9 e8 f1 ff ff       	jmp    801062df <alltraps>

801070f7 <vector228>:
.globl vector228
vector228:
  pushl $0
801070f7:	6a 00                	push   $0x0
  pushl $228
801070f9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801070fe:	e9 dc f1 ff ff       	jmp    801062df <alltraps>

80107103 <vector229>:
.globl vector229
vector229:
  pushl $0
80107103:	6a 00                	push   $0x0
  pushl $229
80107105:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010710a:	e9 d0 f1 ff ff       	jmp    801062df <alltraps>

8010710f <vector230>:
.globl vector230
vector230:
  pushl $0
8010710f:	6a 00                	push   $0x0
  pushl $230
80107111:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107116:	e9 c4 f1 ff ff       	jmp    801062df <alltraps>

8010711b <vector231>:
.globl vector231
vector231:
  pushl $0
8010711b:	6a 00                	push   $0x0
  pushl $231
8010711d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107122:	e9 b8 f1 ff ff       	jmp    801062df <alltraps>

80107127 <vector232>:
.globl vector232
vector232:
  pushl $0
80107127:	6a 00                	push   $0x0
  pushl $232
80107129:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010712e:	e9 ac f1 ff ff       	jmp    801062df <alltraps>

80107133 <vector233>:
.globl vector233
vector233:
  pushl $0
80107133:	6a 00                	push   $0x0
  pushl $233
80107135:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010713a:	e9 a0 f1 ff ff       	jmp    801062df <alltraps>

8010713f <vector234>:
.globl vector234
vector234:
  pushl $0
8010713f:	6a 00                	push   $0x0
  pushl $234
80107141:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107146:	e9 94 f1 ff ff       	jmp    801062df <alltraps>

8010714b <vector235>:
.globl vector235
vector235:
  pushl $0
8010714b:	6a 00                	push   $0x0
  pushl $235
8010714d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107152:	e9 88 f1 ff ff       	jmp    801062df <alltraps>

80107157 <vector236>:
.globl vector236
vector236:
  pushl $0
80107157:	6a 00                	push   $0x0
  pushl $236
80107159:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010715e:	e9 7c f1 ff ff       	jmp    801062df <alltraps>

80107163 <vector237>:
.globl vector237
vector237:
  pushl $0
80107163:	6a 00                	push   $0x0
  pushl $237
80107165:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010716a:	e9 70 f1 ff ff       	jmp    801062df <alltraps>

8010716f <vector238>:
.globl vector238
vector238:
  pushl $0
8010716f:	6a 00                	push   $0x0
  pushl $238
80107171:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107176:	e9 64 f1 ff ff       	jmp    801062df <alltraps>

8010717b <vector239>:
.globl vector239
vector239:
  pushl $0
8010717b:	6a 00                	push   $0x0
  pushl $239
8010717d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107182:	e9 58 f1 ff ff       	jmp    801062df <alltraps>

80107187 <vector240>:
.globl vector240
vector240:
  pushl $0
80107187:	6a 00                	push   $0x0
  pushl $240
80107189:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010718e:	e9 4c f1 ff ff       	jmp    801062df <alltraps>

80107193 <vector241>:
.globl vector241
vector241:
  pushl $0
80107193:	6a 00                	push   $0x0
  pushl $241
80107195:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010719a:	e9 40 f1 ff ff       	jmp    801062df <alltraps>

8010719f <vector242>:
.globl vector242
vector242:
  pushl $0
8010719f:	6a 00                	push   $0x0
  pushl $242
801071a1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801071a6:	e9 34 f1 ff ff       	jmp    801062df <alltraps>

801071ab <vector243>:
.globl vector243
vector243:
  pushl $0
801071ab:	6a 00                	push   $0x0
  pushl $243
801071ad:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801071b2:	e9 28 f1 ff ff       	jmp    801062df <alltraps>

801071b7 <vector244>:
.globl vector244
vector244:
  pushl $0
801071b7:	6a 00                	push   $0x0
  pushl $244
801071b9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801071be:	e9 1c f1 ff ff       	jmp    801062df <alltraps>

801071c3 <vector245>:
.globl vector245
vector245:
  pushl $0
801071c3:	6a 00                	push   $0x0
  pushl $245
801071c5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801071ca:	e9 10 f1 ff ff       	jmp    801062df <alltraps>

801071cf <vector246>:
.globl vector246
vector246:
  pushl $0
801071cf:	6a 00                	push   $0x0
  pushl $246
801071d1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801071d6:	e9 04 f1 ff ff       	jmp    801062df <alltraps>

801071db <vector247>:
.globl vector247
vector247:
  pushl $0
801071db:	6a 00                	push   $0x0
  pushl $247
801071dd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801071e2:	e9 f8 f0 ff ff       	jmp    801062df <alltraps>

801071e7 <vector248>:
.globl vector248
vector248:
  pushl $0
801071e7:	6a 00                	push   $0x0
  pushl $248
801071e9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801071ee:	e9 ec f0 ff ff       	jmp    801062df <alltraps>

801071f3 <vector249>:
.globl vector249
vector249:
  pushl $0
801071f3:	6a 00                	push   $0x0
  pushl $249
801071f5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801071fa:	e9 e0 f0 ff ff       	jmp    801062df <alltraps>

801071ff <vector250>:
.globl vector250
vector250:
  pushl $0
801071ff:	6a 00                	push   $0x0
  pushl $250
80107201:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107206:	e9 d4 f0 ff ff       	jmp    801062df <alltraps>

8010720b <vector251>:
.globl vector251
vector251:
  pushl $0
8010720b:	6a 00                	push   $0x0
  pushl $251
8010720d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107212:	e9 c8 f0 ff ff       	jmp    801062df <alltraps>

80107217 <vector252>:
.globl vector252
vector252:
  pushl $0
80107217:	6a 00                	push   $0x0
  pushl $252
80107219:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010721e:	e9 bc f0 ff ff       	jmp    801062df <alltraps>

80107223 <vector253>:
.globl vector253
vector253:
  pushl $0
80107223:	6a 00                	push   $0x0
  pushl $253
80107225:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010722a:	e9 b0 f0 ff ff       	jmp    801062df <alltraps>

8010722f <vector254>:
.globl vector254
vector254:
  pushl $0
8010722f:	6a 00                	push   $0x0
  pushl $254
80107231:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107236:	e9 a4 f0 ff ff       	jmp    801062df <alltraps>

8010723b <vector255>:
.globl vector255
vector255:
  pushl $0
8010723b:	6a 00                	push   $0x0
  pushl $255
8010723d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107242:	e9 98 f0 ff ff       	jmp    801062df <alltraps>
80107247:	66 90                	xchg   %ax,%ax
80107249:	66 90                	xchg   %ax,%ax
8010724b:	66 90                	xchg   %ax,%ax
8010724d:	66 90                	xchg   %ax,%ax
8010724f:	90                   	nop

80107250 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107250:	55                   	push   %ebp
80107251:	89 e5                	mov    %esp,%ebp
80107253:	57                   	push   %edi
80107254:	56                   	push   %esi
80107255:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107256:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010725c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107262:	83 ec 1c             	sub    $0x1c,%esp
80107265:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107268:	39 d3                	cmp    %edx,%ebx
8010726a:	73 49                	jae    801072b5 <deallocuvm.part.0+0x65>
8010726c:	89 c7                	mov    %eax,%edi
8010726e:	eb 0c                	jmp    8010727c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107270:	83 c0 01             	add    $0x1,%eax
80107273:	c1 e0 16             	shl    $0x16,%eax
80107276:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107278:	39 da                	cmp    %ebx,%edx
8010727a:	76 39                	jbe    801072b5 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
8010727c:	89 d8                	mov    %ebx,%eax
8010727e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107281:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80107284:	f6 c1 01             	test   $0x1,%cl
80107287:	74 e7                	je     80107270 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80107289:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010728b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107291:	c1 ee 0a             	shr    $0xa,%esi
80107294:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
8010729a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
801072a1:	85 f6                	test   %esi,%esi
801072a3:	74 cb                	je     80107270 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
801072a5:	8b 06                	mov    (%esi),%eax
801072a7:	a8 01                	test   $0x1,%al
801072a9:	75 15                	jne    801072c0 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
801072ab:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801072b1:	39 da                	cmp    %ebx,%edx
801072b3:	77 c7                	ja     8010727c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801072b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801072b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072bb:	5b                   	pop    %ebx
801072bc:	5e                   	pop    %esi
801072bd:	5f                   	pop    %edi
801072be:	5d                   	pop    %ebp
801072bf:	c3                   	ret    
      if(pa == 0)
801072c0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801072c5:	74 25                	je     801072ec <deallocuvm.part.0+0x9c>
      kfree(v);
801072c7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801072ca:	05 00 00 00 80       	add    $0x80000000,%eax
801072cf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801072d2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
801072d8:	50                   	push   %eax
801072d9:	e8 42 b2 ff ff       	call   80102520 <kfree>
      *pte = 0;
801072de:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
801072e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801072e7:	83 c4 10             	add    $0x10,%esp
801072ea:	eb 8c                	jmp    80107278 <deallocuvm.part.0+0x28>
        panic("kfree");
801072ec:	83 ec 0c             	sub    $0xc,%esp
801072ef:	68 ae 7e 10 80       	push   $0x80107eae
801072f4:	e8 87 90 ff ff       	call   80100380 <panic>
801072f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107300 <mappages>:
{
80107300:	55                   	push   %ebp
80107301:	89 e5                	mov    %esp,%ebp
80107303:	57                   	push   %edi
80107304:	56                   	push   %esi
80107305:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107306:	89 d3                	mov    %edx,%ebx
80107308:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010730e:	83 ec 1c             	sub    $0x1c,%esp
80107311:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107314:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107318:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010731d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107320:	8b 45 08             	mov    0x8(%ebp),%eax
80107323:	29 d8                	sub    %ebx,%eax
80107325:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107328:	eb 3d                	jmp    80107367 <mappages+0x67>
8010732a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107330:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107332:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107337:	c1 ea 0a             	shr    $0xa,%edx
8010733a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107340:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107347:	85 c0                	test   %eax,%eax
80107349:	74 75                	je     801073c0 <mappages+0xc0>
    if(*pte & PTE_P)
8010734b:	f6 00 01             	testb  $0x1,(%eax)
8010734e:	0f 85 86 00 00 00    	jne    801073da <mappages+0xda>
    *pte = pa | perm | PTE_P;
80107354:	0b 75 0c             	or     0xc(%ebp),%esi
80107357:	83 ce 01             	or     $0x1,%esi
8010735a:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010735c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
8010735f:	74 6f                	je     801073d0 <mappages+0xd0>
    a += PGSIZE;
80107361:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80107367:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
8010736a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010736d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80107370:	89 d8                	mov    %ebx,%eax
80107372:	c1 e8 16             	shr    $0x16,%eax
80107375:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80107378:	8b 07                	mov    (%edi),%eax
8010737a:	a8 01                	test   $0x1,%al
8010737c:	75 b2                	jne    80107330 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010737e:	e8 5d b3 ff ff       	call   801026e0 <kalloc>
80107383:	85 c0                	test   %eax,%eax
80107385:	74 39                	je     801073c0 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80107387:	83 ec 04             	sub    $0x4,%esp
8010738a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010738d:	68 00 10 00 00       	push   $0x1000
80107392:	6a 00                	push   $0x0
80107394:	50                   	push   %eax
80107395:	e8 56 dd ff ff       	call   801050f0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010739a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
8010739d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801073a0:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
801073a6:	83 c8 07             	or     $0x7,%eax
801073a9:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
801073ab:	89 d8                	mov    %ebx,%eax
801073ad:	c1 e8 0a             	shr    $0xa,%eax
801073b0:	25 fc 0f 00 00       	and    $0xffc,%eax
801073b5:	01 d0                	add    %edx,%eax
801073b7:	eb 92                	jmp    8010734b <mappages+0x4b>
801073b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801073c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801073c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801073c8:	5b                   	pop    %ebx
801073c9:	5e                   	pop    %esi
801073ca:	5f                   	pop    %edi
801073cb:	5d                   	pop    %ebp
801073cc:	c3                   	ret    
801073cd:	8d 76 00             	lea    0x0(%esi),%esi
801073d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801073d3:	31 c0                	xor    %eax,%eax
}
801073d5:	5b                   	pop    %ebx
801073d6:	5e                   	pop    %esi
801073d7:	5f                   	pop    %edi
801073d8:	5d                   	pop    %ebp
801073d9:	c3                   	ret    
      panic("remap");
801073da:	83 ec 0c             	sub    $0xc,%esp
801073dd:	68 cc 86 10 80       	push   $0x801086cc
801073e2:	e8 99 8f ff ff       	call   80100380 <panic>
801073e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073ee:	66 90                	xchg   %ax,%ax

801073f0 <seginit>:
{
801073f0:	55                   	push   %ebp
801073f1:	89 e5                	mov    %esp,%ebp
801073f3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801073f6:	e8 45 c6 ff ff       	call   80103a40 <cpuid>
  pd[0] = size-1;
801073fb:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107400:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107406:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010740a:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
80107411:	ff 00 00 
80107414:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
8010741b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010741e:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
80107425:	ff 00 00 
80107428:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
8010742f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107432:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
80107439:	ff 00 00 
8010743c:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
80107443:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107446:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
8010744d:	ff 00 00 
80107450:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
80107457:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010745a:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
8010745f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107463:	c1 e8 10             	shr    $0x10,%eax
80107466:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010746a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010746d:	0f 01 10             	lgdtl  (%eax)
}
80107470:	c9                   	leave  
80107471:	c3                   	ret    
80107472:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107480 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107480:	a1 e4 59 11 80       	mov    0x801159e4,%eax
80107485:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010748a:	0f 22 d8             	mov    %eax,%cr3
}
8010748d:	c3                   	ret    
8010748e:	66 90                	xchg   %ax,%ax

80107490 <switchuvm>:
{
80107490:	55                   	push   %ebp
80107491:	89 e5                	mov    %esp,%ebp
80107493:	57                   	push   %edi
80107494:	56                   	push   %esi
80107495:	53                   	push   %ebx
80107496:	83 ec 1c             	sub    $0x1c,%esp
80107499:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010749c:	85 f6                	test   %esi,%esi
8010749e:	0f 84 cb 00 00 00    	je     8010756f <switchuvm+0xdf>
  if(p->kstack == 0)
801074a4:	8b 46 08             	mov    0x8(%esi),%eax
801074a7:	85 c0                	test   %eax,%eax
801074a9:	0f 84 da 00 00 00    	je     80107589 <switchuvm+0xf9>
  if(p->pgdir == 0)
801074af:	8b 46 04             	mov    0x4(%esi),%eax
801074b2:	85 c0                	test   %eax,%eax
801074b4:	0f 84 c2 00 00 00    	je     8010757c <switchuvm+0xec>
  pushcli();
801074ba:	e8 21 da ff ff       	call   80104ee0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801074bf:	e8 1c c5 ff ff       	call   801039e0 <mycpu>
801074c4:	89 c3                	mov    %eax,%ebx
801074c6:	e8 15 c5 ff ff       	call   801039e0 <mycpu>
801074cb:	89 c7                	mov    %eax,%edi
801074cd:	e8 0e c5 ff ff       	call   801039e0 <mycpu>
801074d2:	83 c7 08             	add    $0x8,%edi
801074d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801074d8:	e8 03 c5 ff ff       	call   801039e0 <mycpu>
801074dd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801074e0:	ba 67 00 00 00       	mov    $0x67,%edx
801074e5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801074ec:	83 c0 08             	add    $0x8,%eax
801074ef:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801074f6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801074fb:	83 c1 08             	add    $0x8,%ecx
801074fe:	c1 e8 18             	shr    $0x18,%eax
80107501:	c1 e9 10             	shr    $0x10,%ecx
80107504:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010750a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107510:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107515:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010751c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107521:	e8 ba c4 ff ff       	call   801039e0 <mycpu>
80107526:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010752d:	e8 ae c4 ff ff       	call   801039e0 <mycpu>
80107532:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107536:	8b 5e 08             	mov    0x8(%esi),%ebx
80107539:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010753f:	e8 9c c4 ff ff       	call   801039e0 <mycpu>
80107544:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107547:	e8 94 c4 ff ff       	call   801039e0 <mycpu>
8010754c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107550:	b8 28 00 00 00       	mov    $0x28,%eax
80107555:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107558:	8b 46 04             	mov    0x4(%esi),%eax
8010755b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107560:	0f 22 d8             	mov    %eax,%cr3
}
80107563:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107566:	5b                   	pop    %ebx
80107567:	5e                   	pop    %esi
80107568:	5f                   	pop    %edi
80107569:	5d                   	pop    %ebp
  popcli();
8010756a:	e9 c1 d9 ff ff       	jmp    80104f30 <popcli>
    panic("switchuvm: no process");
8010756f:	83 ec 0c             	sub    $0xc,%esp
80107572:	68 d2 86 10 80       	push   $0x801086d2
80107577:	e8 04 8e ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
8010757c:	83 ec 0c             	sub    $0xc,%esp
8010757f:	68 fd 86 10 80       	push   $0x801086fd
80107584:	e8 f7 8d ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80107589:	83 ec 0c             	sub    $0xc,%esp
8010758c:	68 e8 86 10 80       	push   $0x801086e8
80107591:	e8 ea 8d ff ff       	call   80100380 <panic>
80107596:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010759d:	8d 76 00             	lea    0x0(%esi),%esi

801075a0 <inituvm>:
{
801075a0:	55                   	push   %ebp
801075a1:	89 e5                	mov    %esp,%ebp
801075a3:	57                   	push   %edi
801075a4:	56                   	push   %esi
801075a5:	53                   	push   %ebx
801075a6:	83 ec 1c             	sub    $0x1c,%esp
801075a9:	8b 45 0c             	mov    0xc(%ebp),%eax
801075ac:	8b 75 10             	mov    0x10(%ebp),%esi
801075af:	8b 7d 08             	mov    0x8(%ebp),%edi
801075b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801075b5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801075bb:	77 4b                	ja     80107608 <inituvm+0x68>
  mem = kalloc();
801075bd:	e8 1e b1 ff ff       	call   801026e0 <kalloc>
  memset(mem, 0, PGSIZE);
801075c2:	83 ec 04             	sub    $0x4,%esp
801075c5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
801075ca:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801075cc:	6a 00                	push   $0x0
801075ce:	50                   	push   %eax
801075cf:	e8 1c db ff ff       	call   801050f0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801075d4:	58                   	pop    %eax
801075d5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801075db:	5a                   	pop    %edx
801075dc:	6a 06                	push   $0x6
801075de:	b9 00 10 00 00       	mov    $0x1000,%ecx
801075e3:	31 d2                	xor    %edx,%edx
801075e5:	50                   	push   %eax
801075e6:	89 f8                	mov    %edi,%eax
801075e8:	e8 13 fd ff ff       	call   80107300 <mappages>
  memmove(mem, init, sz);
801075ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801075f0:	89 75 10             	mov    %esi,0x10(%ebp)
801075f3:	83 c4 10             	add    $0x10,%esp
801075f6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801075f9:	89 45 0c             	mov    %eax,0xc(%ebp)
}
801075fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075ff:	5b                   	pop    %ebx
80107600:	5e                   	pop    %esi
80107601:	5f                   	pop    %edi
80107602:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107603:	e9 88 db ff ff       	jmp    80105190 <memmove>
    panic("inituvm: more than a page");
80107608:	83 ec 0c             	sub    $0xc,%esp
8010760b:	68 11 87 10 80       	push   $0x80108711
80107610:	e8 6b 8d ff ff       	call   80100380 <panic>
80107615:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010761c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107620 <loaduvm>:
{
80107620:	55                   	push   %ebp
80107621:	89 e5                	mov    %esp,%ebp
80107623:	57                   	push   %edi
80107624:	56                   	push   %esi
80107625:	53                   	push   %ebx
80107626:	83 ec 1c             	sub    $0x1c,%esp
80107629:	8b 45 0c             	mov    0xc(%ebp),%eax
8010762c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
8010762f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107634:	0f 85 bb 00 00 00    	jne    801076f5 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
8010763a:	01 f0                	add    %esi,%eax
8010763c:	89 f3                	mov    %esi,%ebx
8010763e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107641:	8b 45 14             	mov    0x14(%ebp),%eax
80107644:	01 f0                	add    %esi,%eax
80107646:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107649:	85 f6                	test   %esi,%esi
8010764b:	0f 84 87 00 00 00    	je     801076d8 <loaduvm+0xb8>
80107651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80107658:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
8010765b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010765e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80107660:	89 c2                	mov    %eax,%edx
80107662:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107665:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107668:	f6 c2 01             	test   $0x1,%dl
8010766b:	75 13                	jne    80107680 <loaduvm+0x60>
      panic("loaduvm: address should exist");
8010766d:	83 ec 0c             	sub    $0xc,%esp
80107670:	68 2b 87 10 80       	push   $0x8010872b
80107675:	e8 06 8d ff ff       	call   80100380 <panic>
8010767a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107680:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107683:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107689:	25 fc 0f 00 00       	and    $0xffc,%eax
8010768e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107695:	85 c0                	test   %eax,%eax
80107697:	74 d4                	je     8010766d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107699:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010769b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010769e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801076a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801076a8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801076ae:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801076b1:	29 d9                	sub    %ebx,%ecx
801076b3:	05 00 00 00 80       	add    $0x80000000,%eax
801076b8:	57                   	push   %edi
801076b9:	51                   	push   %ecx
801076ba:	50                   	push   %eax
801076bb:	ff 75 10             	push   0x10(%ebp)
801076be:	e8 2d a4 ff ff       	call   80101af0 <readi>
801076c3:	83 c4 10             	add    $0x10,%esp
801076c6:	39 f8                	cmp    %edi,%eax
801076c8:	75 1e                	jne    801076e8 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
801076ca:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801076d0:	89 f0                	mov    %esi,%eax
801076d2:	29 d8                	sub    %ebx,%eax
801076d4:	39 c6                	cmp    %eax,%esi
801076d6:	77 80                	ja     80107658 <loaduvm+0x38>
}
801076d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801076db:	31 c0                	xor    %eax,%eax
}
801076dd:	5b                   	pop    %ebx
801076de:	5e                   	pop    %esi
801076df:	5f                   	pop    %edi
801076e0:	5d                   	pop    %ebp
801076e1:	c3                   	ret    
801076e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801076e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801076eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801076f0:	5b                   	pop    %ebx
801076f1:	5e                   	pop    %esi
801076f2:	5f                   	pop    %edi
801076f3:	5d                   	pop    %ebp
801076f4:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
801076f5:	83 ec 0c             	sub    $0xc,%esp
801076f8:	68 cc 87 10 80       	push   $0x801087cc
801076fd:	e8 7e 8c ff ff       	call   80100380 <panic>
80107702:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107710 <allocuvm>:
{
80107710:	55                   	push   %ebp
80107711:	89 e5                	mov    %esp,%ebp
80107713:	57                   	push   %edi
80107714:	56                   	push   %esi
80107715:	53                   	push   %ebx
80107716:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107719:	8b 45 10             	mov    0x10(%ebp),%eax
{
8010771c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
8010771f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107722:	85 c0                	test   %eax,%eax
80107724:	0f 88 b6 00 00 00    	js     801077e0 <allocuvm+0xd0>
  if(newsz < oldsz)
8010772a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
8010772d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107730:	0f 82 9a 00 00 00    	jb     801077d0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80107736:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
8010773c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107742:	39 75 10             	cmp    %esi,0x10(%ebp)
80107745:	77 44                	ja     8010778b <allocuvm+0x7b>
80107747:	e9 87 00 00 00       	jmp    801077d3 <allocuvm+0xc3>
8010774c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107750:	83 ec 04             	sub    $0x4,%esp
80107753:	68 00 10 00 00       	push   $0x1000
80107758:	6a 00                	push   $0x0
8010775a:	50                   	push   %eax
8010775b:	e8 90 d9 ff ff       	call   801050f0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107760:	58                   	pop    %eax
80107761:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107767:	5a                   	pop    %edx
80107768:	6a 06                	push   $0x6
8010776a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010776f:	89 f2                	mov    %esi,%edx
80107771:	50                   	push   %eax
80107772:	89 f8                	mov    %edi,%eax
80107774:	e8 87 fb ff ff       	call   80107300 <mappages>
80107779:	83 c4 10             	add    $0x10,%esp
8010777c:	85 c0                	test   %eax,%eax
8010777e:	78 78                	js     801077f8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107780:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107786:	39 75 10             	cmp    %esi,0x10(%ebp)
80107789:	76 48                	jbe    801077d3 <allocuvm+0xc3>
    mem = kalloc();
8010778b:	e8 50 af ff ff       	call   801026e0 <kalloc>
80107790:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107792:	85 c0                	test   %eax,%eax
80107794:	75 ba                	jne    80107750 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107796:	83 ec 0c             	sub    $0xc,%esp
80107799:	68 49 87 10 80       	push   $0x80108749
8010779e:	e8 fd 8e ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801077a3:	8b 45 0c             	mov    0xc(%ebp),%eax
801077a6:	83 c4 10             	add    $0x10,%esp
801077a9:	39 45 10             	cmp    %eax,0x10(%ebp)
801077ac:	74 32                	je     801077e0 <allocuvm+0xd0>
801077ae:	8b 55 10             	mov    0x10(%ebp),%edx
801077b1:	89 c1                	mov    %eax,%ecx
801077b3:	89 f8                	mov    %edi,%eax
801077b5:	e8 96 fa ff ff       	call   80107250 <deallocuvm.part.0>
      return 0;
801077ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801077c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801077c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077c7:	5b                   	pop    %ebx
801077c8:	5e                   	pop    %esi
801077c9:	5f                   	pop    %edi
801077ca:	5d                   	pop    %ebp
801077cb:	c3                   	ret    
801077cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
801077d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801077d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801077d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077d9:	5b                   	pop    %ebx
801077da:	5e                   	pop    %esi
801077db:	5f                   	pop    %edi
801077dc:	5d                   	pop    %ebp
801077dd:	c3                   	ret    
801077de:	66 90                	xchg   %ax,%ax
    return 0;
801077e0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801077e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801077ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077ed:	5b                   	pop    %ebx
801077ee:	5e                   	pop    %esi
801077ef:	5f                   	pop    %edi
801077f0:	5d                   	pop    %ebp
801077f1:	c3                   	ret    
801077f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801077f8:	83 ec 0c             	sub    $0xc,%esp
801077fb:	68 61 87 10 80       	push   $0x80108761
80107800:	e8 9b 8e ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107805:	8b 45 0c             	mov    0xc(%ebp),%eax
80107808:	83 c4 10             	add    $0x10,%esp
8010780b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010780e:	74 0c                	je     8010781c <allocuvm+0x10c>
80107810:	8b 55 10             	mov    0x10(%ebp),%edx
80107813:	89 c1                	mov    %eax,%ecx
80107815:	89 f8                	mov    %edi,%eax
80107817:	e8 34 fa ff ff       	call   80107250 <deallocuvm.part.0>
      kfree(mem);
8010781c:	83 ec 0c             	sub    $0xc,%esp
8010781f:	53                   	push   %ebx
80107820:	e8 fb ac ff ff       	call   80102520 <kfree>
      return 0;
80107825:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010782c:	83 c4 10             	add    $0x10,%esp
}
8010782f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107832:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107835:	5b                   	pop    %ebx
80107836:	5e                   	pop    %esi
80107837:	5f                   	pop    %edi
80107838:	5d                   	pop    %ebp
80107839:	c3                   	ret    
8010783a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107840 <deallocuvm>:
{
80107840:	55                   	push   %ebp
80107841:	89 e5                	mov    %esp,%ebp
80107843:	8b 55 0c             	mov    0xc(%ebp),%edx
80107846:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107849:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010784c:	39 d1                	cmp    %edx,%ecx
8010784e:	73 10                	jae    80107860 <deallocuvm+0x20>
}
80107850:	5d                   	pop    %ebp
80107851:	e9 fa f9 ff ff       	jmp    80107250 <deallocuvm.part.0>
80107856:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010785d:	8d 76 00             	lea    0x0(%esi),%esi
80107860:	89 d0                	mov    %edx,%eax
80107862:	5d                   	pop    %ebp
80107863:	c3                   	ret    
80107864:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010786b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010786f:	90                   	nop

80107870 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107870:	55                   	push   %ebp
80107871:	89 e5                	mov    %esp,%ebp
80107873:	57                   	push   %edi
80107874:	56                   	push   %esi
80107875:	53                   	push   %ebx
80107876:	83 ec 0c             	sub    $0xc,%esp
80107879:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010787c:	85 f6                	test   %esi,%esi
8010787e:	74 59                	je     801078d9 <freevm+0x69>
  if(newsz >= oldsz)
80107880:	31 c9                	xor    %ecx,%ecx
80107882:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107887:	89 f0                	mov    %esi,%eax
80107889:	89 f3                	mov    %esi,%ebx
8010788b:	e8 c0 f9 ff ff       	call   80107250 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107890:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107896:	eb 0f                	jmp    801078a7 <freevm+0x37>
80107898:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010789f:	90                   	nop
801078a0:	83 c3 04             	add    $0x4,%ebx
801078a3:	39 df                	cmp    %ebx,%edi
801078a5:	74 23                	je     801078ca <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801078a7:	8b 03                	mov    (%ebx),%eax
801078a9:	a8 01                	test   $0x1,%al
801078ab:	74 f3                	je     801078a0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801078ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801078b2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
801078b5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801078b8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801078bd:	50                   	push   %eax
801078be:	e8 5d ac ff ff       	call   80102520 <kfree>
801078c3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801078c6:	39 df                	cmp    %ebx,%edi
801078c8:	75 dd                	jne    801078a7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801078ca:	89 75 08             	mov    %esi,0x8(%ebp)
}
801078cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078d0:	5b                   	pop    %ebx
801078d1:	5e                   	pop    %esi
801078d2:	5f                   	pop    %edi
801078d3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801078d4:	e9 47 ac ff ff       	jmp    80102520 <kfree>
    panic("freevm: no pgdir");
801078d9:	83 ec 0c             	sub    $0xc,%esp
801078dc:	68 7d 87 10 80       	push   $0x8010877d
801078e1:	e8 9a 8a ff ff       	call   80100380 <panic>
801078e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078ed:	8d 76 00             	lea    0x0(%esi),%esi

801078f0 <setupkvm>:
{
801078f0:	55                   	push   %ebp
801078f1:	89 e5                	mov    %esp,%ebp
801078f3:	56                   	push   %esi
801078f4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801078f5:	e8 e6 ad ff ff       	call   801026e0 <kalloc>
801078fa:	89 c6                	mov    %eax,%esi
801078fc:	85 c0                	test   %eax,%eax
801078fe:	74 42                	je     80107942 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107900:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107903:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107908:	68 00 10 00 00       	push   $0x1000
8010790d:	6a 00                	push   $0x0
8010790f:	50                   	push   %eax
80107910:	e8 db d7 ff ff       	call   801050f0 <memset>
80107915:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107918:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010791b:	83 ec 08             	sub    $0x8,%esp
8010791e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107921:	ff 73 0c             	push   0xc(%ebx)
80107924:	8b 13                	mov    (%ebx),%edx
80107926:	50                   	push   %eax
80107927:	29 c1                	sub    %eax,%ecx
80107929:	89 f0                	mov    %esi,%eax
8010792b:	e8 d0 f9 ff ff       	call   80107300 <mappages>
80107930:	83 c4 10             	add    $0x10,%esp
80107933:	85 c0                	test   %eax,%eax
80107935:	78 19                	js     80107950 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107937:	83 c3 10             	add    $0x10,%ebx
8010793a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107940:	75 d6                	jne    80107918 <setupkvm+0x28>
}
80107942:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107945:	89 f0                	mov    %esi,%eax
80107947:	5b                   	pop    %ebx
80107948:	5e                   	pop    %esi
80107949:	5d                   	pop    %ebp
8010794a:	c3                   	ret    
8010794b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010794f:	90                   	nop
      freevm(pgdir);
80107950:	83 ec 0c             	sub    $0xc,%esp
80107953:	56                   	push   %esi
      return 0;
80107954:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107956:	e8 15 ff ff ff       	call   80107870 <freevm>
      return 0;
8010795b:	83 c4 10             	add    $0x10,%esp
}
8010795e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107961:	89 f0                	mov    %esi,%eax
80107963:	5b                   	pop    %ebx
80107964:	5e                   	pop    %esi
80107965:	5d                   	pop    %ebp
80107966:	c3                   	ret    
80107967:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010796e:	66 90                	xchg   %ax,%ax

80107970 <kvmalloc>:
{
80107970:	55                   	push   %ebp
80107971:	89 e5                	mov    %esp,%ebp
80107973:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107976:	e8 75 ff ff ff       	call   801078f0 <setupkvm>
8010797b:	a3 e4 59 11 80       	mov    %eax,0x801159e4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107980:	05 00 00 00 80       	add    $0x80000000,%eax
80107985:	0f 22 d8             	mov    %eax,%cr3
}
80107988:	c9                   	leave  
80107989:	c3                   	ret    
8010798a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107990 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107990:	55                   	push   %ebp
80107991:	89 e5                	mov    %esp,%ebp
80107993:	83 ec 08             	sub    $0x8,%esp
80107996:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107999:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010799c:	89 c1                	mov    %eax,%ecx
8010799e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801079a1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801079a4:	f6 c2 01             	test   $0x1,%dl
801079a7:	75 17                	jne    801079c0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801079a9:	83 ec 0c             	sub    $0xc,%esp
801079ac:	68 8e 87 10 80       	push   $0x8010878e
801079b1:	e8 ca 89 ff ff       	call   80100380 <panic>
801079b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079bd:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801079c0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801079c3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801079c9:	25 fc 0f 00 00       	and    $0xffc,%eax
801079ce:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801079d5:	85 c0                	test   %eax,%eax
801079d7:	74 d0                	je     801079a9 <clearpteu+0x19>
  *pte &= ~PTE_U;
801079d9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801079dc:	c9                   	leave  
801079dd:	c3                   	ret    
801079de:	66 90                	xchg   %ax,%ax

801079e0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801079e0:	55                   	push   %ebp
801079e1:	89 e5                	mov    %esp,%ebp
801079e3:	57                   	push   %edi
801079e4:	56                   	push   %esi
801079e5:	53                   	push   %ebx
801079e6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801079e9:	e8 02 ff ff ff       	call   801078f0 <setupkvm>
801079ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
801079f1:	85 c0                	test   %eax,%eax
801079f3:	0f 84 bd 00 00 00    	je     80107ab6 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801079f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801079fc:	85 c9                	test   %ecx,%ecx
801079fe:	0f 84 b2 00 00 00    	je     80107ab6 <copyuvm+0xd6>
80107a04:	31 f6                	xor    %esi,%esi
80107a06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a0d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107a10:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107a13:	89 f0                	mov    %esi,%eax
80107a15:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107a18:	8b 04 81             	mov    (%ecx,%eax,4),%eax
80107a1b:	a8 01                	test   $0x1,%al
80107a1d:	75 11                	jne    80107a30 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80107a1f:	83 ec 0c             	sub    $0xc,%esp
80107a22:	68 98 87 10 80       	push   $0x80108798
80107a27:	e8 54 89 ff ff       	call   80100380 <panic>
80107a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107a30:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107a32:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107a37:	c1 ea 0a             	shr    $0xa,%edx
80107a3a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107a40:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107a47:	85 c0                	test   %eax,%eax
80107a49:	74 d4                	je     80107a1f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
80107a4b:	8b 00                	mov    (%eax),%eax
80107a4d:	a8 01                	test   $0x1,%al
80107a4f:	0f 84 9f 00 00 00    	je     80107af4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107a55:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107a57:	25 ff 0f 00 00       	and    $0xfff,%eax
80107a5c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107a5f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107a65:	e8 76 ac ff ff       	call   801026e0 <kalloc>
80107a6a:	89 c3                	mov    %eax,%ebx
80107a6c:	85 c0                	test   %eax,%eax
80107a6e:	74 64                	je     80107ad4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107a70:	83 ec 04             	sub    $0x4,%esp
80107a73:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107a79:	68 00 10 00 00       	push   $0x1000
80107a7e:	57                   	push   %edi
80107a7f:	50                   	push   %eax
80107a80:	e8 0b d7 ff ff       	call   80105190 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107a85:	58                   	pop    %eax
80107a86:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107a8c:	5a                   	pop    %edx
80107a8d:	ff 75 e4             	push   -0x1c(%ebp)
80107a90:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107a95:	89 f2                	mov    %esi,%edx
80107a97:	50                   	push   %eax
80107a98:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107a9b:	e8 60 f8 ff ff       	call   80107300 <mappages>
80107aa0:	83 c4 10             	add    $0x10,%esp
80107aa3:	85 c0                	test   %eax,%eax
80107aa5:	78 21                	js     80107ac8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107aa7:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107aad:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107ab0:	0f 87 5a ff ff ff    	ja     80107a10 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107ab6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107ab9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107abc:	5b                   	pop    %ebx
80107abd:	5e                   	pop    %esi
80107abe:	5f                   	pop    %edi
80107abf:	5d                   	pop    %ebp
80107ac0:	c3                   	ret    
80107ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107ac8:	83 ec 0c             	sub    $0xc,%esp
80107acb:	53                   	push   %ebx
80107acc:	e8 4f aa ff ff       	call   80102520 <kfree>
      goto bad;
80107ad1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107ad4:	83 ec 0c             	sub    $0xc,%esp
80107ad7:	ff 75 e0             	push   -0x20(%ebp)
80107ada:	e8 91 fd ff ff       	call   80107870 <freevm>
  return 0;
80107adf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107ae6:	83 c4 10             	add    $0x10,%esp
}
80107ae9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107aec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107aef:	5b                   	pop    %ebx
80107af0:	5e                   	pop    %esi
80107af1:	5f                   	pop    %edi
80107af2:	5d                   	pop    %ebp
80107af3:	c3                   	ret    
      panic("copyuvm: page not present");
80107af4:	83 ec 0c             	sub    $0xc,%esp
80107af7:	68 b2 87 10 80       	push   $0x801087b2
80107afc:	e8 7f 88 ff ff       	call   80100380 <panic>
80107b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b0f:	90                   	nop

80107b10 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107b10:	55                   	push   %ebp
80107b11:	89 e5                	mov    %esp,%ebp
80107b13:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107b16:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107b19:	89 c1                	mov    %eax,%ecx
80107b1b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107b1e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107b21:	f6 c2 01             	test   $0x1,%dl
80107b24:	0f 84 00 01 00 00    	je     80107c2a <uva2ka.cold>
  return &pgtab[PTX(va)];
80107b2a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107b2d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107b33:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107b34:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107b39:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107b40:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107b42:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107b47:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107b4a:	05 00 00 00 80       	add    $0x80000000,%eax
80107b4f:	83 fa 05             	cmp    $0x5,%edx
80107b52:	ba 00 00 00 00       	mov    $0x0,%edx
80107b57:	0f 45 c2             	cmovne %edx,%eax
}
80107b5a:	c3                   	ret    
80107b5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107b5f:	90                   	nop

80107b60 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107b60:	55                   	push   %ebp
80107b61:	89 e5                	mov    %esp,%ebp
80107b63:	57                   	push   %edi
80107b64:	56                   	push   %esi
80107b65:	53                   	push   %ebx
80107b66:	83 ec 0c             	sub    $0xc,%esp
80107b69:	8b 75 14             	mov    0x14(%ebp),%esi
80107b6c:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b6f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107b72:	85 f6                	test   %esi,%esi
80107b74:	75 51                	jne    80107bc7 <copyout+0x67>
80107b76:	e9 a5 00 00 00       	jmp    80107c20 <copyout+0xc0>
80107b7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107b7f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107b80:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107b86:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
80107b8c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107b92:	74 75                	je     80107c09 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107b94:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107b96:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107b99:	29 c3                	sub    %eax,%ebx
80107b9b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107ba1:	39 f3                	cmp    %esi,%ebx
80107ba3:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107ba6:	29 f8                	sub    %edi,%eax
80107ba8:	83 ec 04             	sub    $0x4,%esp
80107bab:	01 c1                	add    %eax,%ecx
80107bad:	53                   	push   %ebx
80107bae:	52                   	push   %edx
80107baf:	51                   	push   %ecx
80107bb0:	e8 db d5 ff ff       	call   80105190 <memmove>
    len -= n;
    buf += n;
80107bb5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107bb8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
80107bbe:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107bc1:	01 da                	add    %ebx,%edx
  while(len > 0){
80107bc3:	29 de                	sub    %ebx,%esi
80107bc5:	74 59                	je     80107c20 <copyout+0xc0>
  if(*pde & PTE_P){
80107bc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
80107bca:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107bcc:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
80107bce:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107bd1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107bd7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
80107bda:	f6 c1 01             	test   $0x1,%cl
80107bdd:	0f 84 4e 00 00 00    	je     80107c31 <copyout.cold>
  return &pgtab[PTX(va)];
80107be3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107be5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107beb:	c1 eb 0c             	shr    $0xc,%ebx
80107bee:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107bf4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
80107bfb:	89 d9                	mov    %ebx,%ecx
80107bfd:	83 e1 05             	and    $0x5,%ecx
80107c00:	83 f9 05             	cmp    $0x5,%ecx
80107c03:	0f 84 77 ff ff ff    	je     80107b80 <copyout+0x20>
  }
  return 0;
}
80107c09:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107c0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107c11:	5b                   	pop    %ebx
80107c12:	5e                   	pop    %esi
80107c13:	5f                   	pop    %edi
80107c14:	5d                   	pop    %ebp
80107c15:	c3                   	ret    
80107c16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c1d:	8d 76 00             	lea    0x0(%esi),%esi
80107c20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107c23:	31 c0                	xor    %eax,%eax
}
80107c25:	5b                   	pop    %ebx
80107c26:	5e                   	pop    %esi
80107c27:	5f                   	pop    %edi
80107c28:	5d                   	pop    %ebp
80107c29:	c3                   	ret    

80107c2a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80107c2a:	a1 00 00 00 00       	mov    0x0,%eax
80107c2f:	0f 0b                	ud2    

80107c31 <copyout.cold>:
80107c31:	a1 00 00 00 00       	mov    0x0,%eax
80107c36:	0f 0b                	ud2    
