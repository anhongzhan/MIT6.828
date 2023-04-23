
obj/user/httpd.debug:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 d2 07 00 00       	call   800803 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <die>:
	{404, "Not Found"},
};

static void
die(char *m)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	cprintf("%s\n", m);
  800039:	50                   	push   %eax
  80003a:	68 c0 2e 80 00       	push   $0x802ec0
  80003f:	e8 0e 09 00 00       	call   800952 <cprintf>
	exit();
  800044:	e8 04 08 00 00       	call   80084d <exit>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <send_error>:
	return 0;
}

static int
send_error(struct http_request *req, int code)
{
  80004e:	55                   	push   %ebp
  80004f:	89 e5                	mov    %esp,%ebp
  800051:	57                   	push   %edi
  800052:	56                   	push   %esi
  800053:	53                   	push   %ebx
  800054:	81 ec 0c 02 00 00    	sub    $0x20c,%esp
  80005a:	89 c3                	mov    %eax,%ebx
	char buf[512];
	int r;

	struct error_messages *e = errors;
  80005c:	b8 00 40 80 00       	mov    $0x804000,%eax
	while (e->code != 0 && e->msg != 0) {
  800061:	8b 08                	mov    (%eax),%ecx
  800063:	85 c9                	test   %ecx,%ecx
  800065:	74 52                	je     8000b9 <send_error+0x6b>
		if (e->code == code)
  800067:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
  80006b:	74 09                	je     800076 <send_error+0x28>
  80006d:	39 d1                	cmp    %edx,%ecx
  80006f:	74 05                	je     800076 <send_error+0x28>
			break;
		e++;
  800071:	83 c0 08             	add    $0x8,%eax
  800074:	eb eb                	jmp    800061 <send_error+0x13>
	}

	if (e->code == 0)
		return -1;

	r = snprintf(buf, 512, "HTTP/" HTTP_VERSION" %d %s\r\n"
  800076:	8b 40 04             	mov    0x4(%eax),%eax
  800079:	83 ec 04             	sub    $0x4,%esp
  80007c:	50                   	push   %eax
  80007d:	51                   	push   %ecx
  80007e:	50                   	push   %eax
  80007f:	51                   	push   %ecx
  800080:	68 80 2f 80 00       	push   $0x802f80
  800085:	68 00 02 00 00       	push   $0x200
  80008a:	8d bd e8 fd ff ff    	lea    -0x218(%ebp),%edi
  800090:	57                   	push   %edi
  800091:	e8 65 0e 00 00       	call   800efb <snprintf>
  800096:	89 c6                	mov    %eax,%esi
			       "Content-type: text/html\r\n"
			       "\r\n"
			       "<html><body><p>%d - %s</p></body></html>\r\n",
			       e->code, e->msg, e->code, e->msg);

	if (write(req->sock, buf, r) != r)
  800098:	83 c4 1c             	add    $0x1c,%esp
  80009b:	50                   	push   %eax
  80009c:	57                   	push   %edi
  80009d:	ff 33                	pushl  (%ebx)
  80009f:	e8 9d 19 00 00       	call   801a41 <write>
  8000a4:	83 c4 10             	add    $0x10,%esp
  8000a7:	39 f0                	cmp    %esi,%eax
  8000a9:	0f 95 c0             	setne  %al
  8000ac:	0f b6 c0             	movzbl %al,%eax
  8000af:	f7 d8                	neg    %eax
		return -1;

	return 0;
}
  8000b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000b4:	5b                   	pop    %ebx
  8000b5:	5e                   	pop    %esi
  8000b6:	5f                   	pop    %edi
  8000b7:	5d                   	pop    %ebp
  8000b8:	c3                   	ret    
		return -1;
  8000b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8000be:	eb f1                	jmp    8000b1 <send_error+0x63>

008000c0 <handle_client>:
	return r;
}

static void
handle_client(int sock)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	57                   	push   %edi
  8000c4:	56                   	push   %esi
  8000c5:	53                   	push   %ebx
  8000c6:	81 ec 50 03 00 00    	sub    $0x350,%esp
  8000cc:	89 c6                	mov    %eax,%esi
	struct http_request *req = &con_d;

	while (1)
	{
		// Receive message
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  8000ce:	68 00 02 00 00       	push   $0x200
  8000d3:	8d 85 dc fd ff ff    	lea    -0x224(%ebp),%eax
  8000d9:	50                   	push   %eax
  8000da:	56                   	push   %esi
  8000db:	e8 8b 18 00 00       	call   80196b <read>
  8000e0:	83 c4 10             	add    $0x10,%esp
  8000e3:	85 c0                	test   %eax,%eax
  8000e5:	78 44                	js     80012b <handle_client+0x6b>
			panic("failed to read");

		memset(req, 0, sizeof(*req));
  8000e7:	83 ec 04             	sub    $0x4,%esp
  8000ea:	6a 0c                	push   $0xc
  8000ec:	6a 00                	push   $0x0
  8000ee:	8d 45 dc             	lea    -0x24(%ebp),%eax
  8000f1:	50                   	push   %eax
  8000f2:	e8 cf 0f 00 00       	call   8010c6 <memset>

		req->sock = sock;
  8000f7:	89 75 dc             	mov    %esi,-0x24(%ebp)
	if (strncmp(request, "GET ", 4) != 0)
  8000fa:	83 c4 0c             	add    $0xc,%esp
  8000fd:	6a 04                	push   $0x4
  8000ff:	68 e0 2e 80 00       	push   $0x802ee0
  800104:	8d 85 dc fd ff ff    	lea    -0x224(%ebp),%eax
  80010a:	50                   	push   %eax
  80010b:	e8 35 0f 00 00       	call   801045 <strncmp>
  800110:	83 c4 10             	add    $0x10,%esp
  800113:	85 c0                	test   %eax,%eax
  800115:	0f 85 df 02 00 00    	jne    8003fa <handle_client+0x33a>
	request += 4;
  80011b:	8d 9d e0 fd ff ff    	lea    -0x220(%ebp),%ebx
	while (*request && *request != ' ')
  800121:	f6 03 df             	testb  $0xdf,(%ebx)
  800124:	74 1c                	je     800142 <handle_client+0x82>
		request++;
  800126:	83 c3 01             	add    $0x1,%ebx
  800129:	eb f6                	jmp    800121 <handle_client+0x61>
			panic("failed to read");
  80012b:	83 ec 04             	sub    $0x4,%esp
  80012e:	68 c4 2e 80 00       	push   $0x802ec4
  800133:	68 1d 01 00 00       	push   $0x11d
  800138:	68 d3 2e 80 00       	push   $0x802ed3
  80013d:	e8 29 07 00 00       	call   80086b <_panic>
	url_len = request - url;
  800142:	89 df                	mov    %ebx,%edi
  800144:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
  80014a:	29 c7                	sub    %eax,%edi
	req->url = malloc(url_len + 1);
  80014c:	83 ec 0c             	sub    $0xc,%esp
  80014f:	8d 47 01             	lea    0x1(%edi),%eax
  800152:	50                   	push   %eax
  800153:	e8 bd 22 00 00       	call   802415 <malloc>
  800158:	89 45 e0             	mov    %eax,-0x20(%ebp)
	memmove(req->url, url, url_len);
  80015b:	83 c4 0c             	add    $0xc,%esp
  80015e:	57                   	push   %edi
  80015f:	8d 8d e0 fd ff ff    	lea    -0x220(%ebp),%ecx
  800165:	51                   	push   %ecx
  800166:	50                   	push   %eax
  800167:	e8 a6 0f 00 00       	call   801112 <memmove>
	req->url[url_len] = '\0';
  80016c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80016f:	c6 04 38 00          	movb   $0x0,(%eax,%edi,1)
	request++;
  800173:	83 c3 01             	add    $0x1,%ebx
	while (*request && *request != '\n')
  800176:	83 c4 10             	add    $0x10,%esp
	request++;
  800179:	89 d8                	mov    %ebx,%eax
	while (*request && *request != '\n')
  80017b:	0f b6 10             	movzbl (%eax),%edx
  80017e:	84 d2                	test   %dl,%dl
  800180:	74 0a                	je     80018c <handle_client+0xcc>
  800182:	80 fa 0a             	cmp    $0xa,%dl
  800185:	74 05                	je     80018c <handle_client+0xcc>
		request++;
  800187:	83 c0 01             	add    $0x1,%eax
  80018a:	eb ef                	jmp    80017b <handle_client+0xbb>
	version_len = request - version;
  80018c:	29 d8                	sub    %ebx,%eax
  80018e:	89 c7                	mov    %eax,%edi
	req->version = malloc(version_len + 1);
  800190:	83 ec 0c             	sub    $0xc,%esp
  800193:	8d 40 01             	lea    0x1(%eax),%eax
  800196:	50                   	push   %eax
  800197:	e8 79 22 00 00       	call   802415 <malloc>
  80019c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	memmove(req->version, version, version_len);
  80019f:	83 c4 0c             	add    $0xc,%esp
  8001a2:	57                   	push   %edi
  8001a3:	53                   	push   %ebx
  8001a4:	50                   	push   %eax
  8001a5:	e8 68 0f 00 00       	call   801112 <memmove>
	req->version[version_len] = '\0';
  8001aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ad:	c6 04 38 00          	movb   $0x0,(%eax,%edi,1)
	if((fd = open(req->url, O_RDONLY)) < 0){
  8001b1:	83 c4 08             	add    $0x8,%esp
  8001b4:	6a 00                	push   $0x0
  8001b6:	ff 75 e0             	pushl  -0x20(%ebp)
  8001b9:	e8 42 1c 00 00       	call   801e00 <open>
  8001be:	89 c3                	mov    %eax,%ebx
  8001c0:	83 c4 10             	add    $0x10,%esp
  8001c3:	85 c0                	test   %eax,%eax
  8001c5:	78 39                	js     800200 <handle_client+0x140>
	fstat(fd, &stat);
  8001c7:	83 ec 08             	sub    $0x8,%esp
  8001ca:	8d 85 c4 fc ff ff    	lea    -0x33c(%ebp),%eax
  8001d0:	50                   	push   %eax
  8001d1:	53                   	push   %ebx
  8001d2:	e8 a0 19 00 00       	call   801b77 <fstat>
	if (stat.st_isdir) {
  8001d7:	83 c4 10             	add    $0x10,%esp
	struct responce_header *h = headers;
  8001da:	bf 10 40 80 00       	mov    $0x804010,%edi
	if (stat.st_isdir) {
  8001df:	83 bd 48 fd ff ff 00 	cmpl   $0x0,-0x2b8(%ebp)
  8001e6:	75 57                	jne    80023f <handle_client+0x17f>
	while (h->code != 0 && h->header!= 0) {
  8001e8:	8b 07                	mov    (%edi),%eax
  8001ea:	85 c0                	test   %eax,%eax
  8001ec:	74 1f                	je     80020d <handle_client+0x14d>
		if (h->code == code)
  8001ee:	83 7f 04 00          	cmpl   $0x0,0x4(%edi)
  8001f2:	74 5a                	je     80024e <handle_client+0x18e>
  8001f4:	3d c8 00 00 00       	cmp    $0xc8,%eax
  8001f9:	74 53                	je     80024e <handle_client+0x18e>
		h++;
  8001fb:	83 c7 08             	add    $0x8,%edi
  8001fe:	eb e8                	jmp    8001e8 <handle_client+0x128>
		send_error(req, 404);
  800200:	ba 94 01 00 00       	mov    $0x194,%edx
  800205:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800208:	e8 41 fe ff ff       	call   80004e <send_error>
	close(fd);
  80020d:	83 ec 0c             	sub    $0xc,%esp
  800210:	53                   	push   %ebx
  800211:	e8 0b 16 00 00       	call   801821 <close>
	return r;
  800216:	83 c4 10             	add    $0x10,%esp
	free(req->url);
  800219:	83 ec 0c             	sub    $0xc,%esp
  80021c:	ff 75 e0             	pushl  -0x20(%ebp)
  80021f:	e8 41 21 00 00       	call   802365 <free>
	free(req->version);
  800224:	83 c4 04             	add    $0x4,%esp
  800227:	ff 75 e4             	pushl  -0x1c(%ebp)
  80022a:	e8 36 21 00 00       	call   802365 <free>

		// no keep alive
		break;
	}

	close(sock);
  80022f:	89 34 24             	mov    %esi,(%esp)
  800232:	e8 ea 15 00 00       	call   801821 <close>
}
  800237:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80023a:	5b                   	pop    %ebx
  80023b:	5e                   	pop    %esi
  80023c:	5f                   	pop    %edi
  80023d:	5d                   	pop    %ebp
  80023e:	c3                   	ret    
		send_error(req, 404);
  80023f:	ba 94 01 00 00       	mov    $0x194,%edx
  800244:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800247:	e8 02 fe ff ff       	call   80004e <send_error>
		goto end;
  80024c:	eb bf                	jmp    80020d <handle_client+0x14d>
	int len = strlen(h->header);
  80024e:	83 ec 0c             	sub    $0xc,%esp
  800251:	ff 77 04             	pushl  0x4(%edi)
  800254:	e8 c0 0c 00 00       	call   800f19 <strlen>
	if (write(req->sock, h->header, len) != len) {
  800259:	83 c4 0c             	add    $0xc,%esp
  80025c:	89 85 b4 fc ff ff    	mov    %eax,-0x34c(%ebp)
  800262:	50                   	push   %eax
  800263:	ff 77 04             	pushl  0x4(%edi)
  800266:	ff 75 dc             	pushl  -0x24(%ebp)
  800269:	e8 d3 17 00 00       	call   801a41 <write>
  80026e:	83 c4 10             	add    $0x10,%esp
  800271:	39 85 b4 fc ff ff    	cmp    %eax,-0x34c(%ebp)
  800277:	0f 85 1b 01 00 00    	jne    800398 <handle_client+0x2d8>
	r = snprintf(buf, 64, "Content-Length: %ld\r\n", (long)size);
  80027d:	6a ff                	push   $0xffffffff
  80027f:	68 32 2f 80 00       	push   $0x802f32
  800284:	6a 40                	push   $0x40
  800286:	8d 85 50 fd ff ff    	lea    -0x2b0(%ebp),%eax
  80028c:	50                   	push   %eax
  80028d:	e8 69 0c 00 00       	call   800efb <snprintf>
  800292:	89 c7                	mov    %eax,%edi
	if (r > 63)
  800294:	83 c4 10             	add    $0x10,%esp
  800297:	83 f8 3f             	cmp    $0x3f,%eax
  80029a:	0f 8f 07 01 00 00    	jg     8003a7 <handle_client+0x2e7>
	if (write(req->sock, buf, r) != r)
  8002a0:	83 ec 04             	sub    $0x4,%esp
  8002a3:	57                   	push   %edi
  8002a4:	8d 85 50 fd ff ff    	lea    -0x2b0(%ebp),%eax
  8002aa:	50                   	push   %eax
  8002ab:	ff 75 dc             	pushl  -0x24(%ebp)
  8002ae:	e8 8e 17 00 00       	call   801a41 <write>
	if ((r = send_size(req, file_size)) < 0)
  8002b3:	83 c4 10             	add    $0x10,%esp
  8002b6:	39 c7                	cmp    %eax,%edi
  8002b8:	0f 85 4f ff ff ff    	jne    80020d <handle_client+0x14d>
	r = snprintf(buf, 128, "Content-Type: %s\r\n", type);
  8002be:	68 f7 2e 80 00       	push   $0x802ef7
  8002c3:	68 01 2f 80 00       	push   $0x802f01
  8002c8:	68 80 00 00 00       	push   $0x80
  8002cd:	8d 85 50 fd ff ff    	lea    -0x2b0(%ebp),%eax
  8002d3:	50                   	push   %eax
  8002d4:	e8 22 0c 00 00       	call   800efb <snprintf>
  8002d9:	89 c7                	mov    %eax,%edi
	if (r > 127)
  8002db:	83 c4 10             	add    $0x10,%esp
  8002de:	83 f8 7f             	cmp    $0x7f,%eax
  8002e1:	0f 8f d4 00 00 00    	jg     8003bb <handle_client+0x2fb>
	if (write(req->sock, buf, r) != r)
  8002e7:	83 ec 04             	sub    $0x4,%esp
  8002ea:	50                   	push   %eax
  8002eb:	8d 85 50 fd ff ff    	lea    -0x2b0(%ebp),%eax
  8002f1:	50                   	push   %eax
  8002f2:	ff 75 dc             	pushl  -0x24(%ebp)
  8002f5:	e8 47 17 00 00       	call   801a41 <write>
	if ((r = send_content_type(req)) < 0)
  8002fa:	83 c4 10             	add    $0x10,%esp
  8002fd:	39 c7                	cmp    %eax,%edi
  8002ff:	0f 85 08 ff ff ff    	jne    80020d <handle_client+0x14d>
	int fin_len = strlen(fin);
  800305:	83 ec 0c             	sub    $0xc,%esp
  800308:	68 45 2f 80 00       	push   $0x802f45
  80030d:	e8 07 0c 00 00       	call   800f19 <strlen>
  800312:	89 c7                	mov    %eax,%edi
	if (write(req->sock, fin, fin_len) != fin_len)
  800314:	83 c4 0c             	add    $0xc,%esp
  800317:	50                   	push   %eax
  800318:	68 45 2f 80 00       	push   $0x802f45
  80031d:	ff 75 dc             	pushl  -0x24(%ebp)
  800320:	e8 1c 17 00 00       	call   801a41 <write>
	if ((r = send_header_fin(req)) < 0)
  800325:	83 c4 10             	add    $0x10,%esp
  800328:	39 c7                	cmp    %eax,%edi
  80032a:	0f 85 dd fe ff ff    	jne    80020d <handle_client+0x14d>
	fstat(fd, &stat);
  800330:	83 ec 08             	sub    $0x8,%esp
  800333:	8d 85 50 fd ff ff    	lea    -0x2b0(%ebp),%eax
  800339:	50                   	push   %eax
  80033a:	53                   	push   %ebx
  80033b:	e8 37 18 00 00       	call   801b77 <fstat>
	void *buf = malloc(stat.st_size);
  800340:	83 c4 04             	add    $0x4,%esp
  800343:	ff b5 d0 fd ff ff    	pushl  -0x230(%ebp)
  800349:	e8 c7 20 00 00       	call   802415 <malloc>
  80034e:	89 c7                	mov    %eax,%edi
	if (readn(fd, buf, stat.st_size) != stat.st_size) {
  800350:	83 c4 0c             	add    $0xc,%esp
  800353:	ff b5 d0 fd ff ff    	pushl  -0x230(%ebp)
  800359:	50                   	push   %eax
  80035a:	53                   	push   %ebx
  80035b:	e8 96 16 00 00       	call   8019f6 <readn>
  800360:	89 c2                	mov    %eax,%edx
  800362:	8b 85 d0 fd ff ff    	mov    -0x230(%ebp),%eax
  800368:	83 c4 10             	add    $0x10,%esp
  80036b:	39 c2                	cmp    %eax,%edx
  80036d:	75 63                	jne    8003d2 <handle_client+0x312>
  	if (write(req->sock, buf, stat.st_size) != stat.st_size) {
  80036f:	83 ec 04             	sub    $0x4,%esp
  800372:	50                   	push   %eax
  800373:	57                   	push   %edi
  800374:	ff 75 dc             	pushl  -0x24(%ebp)
  800377:	e8 c5 16 00 00       	call   801a41 <write>
  80037c:	83 c4 10             	add    $0x10,%esp
  80037f:	3b 85 d0 fd ff ff    	cmp    -0x230(%ebp),%eax
  800385:	75 5f                	jne    8003e6 <handle_client+0x326>
	free(buf);
  800387:	83 ec 0c             	sub    $0xc,%esp
  80038a:	57                   	push   %edi
  80038b:	e8 d5 1f 00 00       	call   802365 <free>
  800390:	83 c4 10             	add    $0x10,%esp
  800393:	e9 75 fe ff ff       	jmp    80020d <handle_client+0x14d>
		die("Failed to send bytes to client");
  800398:	b8 fc 2f 80 00       	mov    $0x802ffc,%eax
  80039d:	e8 91 fc ff ff       	call   800033 <die>
  8003a2:	e9 d6 fe ff ff       	jmp    80027d <handle_client+0x1bd>
		panic("buffer too small!");
  8003a7:	83 ec 04             	sub    $0x4,%esp
  8003aa:	68 e5 2e 80 00       	push   $0x802ee5
  8003af:	6a 69                	push   $0x69
  8003b1:	68 d3 2e 80 00       	push   $0x802ed3
  8003b6:	e8 b0 04 00 00       	call   80086b <_panic>
		panic("buffer too small!");
  8003bb:	83 ec 04             	sub    $0x4,%esp
  8003be:	68 e5 2e 80 00       	push   $0x802ee5
  8003c3:	68 85 00 00 00       	push   $0x85
  8003c8:	68 d3 2e 80 00       	push   $0x802ed3
  8003cd:	e8 99 04 00 00       	call   80086b <_panic>
		panic("Failed to read requested file");
  8003d2:	83 ec 04             	sub    $0x4,%esp
  8003d5:	68 14 2f 80 00       	push   $0x802f14
  8003da:	6a 56                	push   $0x56
  8003dc:	68 d3 2e 80 00       	push   $0x802ed3
  8003e1:	e8 85 04 00 00       	call   80086b <_panic>
		panic("Failed to send bytes to client");
  8003e6:	83 ec 04             	sub    $0x4,%esp
  8003e9:	68 fc 2f 80 00       	push   $0x802ffc
  8003ee:	6a 5b                	push   $0x5b
  8003f0:	68 d3 2e 80 00       	push   $0x802ed3
  8003f5:	e8 71 04 00 00       	call   80086b <_panic>
			send_error(req, 400);
  8003fa:	ba 90 01 00 00       	mov    $0x190,%edx
  8003ff:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800402:	e8 47 fc ff ff       	call   80004e <send_error>
  800407:	e9 0d fe ff ff       	jmp    800219 <handle_client+0x159>

0080040c <umain>:

void
umain(int argc, char **argv)
{
  80040c:	f3 0f 1e fb          	endbr32 
  800410:	55                   	push   %ebp
  800411:	89 e5                	mov    %esp,%ebp
  800413:	57                   	push   %edi
  800414:	56                   	push   %esi
  800415:	53                   	push   %ebx
  800416:	83 ec 40             	sub    $0x40,%esp
	int serversock, clientsock;
	struct sockaddr_in server, client;

	binaryname = "jhttpd";
  800419:	c7 05 20 40 80 00 48 	movl   $0x802f48,0x804020
  800420:	2f 80 00 

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  800423:	6a 06                	push   $0x6
  800425:	6a 01                	push   $0x1
  800427:	6a 02                	push   $0x2
  800429:	e8 8c 1c 00 00       	call   8020ba <socket>
  80042e:	89 c6                	mov    %eax,%esi
  800430:	83 c4 10             	add    $0x10,%esp
  800433:	85 c0                	test   %eax,%eax
  800435:	78 6d                	js     8004a4 <umain+0x98>
		die("Failed to create socket");

	// Construct the server sockaddr_in structure
	memset(&server, 0, sizeof(server));		// Clear struct
  800437:	83 ec 04             	sub    $0x4,%esp
  80043a:	6a 10                	push   $0x10
  80043c:	6a 00                	push   $0x0
  80043e:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  800441:	53                   	push   %ebx
  800442:	e8 7f 0c 00 00       	call   8010c6 <memset>
	server.sin_family = AF_INET;			// Internet/IP
  800447:	c6 45 d9 02          	movb   $0x2,-0x27(%ebp)
	server.sin_addr.s_addr = htonl(INADDR_ANY);	// IP address
  80044b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800452:	e8 68 01 00 00       	call   8005bf <htonl>
  800457:	89 45 dc             	mov    %eax,-0x24(%ebp)
	server.sin_port = htons(PORT);			// server port
  80045a:	c7 04 24 50 00 00 00 	movl   $0x50,(%esp)
  800461:	e8 37 01 00 00       	call   80059d <htons>
  800466:	66 89 45 da          	mov    %ax,-0x26(%ebp)

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &server,
  80046a:	83 c4 0c             	add    $0xc,%esp
  80046d:	6a 10                	push   $0x10
  80046f:	53                   	push   %ebx
  800470:	56                   	push   %esi
  800471:	e8 a2 1b 00 00       	call   802018 <bind>
  800476:	83 c4 10             	add    $0x10,%esp
  800479:	85 c0                	test   %eax,%eax
  80047b:	78 33                	js     8004b0 <umain+0xa4>
	{
		die("Failed to bind the server socket");
	}

	// Listen on the server socket
	if (listen(serversock, MAXPENDING) < 0)
  80047d:	83 ec 08             	sub    $0x8,%esp
  800480:	6a 05                	push   $0x5
  800482:	56                   	push   %esi
  800483:	e8 0b 1c 00 00       	call   802093 <listen>
  800488:	83 c4 10             	add    $0x10,%esp
  80048b:	85 c0                	test   %eax,%eax
  80048d:	78 2d                	js     8004bc <umain+0xb0>
		die("Failed to listen on server socket");

	cprintf("Waiting for http connections...\n");
  80048f:	83 ec 0c             	sub    $0xc,%esp
  800492:	68 64 30 80 00       	push   $0x803064
  800497:	e8 b6 04 00 00       	call   800952 <cprintf>
  80049c:	83 c4 10             	add    $0x10,%esp

	while (1) {
		unsigned int clientlen = sizeof(client);
		// Wait for client connection
		if ((clientsock = accept(serversock,
  80049f:	8d 7d c4             	lea    -0x3c(%ebp),%edi
  8004a2:	eb 35                	jmp    8004d9 <umain+0xcd>
		die("Failed to create socket");
  8004a4:	b8 4f 2f 80 00       	mov    $0x802f4f,%eax
  8004a9:	e8 85 fb ff ff       	call   800033 <die>
  8004ae:	eb 87                	jmp    800437 <umain+0x2b>
		die("Failed to bind the server socket");
  8004b0:	b8 1c 30 80 00       	mov    $0x80301c,%eax
  8004b5:	e8 79 fb ff ff       	call   800033 <die>
  8004ba:	eb c1                	jmp    80047d <umain+0x71>
		die("Failed to listen on server socket");
  8004bc:	b8 40 30 80 00       	mov    $0x803040,%eax
  8004c1:	e8 6d fb ff ff       	call   800033 <die>
  8004c6:	eb c7                	jmp    80048f <umain+0x83>
					 (struct sockaddr *) &client,
					 &clientlen)) < 0)
		{
			die("Failed to accept client connection");
  8004c8:	b8 88 30 80 00       	mov    $0x803088,%eax
  8004cd:	e8 61 fb ff ff       	call   800033 <die>
		}
		handle_client(clientsock);
  8004d2:	89 d8                	mov    %ebx,%eax
  8004d4:	e8 e7 fb ff ff       	call   8000c0 <handle_client>
		unsigned int clientlen = sizeof(client);
  8004d9:	c7 45 c4 10 00 00 00 	movl   $0x10,-0x3c(%ebp)
		if ((clientsock = accept(serversock,
  8004e0:	83 ec 04             	sub    $0x4,%esp
  8004e3:	57                   	push   %edi
  8004e4:	8d 45 c8             	lea    -0x38(%ebp),%eax
  8004e7:	50                   	push   %eax
  8004e8:	56                   	push   %esi
  8004e9:	e8 f7 1a 00 00       	call   801fe5 <accept>
  8004ee:	89 c3                	mov    %eax,%ebx
  8004f0:	83 c4 10             	add    $0x10,%esp
  8004f3:	85 c0                	test   %eax,%eax
  8004f5:	78 d1                	js     8004c8 <umain+0xbc>
  8004f7:	eb d9                	jmp    8004d2 <umain+0xc6>

008004f9 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  8004f9:	f3 0f 1e fb          	endbr32 
  8004fd:	55                   	push   %ebp
  8004fe:	89 e5                	mov    %esp,%ebp
  800500:	57                   	push   %edi
  800501:	56                   	push   %esi
  800502:	53                   	push   %ebx
  800503:	83 ec 18             	sub    $0x18,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  800506:	8b 45 08             	mov    0x8(%ebp),%eax
  800509:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  80050c:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  ap = (u8_t *)&s_addr;
  800510:	8d 75 f0             	lea    -0x10(%ebp),%esi
  rp = str;
  800513:	bf 00 50 80 00       	mov    $0x805000,%edi
  800518:	eb 2e                	jmp    800548 <inet_ntoa+0x4f>
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
  80051a:	0f b6 c8             	movzbl %al,%ecx
  80051d:	0f b6 4c 0d ed       	movzbl -0x13(%ebp,%ecx,1),%ecx
  800522:	88 0a                	mov    %cl,(%edx)
  800524:	83 c2 01             	add    $0x1,%edx
    while(i--)
  800527:	83 e8 01             	sub    $0x1,%eax
  80052a:	3c ff                	cmp    $0xff,%al
  80052c:	75 ec                	jne    80051a <inet_ntoa+0x21>
  80052e:	0f b6 db             	movzbl %bl,%ebx
  800531:	01 fb                	add    %edi,%ebx
    *rp++ = '.';
  800533:	8d 7b 01             	lea    0x1(%ebx),%edi
  800536:	c6 03 2e             	movb   $0x2e,(%ebx)
  800539:	83 c6 01             	add    $0x1,%esi
  for(n = 0; n < 4; n++) {
  80053c:	80 45 df 01          	addb   $0x1,-0x21(%ebp)
  800540:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  800544:	3c 04                	cmp    $0x4,%al
  800546:	74 45                	je     80058d <inet_ntoa+0x94>
  rp = str;
  800548:	bb 00 00 00 00       	mov    $0x0,%ebx
      rem = *ap % (u8_t)10;
  80054d:	0f b6 16             	movzbl (%esi),%edx
      *ap /= (u8_t)10;
  800550:	0f b6 ca             	movzbl %dl,%ecx
  800553:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  800556:	8d 04 c1             	lea    (%ecx,%eax,8),%eax
  800559:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80055c:	66 c1 e8 0b          	shr    $0xb,%ax
  800560:	88 06                	mov    %al,(%esi)
  800562:	89 d9                	mov    %ebx,%ecx
      inv[i++] = '0' + rem;
  800564:	83 c3 01             	add    $0x1,%ebx
  800567:	0f b6 c9             	movzbl %cl,%ecx
  80056a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
      rem = *ap % (u8_t)10;
  80056d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800570:	01 c0                	add    %eax,%eax
  800572:	89 d1                	mov    %edx,%ecx
  800574:	29 c1                	sub    %eax,%ecx
  800576:	89 c8                	mov    %ecx,%eax
      inv[i++] = '0' + rem;
  800578:	83 c0 30             	add    $0x30,%eax
  80057b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80057e:	88 44 0d ed          	mov    %al,-0x13(%ebp,%ecx,1)
    } while(*ap);
  800582:	80 fa 09             	cmp    $0x9,%dl
  800585:	77 c6                	ja     80054d <inet_ntoa+0x54>
  800587:	89 fa                	mov    %edi,%edx
      inv[i++] = '0' + rem;
  800589:	89 d8                	mov    %ebx,%eax
  80058b:	eb 9a                	jmp    800527 <inet_ntoa+0x2e>
    ap++;
  }
  *--rp = 0;
  80058d:	c6 03 00             	movb   $0x0,(%ebx)
  return str;
}
  800590:	b8 00 50 80 00       	mov    $0x805000,%eax
  800595:	83 c4 18             	add    $0x18,%esp
  800598:	5b                   	pop    %ebx
  800599:	5e                   	pop    %esi
  80059a:	5f                   	pop    %edi
  80059b:	5d                   	pop    %ebp
  80059c:	c3                   	ret    

0080059d <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  80059d:	f3 0f 1e fb          	endbr32 
  8005a1:	55                   	push   %ebp
  8005a2:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8005a4:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8005a8:	66 c1 c0 08          	rol    $0x8,%ax
}
  8005ac:	5d                   	pop    %ebp
  8005ad:	c3                   	ret    

008005ae <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  8005ae:	f3 0f 1e fb          	endbr32 
  8005b2:	55                   	push   %ebp
  8005b3:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8005b5:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8005b9:	66 c1 c0 08          	rol    $0x8,%ax
  return htons(n);
}
  8005bd:	5d                   	pop    %ebp
  8005be:	c3                   	ret    

008005bf <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  8005bf:	f3 0f 1e fb          	endbr32 
  8005c3:	55                   	push   %ebp
  8005c4:	89 e5                	mov    %esp,%ebp
  8005c6:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
  8005c9:	89 d0                	mov    %edx,%eax
  8005cb:	c1 e0 18             	shl    $0x18,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  8005ce:	89 d1                	mov    %edx,%ecx
  8005d0:	c1 e9 18             	shr    $0x18,%ecx
    ((n & 0xff0000UL) >> 8) |
  8005d3:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  8005d5:	89 d1                	mov    %edx,%ecx
  8005d7:	c1 e1 08             	shl    $0x8,%ecx
  8005da:	81 e1 00 00 ff 00    	and    $0xff0000,%ecx
    ((n & 0xff0000UL) >> 8) |
  8005e0:	09 c8                	or     %ecx,%eax
  8005e2:	c1 ea 08             	shr    $0x8,%edx
  8005e5:	81 e2 00 ff 00 00    	and    $0xff00,%edx
  8005eb:	09 d0                	or     %edx,%eax
}
  8005ed:	5d                   	pop    %ebp
  8005ee:	c3                   	ret    

008005ef <inet_aton>:
{
  8005ef:	f3 0f 1e fb          	endbr32 
  8005f3:	55                   	push   %ebp
  8005f4:	89 e5                	mov    %esp,%ebp
  8005f6:	57                   	push   %edi
  8005f7:	56                   	push   %esi
  8005f8:	53                   	push   %ebx
  8005f9:	83 ec 2c             	sub    $0x2c,%esp
  8005fc:	8b 55 08             	mov    0x8(%ebp),%edx
  c = *cp;
  8005ff:	0f be 02             	movsbl (%edx),%eax
  u32_t *pp = parts;
  800602:	8d 75 d8             	lea    -0x28(%ebp),%esi
  800605:	89 75 cc             	mov    %esi,-0x34(%ebp)
  800608:	e9 a7 00 00 00       	jmp    8006b4 <inet_aton+0xc5>
      c = *++cp;
  80060d:	0f b6 42 01          	movzbl 0x1(%edx),%eax
      if (c == 'x' || c == 'X') {
  800611:	89 c1                	mov    %eax,%ecx
  800613:	83 e1 df             	and    $0xffffffdf,%ecx
  800616:	80 f9 58             	cmp    $0x58,%cl
  800619:	74 10                	je     80062b <inet_aton+0x3c>
      c = *++cp;
  80061b:	83 c2 01             	add    $0x1,%edx
  80061e:	0f be c0             	movsbl %al,%eax
        base = 8;
  800621:	be 08 00 00 00       	mov    $0x8,%esi
  800626:	e9 a3 00 00 00       	jmp    8006ce <inet_aton+0xdf>
        c = *++cp;
  80062b:	0f be 42 02          	movsbl 0x2(%edx),%eax
  80062f:	8d 52 02             	lea    0x2(%edx),%edx
        base = 16;
  800632:	be 10 00 00 00       	mov    $0x10,%esi
  800637:	e9 92 00 00 00       	jmp    8006ce <inet_aton+0xdf>
      } else if (base == 16 && isxdigit(c)) {
  80063c:	83 fe 10             	cmp    $0x10,%esi
  80063f:	75 4d                	jne    80068e <inet_aton+0x9f>
  800641:	8d 4f 9f             	lea    -0x61(%edi),%ecx
  800644:	88 4d d3             	mov    %cl,-0x2d(%ebp)
  800647:	89 c1                	mov    %eax,%ecx
  800649:	83 e1 df             	and    $0xffffffdf,%ecx
  80064c:	83 e9 41             	sub    $0x41,%ecx
  80064f:	80 f9 05             	cmp    $0x5,%cl
  800652:	77 3a                	ja     80068e <inet_aton+0x9f>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  800654:	c1 e3 04             	shl    $0x4,%ebx
  800657:	83 c0 0a             	add    $0xa,%eax
  80065a:	80 7d d3 1a          	cmpb   $0x1a,-0x2d(%ebp)
  80065e:	19 c9                	sbb    %ecx,%ecx
  800660:	83 e1 20             	and    $0x20,%ecx
  800663:	83 c1 41             	add    $0x41,%ecx
  800666:	29 c8                	sub    %ecx,%eax
  800668:	09 c3                	or     %eax,%ebx
        c = *++cp;
  80066a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80066d:	0f be 40 01          	movsbl 0x1(%eax),%eax
  800671:	83 c2 01             	add    $0x1,%edx
  800674:	89 55 d4             	mov    %edx,-0x2c(%ebp)
      if (isdigit(c)) {
  800677:	89 c7                	mov    %eax,%edi
  800679:	8d 48 d0             	lea    -0x30(%eax),%ecx
  80067c:	80 f9 09             	cmp    $0x9,%cl
  80067f:	77 bb                	ja     80063c <inet_aton+0x4d>
        val = (val * base) + (int)(c - '0');
  800681:	0f af de             	imul   %esi,%ebx
  800684:	8d 5c 18 d0          	lea    -0x30(%eax,%ebx,1),%ebx
        c = *++cp;
  800688:	0f be 42 01          	movsbl 0x1(%edx),%eax
  80068c:	eb e3                	jmp    800671 <inet_aton+0x82>
    if (c == '.') {
  80068e:	83 f8 2e             	cmp    $0x2e,%eax
  800691:	75 42                	jne    8006d5 <inet_aton+0xe6>
      if (pp >= parts + 3)
  800693:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800696:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800699:	39 c6                	cmp    %eax,%esi
  80069b:	0f 84 16 01 00 00    	je     8007b7 <inet_aton+0x1c8>
      *pp++ = val;
  8006a1:	83 c6 04             	add    $0x4,%esi
  8006a4:	89 75 cc             	mov    %esi,-0x34(%ebp)
  8006a7:	89 5e fc             	mov    %ebx,-0x4(%esi)
      c = *++cp;
  8006aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006ad:	8d 50 01             	lea    0x1(%eax),%edx
  8006b0:	0f be 40 01          	movsbl 0x1(%eax),%eax
    if (!isdigit(c))
  8006b4:	8d 48 d0             	lea    -0x30(%eax),%ecx
  8006b7:	80 f9 09             	cmp    $0x9,%cl
  8006ba:	0f 87 f0 00 00 00    	ja     8007b0 <inet_aton+0x1c1>
    base = 10;
  8006c0:	be 0a 00 00 00       	mov    $0xa,%esi
    if (c == '0') {
  8006c5:	83 f8 30             	cmp    $0x30,%eax
  8006c8:	0f 84 3f ff ff ff    	je     80060d <inet_aton+0x1e>
    base = 10;
  8006ce:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006d3:	eb 9f                	jmp    800674 <inet_aton+0x85>
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8006d5:	85 c0                	test   %eax,%eax
  8006d7:	74 29                	je     800702 <inet_aton+0x113>
    return (0);
  8006d9:	ba 00 00 00 00       	mov    $0x0,%edx
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8006de:	89 f9                	mov    %edi,%ecx
  8006e0:	80 f9 1f             	cmp    $0x1f,%cl
  8006e3:	0f 86 d3 00 00 00    	jbe    8007bc <inet_aton+0x1cd>
  8006e9:	84 c0                	test   %al,%al
  8006eb:	0f 88 cb 00 00 00    	js     8007bc <inet_aton+0x1cd>
  8006f1:	83 f8 20             	cmp    $0x20,%eax
  8006f4:	74 0c                	je     800702 <inet_aton+0x113>
  8006f6:	83 e8 09             	sub    $0x9,%eax
  8006f9:	83 f8 04             	cmp    $0x4,%eax
  8006fc:	0f 87 ba 00 00 00    	ja     8007bc <inet_aton+0x1cd>
  n = pp - parts + 1;
  800702:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800705:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800708:	29 c6                	sub    %eax,%esi
  80070a:	89 f0                	mov    %esi,%eax
  80070c:	c1 f8 02             	sar    $0x2,%eax
  80070f:	8d 50 01             	lea    0x1(%eax),%edx
  switch (n) {
  800712:	83 f8 02             	cmp    $0x2,%eax
  800715:	74 7a                	je     800791 <inet_aton+0x1a2>
  800717:	83 fa 03             	cmp    $0x3,%edx
  80071a:	7f 49                	jg     800765 <inet_aton+0x176>
  80071c:	85 d2                	test   %edx,%edx
  80071e:	0f 84 98 00 00 00    	je     8007bc <inet_aton+0x1cd>
  800724:	83 fa 02             	cmp    $0x2,%edx
  800727:	75 19                	jne    800742 <inet_aton+0x153>
      return (0);
  800729:	ba 00 00 00 00       	mov    $0x0,%edx
    if (val > 0xffffffUL)
  80072e:	81 fb ff ff ff 00    	cmp    $0xffffff,%ebx
  800734:	0f 87 82 00 00 00    	ja     8007bc <inet_aton+0x1cd>
    val |= parts[0] << 24;
  80073a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80073d:	c1 e0 18             	shl    $0x18,%eax
  800740:	09 c3                	or     %eax,%ebx
  return (1);
  800742:	ba 01 00 00 00       	mov    $0x1,%edx
  if (addr)
  800747:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80074b:	74 6f                	je     8007bc <inet_aton+0x1cd>
    addr->s_addr = htonl(val);
  80074d:	83 ec 0c             	sub    $0xc,%esp
  800750:	53                   	push   %ebx
  800751:	e8 69 fe ff ff       	call   8005bf <htonl>
  800756:	83 c4 10             	add    $0x10,%esp
  800759:	8b 75 0c             	mov    0xc(%ebp),%esi
  80075c:	89 06                	mov    %eax,(%esi)
  return (1);
  80075e:	ba 01 00 00 00       	mov    $0x1,%edx
  800763:	eb 57                	jmp    8007bc <inet_aton+0x1cd>
  switch (n) {
  800765:	83 fa 04             	cmp    $0x4,%edx
  800768:	75 d8                	jne    800742 <inet_aton+0x153>
      return (0);
  80076a:	ba 00 00 00 00       	mov    $0x0,%edx
    if (val > 0xff)
  80076f:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
  800775:	77 45                	ja     8007bc <inet_aton+0x1cd>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  800777:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80077a:	c1 e0 18             	shl    $0x18,%eax
  80077d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800780:	c1 e2 10             	shl    $0x10,%edx
  800783:	09 d0                	or     %edx,%eax
  800785:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800788:	c1 e2 08             	shl    $0x8,%edx
  80078b:	09 d0                	or     %edx,%eax
  80078d:	09 c3                	or     %eax,%ebx
    break;
  80078f:	eb b1                	jmp    800742 <inet_aton+0x153>
      return (0);
  800791:	ba 00 00 00 00       	mov    $0x0,%edx
    if (val > 0xffff)
  800796:	81 fb ff ff 00 00    	cmp    $0xffff,%ebx
  80079c:	77 1e                	ja     8007bc <inet_aton+0x1cd>
    val |= (parts[0] << 24) | (parts[1] << 16);
  80079e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007a1:	c1 e0 18             	shl    $0x18,%eax
  8007a4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8007a7:	c1 e2 10             	shl    $0x10,%edx
  8007aa:	09 d0                	or     %edx,%eax
  8007ac:	09 c3                	or     %eax,%ebx
    break;
  8007ae:	eb 92                	jmp    800742 <inet_aton+0x153>
      return (0);
  8007b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b5:	eb 05                	jmp    8007bc <inet_aton+0x1cd>
        return (0);
  8007b7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007bc:	89 d0                	mov    %edx,%eax
  8007be:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007c1:	5b                   	pop    %ebx
  8007c2:	5e                   	pop    %esi
  8007c3:	5f                   	pop    %edi
  8007c4:	5d                   	pop    %ebp
  8007c5:	c3                   	ret    

008007c6 <inet_addr>:
{
  8007c6:	f3 0f 1e fb          	endbr32 
  8007ca:	55                   	push   %ebp
  8007cb:	89 e5                	mov    %esp,%ebp
  8007cd:	83 ec 20             	sub    $0x20,%esp
  if (inet_aton(cp, &val)) {
  8007d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007d3:	50                   	push   %eax
  8007d4:	ff 75 08             	pushl  0x8(%ebp)
  8007d7:	e8 13 fe ff ff       	call   8005ef <inet_aton>
  8007dc:	83 c4 10             	add    $0x10,%esp
    return (val.s_addr);
  8007df:	85 c0                	test   %eax,%eax
  8007e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8007e6:	0f 45 45 f4          	cmovne -0xc(%ebp),%eax
}
  8007ea:	c9                   	leave  
  8007eb:	c3                   	ret    

008007ec <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  8007ec:	f3 0f 1e fb          	endbr32 
  8007f0:	55                   	push   %ebp
  8007f1:	89 e5                	mov    %esp,%ebp
  8007f3:	83 ec 14             	sub    $0x14,%esp
  return htonl(n);
  8007f6:	ff 75 08             	pushl  0x8(%ebp)
  8007f9:	e8 c1 fd ff ff       	call   8005bf <htonl>
  8007fe:	83 c4 10             	add    $0x10,%esp
}
  800801:	c9                   	leave  
  800802:	c3                   	ret    

00800803 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800803:	f3 0f 1e fb          	endbr32 
  800807:	55                   	push   %ebp
  800808:	89 e5                	mov    %esp,%ebp
  80080a:	56                   	push   %esi
  80080b:	53                   	push   %ebx
  80080c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80080f:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800812:	e8 41 0b 00 00       	call   801358 <sys_getenvid>
  800817:	25 ff 03 00 00       	and    $0x3ff,%eax
  80081c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80081f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800824:	a3 1c 50 80 00       	mov    %eax,0x80501c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800829:	85 db                	test   %ebx,%ebx
  80082b:	7e 07                	jle    800834 <libmain+0x31>
		binaryname = argv[0];
  80082d:	8b 06                	mov    (%esi),%eax
  80082f:	a3 20 40 80 00       	mov    %eax,0x804020

	// call user main routine
	umain(argc, argv);
  800834:	83 ec 08             	sub    $0x8,%esp
  800837:	56                   	push   %esi
  800838:	53                   	push   %ebx
  800839:	e8 ce fb ff ff       	call   80040c <umain>

	// exit gracefully
	exit();
  80083e:	e8 0a 00 00 00       	call   80084d <exit>
}
  800843:	83 c4 10             	add    $0x10,%esp
  800846:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800849:	5b                   	pop    %ebx
  80084a:	5e                   	pop    %esi
  80084b:	5d                   	pop    %ebp
  80084c:	c3                   	ret    

0080084d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80084d:	f3 0f 1e fb          	endbr32 
  800851:	55                   	push   %ebp
  800852:	89 e5                	mov    %esp,%ebp
  800854:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800857:	e8 f6 0f 00 00       	call   801852 <close_all>
	sys_env_destroy(0);
  80085c:	83 ec 0c             	sub    $0xc,%esp
  80085f:	6a 00                	push   $0x0
  800861:	e8 ad 0a 00 00       	call   801313 <sys_env_destroy>
}
  800866:	83 c4 10             	add    $0x10,%esp
  800869:	c9                   	leave  
  80086a:	c3                   	ret    

0080086b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80086b:	f3 0f 1e fb          	endbr32 
  80086f:	55                   	push   %ebp
  800870:	89 e5                	mov    %esp,%ebp
  800872:	56                   	push   %esi
  800873:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800874:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800877:	8b 35 20 40 80 00    	mov    0x804020,%esi
  80087d:	e8 d6 0a 00 00       	call   801358 <sys_getenvid>
  800882:	83 ec 0c             	sub    $0xc,%esp
  800885:	ff 75 0c             	pushl  0xc(%ebp)
  800888:	ff 75 08             	pushl  0x8(%ebp)
  80088b:	56                   	push   %esi
  80088c:	50                   	push   %eax
  80088d:	68 dc 30 80 00       	push   $0x8030dc
  800892:	e8 bb 00 00 00       	call   800952 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800897:	83 c4 18             	add    $0x18,%esp
  80089a:	53                   	push   %ebx
  80089b:	ff 75 10             	pushl  0x10(%ebp)
  80089e:	e8 5a 00 00 00       	call   8008fd <vcprintf>
	cprintf("\n");
  8008a3:	c7 04 24 46 2f 80 00 	movl   $0x802f46,(%esp)
  8008aa:	e8 a3 00 00 00       	call   800952 <cprintf>
  8008af:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8008b2:	cc                   	int3   
  8008b3:	eb fd                	jmp    8008b2 <_panic+0x47>

008008b5 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8008b5:	f3 0f 1e fb          	endbr32 
  8008b9:	55                   	push   %ebp
  8008ba:	89 e5                	mov    %esp,%ebp
  8008bc:	53                   	push   %ebx
  8008bd:	83 ec 04             	sub    $0x4,%esp
  8008c0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8008c3:	8b 13                	mov    (%ebx),%edx
  8008c5:	8d 42 01             	lea    0x1(%edx),%eax
  8008c8:	89 03                	mov    %eax,(%ebx)
  8008ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008cd:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8008d1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008d6:	74 09                	je     8008e1 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8008d8:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8008dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008df:	c9                   	leave  
  8008e0:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8008e1:	83 ec 08             	sub    $0x8,%esp
  8008e4:	68 ff 00 00 00       	push   $0xff
  8008e9:	8d 43 08             	lea    0x8(%ebx),%eax
  8008ec:	50                   	push   %eax
  8008ed:	e8 dc 09 00 00       	call   8012ce <sys_cputs>
		b->idx = 0;
  8008f2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8008f8:	83 c4 10             	add    $0x10,%esp
  8008fb:	eb db                	jmp    8008d8 <putch+0x23>

008008fd <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8008fd:	f3 0f 1e fb          	endbr32 
  800901:	55                   	push   %ebp
  800902:	89 e5                	mov    %esp,%ebp
  800904:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80090a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800911:	00 00 00 
	b.cnt = 0;
  800914:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80091b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80091e:	ff 75 0c             	pushl  0xc(%ebp)
  800921:	ff 75 08             	pushl  0x8(%ebp)
  800924:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80092a:	50                   	push   %eax
  80092b:	68 b5 08 80 00       	push   $0x8008b5
  800930:	e8 20 01 00 00       	call   800a55 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800935:	83 c4 08             	add    $0x8,%esp
  800938:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80093e:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800944:	50                   	push   %eax
  800945:	e8 84 09 00 00       	call   8012ce <sys_cputs>

	return b.cnt;
}
  80094a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800950:	c9                   	leave  
  800951:	c3                   	ret    

00800952 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800952:	f3 0f 1e fb          	endbr32 
  800956:	55                   	push   %ebp
  800957:	89 e5                	mov    %esp,%ebp
  800959:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80095c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80095f:	50                   	push   %eax
  800960:	ff 75 08             	pushl  0x8(%ebp)
  800963:	e8 95 ff ff ff       	call   8008fd <vcprintf>
	va_end(ap);

	return cnt;
}
  800968:	c9                   	leave  
  800969:	c3                   	ret    

0080096a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80096a:	55                   	push   %ebp
  80096b:	89 e5                	mov    %esp,%ebp
  80096d:	57                   	push   %edi
  80096e:	56                   	push   %esi
  80096f:	53                   	push   %ebx
  800970:	83 ec 1c             	sub    $0x1c,%esp
  800973:	89 c7                	mov    %eax,%edi
  800975:	89 d6                	mov    %edx,%esi
  800977:	8b 45 08             	mov    0x8(%ebp),%eax
  80097a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80097d:	89 d1                	mov    %edx,%ecx
  80097f:	89 c2                	mov    %eax,%edx
  800981:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800984:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800987:	8b 45 10             	mov    0x10(%ebp),%eax
  80098a:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80098d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800990:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800997:	39 c2                	cmp    %eax,%edx
  800999:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80099c:	72 3e                	jb     8009dc <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80099e:	83 ec 0c             	sub    $0xc,%esp
  8009a1:	ff 75 18             	pushl  0x18(%ebp)
  8009a4:	83 eb 01             	sub    $0x1,%ebx
  8009a7:	53                   	push   %ebx
  8009a8:	50                   	push   %eax
  8009a9:	83 ec 08             	sub    $0x8,%esp
  8009ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009af:	ff 75 e0             	pushl  -0x20(%ebp)
  8009b2:	ff 75 dc             	pushl  -0x24(%ebp)
  8009b5:	ff 75 d8             	pushl  -0x28(%ebp)
  8009b8:	e8 a3 22 00 00       	call   802c60 <__udivdi3>
  8009bd:	83 c4 18             	add    $0x18,%esp
  8009c0:	52                   	push   %edx
  8009c1:	50                   	push   %eax
  8009c2:	89 f2                	mov    %esi,%edx
  8009c4:	89 f8                	mov    %edi,%eax
  8009c6:	e8 9f ff ff ff       	call   80096a <printnum>
  8009cb:	83 c4 20             	add    $0x20,%esp
  8009ce:	eb 13                	jmp    8009e3 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8009d0:	83 ec 08             	sub    $0x8,%esp
  8009d3:	56                   	push   %esi
  8009d4:	ff 75 18             	pushl  0x18(%ebp)
  8009d7:	ff d7                	call   *%edi
  8009d9:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8009dc:	83 eb 01             	sub    $0x1,%ebx
  8009df:	85 db                	test   %ebx,%ebx
  8009e1:	7f ed                	jg     8009d0 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8009e3:	83 ec 08             	sub    $0x8,%esp
  8009e6:	56                   	push   %esi
  8009e7:	83 ec 04             	sub    $0x4,%esp
  8009ea:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009ed:	ff 75 e0             	pushl  -0x20(%ebp)
  8009f0:	ff 75 dc             	pushl  -0x24(%ebp)
  8009f3:	ff 75 d8             	pushl  -0x28(%ebp)
  8009f6:	e8 75 23 00 00       	call   802d70 <__umoddi3>
  8009fb:	83 c4 14             	add    $0x14,%esp
  8009fe:	0f be 80 ff 30 80 00 	movsbl 0x8030ff(%eax),%eax
  800a05:	50                   	push   %eax
  800a06:	ff d7                	call   *%edi
}
  800a08:	83 c4 10             	add    $0x10,%esp
  800a0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a0e:	5b                   	pop    %ebx
  800a0f:	5e                   	pop    %esi
  800a10:	5f                   	pop    %edi
  800a11:	5d                   	pop    %ebp
  800a12:	c3                   	ret    

00800a13 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a13:	f3 0f 1e fb          	endbr32 
  800a17:	55                   	push   %ebp
  800a18:	89 e5                	mov    %esp,%ebp
  800a1a:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800a1d:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800a21:	8b 10                	mov    (%eax),%edx
  800a23:	3b 50 04             	cmp    0x4(%eax),%edx
  800a26:	73 0a                	jae    800a32 <sprintputch+0x1f>
		*b->buf++ = ch;
  800a28:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a2b:	89 08                	mov    %ecx,(%eax)
  800a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a30:	88 02                	mov    %al,(%edx)
}
  800a32:	5d                   	pop    %ebp
  800a33:	c3                   	ret    

00800a34 <printfmt>:
{
  800a34:	f3 0f 1e fb          	endbr32 
  800a38:	55                   	push   %ebp
  800a39:	89 e5                	mov    %esp,%ebp
  800a3b:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800a3e:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800a41:	50                   	push   %eax
  800a42:	ff 75 10             	pushl  0x10(%ebp)
  800a45:	ff 75 0c             	pushl  0xc(%ebp)
  800a48:	ff 75 08             	pushl  0x8(%ebp)
  800a4b:	e8 05 00 00 00       	call   800a55 <vprintfmt>
}
  800a50:	83 c4 10             	add    $0x10,%esp
  800a53:	c9                   	leave  
  800a54:	c3                   	ret    

00800a55 <vprintfmt>:
{
  800a55:	f3 0f 1e fb          	endbr32 
  800a59:	55                   	push   %ebp
  800a5a:	89 e5                	mov    %esp,%ebp
  800a5c:	57                   	push   %edi
  800a5d:	56                   	push   %esi
  800a5e:	53                   	push   %ebx
  800a5f:	83 ec 3c             	sub    $0x3c,%esp
  800a62:	8b 75 08             	mov    0x8(%ebp),%esi
  800a65:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a68:	8b 7d 10             	mov    0x10(%ebp),%edi
  800a6b:	e9 8e 03 00 00       	jmp    800dfe <vprintfmt+0x3a9>
		padc = ' ';
  800a70:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800a74:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800a7b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800a82:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a89:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800a8e:	8d 47 01             	lea    0x1(%edi),%eax
  800a91:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a94:	0f b6 17             	movzbl (%edi),%edx
  800a97:	8d 42 dd             	lea    -0x23(%edx),%eax
  800a9a:	3c 55                	cmp    $0x55,%al
  800a9c:	0f 87 df 03 00 00    	ja     800e81 <vprintfmt+0x42c>
  800aa2:	0f b6 c0             	movzbl %al,%eax
  800aa5:	3e ff 24 85 40 32 80 	notrack jmp *0x803240(,%eax,4)
  800aac:	00 
  800aad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800ab0:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800ab4:	eb d8                	jmp    800a8e <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800ab6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800ab9:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800abd:	eb cf                	jmp    800a8e <vprintfmt+0x39>
  800abf:	0f b6 d2             	movzbl %dl,%edx
  800ac2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800ac5:	b8 00 00 00 00       	mov    $0x0,%eax
  800aca:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800acd:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800ad0:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800ad4:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800ad7:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800ada:	83 f9 09             	cmp    $0x9,%ecx
  800add:	77 55                	ja     800b34 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800adf:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800ae2:	eb e9                	jmp    800acd <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800ae4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae7:	8b 00                	mov    (%eax),%eax
  800ae9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800aec:	8b 45 14             	mov    0x14(%ebp),%eax
  800aef:	8d 40 04             	lea    0x4(%eax),%eax
  800af2:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800af5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800af8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800afc:	79 90                	jns    800a8e <vprintfmt+0x39>
				width = precision, precision = -1;
  800afe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b01:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b04:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800b0b:	eb 81                	jmp    800a8e <vprintfmt+0x39>
  800b0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b10:	85 c0                	test   %eax,%eax
  800b12:	ba 00 00 00 00       	mov    $0x0,%edx
  800b17:	0f 49 d0             	cmovns %eax,%edx
  800b1a:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800b1d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800b20:	e9 69 ff ff ff       	jmp    800a8e <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800b25:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800b28:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800b2f:	e9 5a ff ff ff       	jmp    800a8e <vprintfmt+0x39>
  800b34:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800b37:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b3a:	eb bc                	jmp    800af8 <vprintfmt+0xa3>
			lflag++;
  800b3c:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800b3f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800b42:	e9 47 ff ff ff       	jmp    800a8e <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800b47:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4a:	8d 78 04             	lea    0x4(%eax),%edi
  800b4d:	83 ec 08             	sub    $0x8,%esp
  800b50:	53                   	push   %ebx
  800b51:	ff 30                	pushl  (%eax)
  800b53:	ff d6                	call   *%esi
			break;
  800b55:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800b58:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800b5b:	e9 9b 02 00 00       	jmp    800dfb <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800b60:	8b 45 14             	mov    0x14(%ebp),%eax
  800b63:	8d 78 04             	lea    0x4(%eax),%edi
  800b66:	8b 00                	mov    (%eax),%eax
  800b68:	99                   	cltd   
  800b69:	31 d0                	xor    %edx,%eax
  800b6b:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b6d:	83 f8 0f             	cmp    $0xf,%eax
  800b70:	7f 23                	jg     800b95 <vprintfmt+0x140>
  800b72:	8b 14 85 a0 33 80 00 	mov    0x8033a0(,%eax,4),%edx
  800b79:	85 d2                	test   %edx,%edx
  800b7b:	74 18                	je     800b95 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800b7d:	52                   	push   %edx
  800b7e:	68 d5 34 80 00       	push   $0x8034d5
  800b83:	53                   	push   %ebx
  800b84:	56                   	push   %esi
  800b85:	e8 aa fe ff ff       	call   800a34 <printfmt>
  800b8a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800b8d:	89 7d 14             	mov    %edi,0x14(%ebp)
  800b90:	e9 66 02 00 00       	jmp    800dfb <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800b95:	50                   	push   %eax
  800b96:	68 17 31 80 00       	push   $0x803117
  800b9b:	53                   	push   %ebx
  800b9c:	56                   	push   %esi
  800b9d:	e8 92 fe ff ff       	call   800a34 <printfmt>
  800ba2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800ba5:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800ba8:	e9 4e 02 00 00       	jmp    800dfb <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800bad:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb0:	83 c0 04             	add    $0x4,%eax
  800bb3:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800bb6:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb9:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800bbb:	85 d2                	test   %edx,%edx
  800bbd:	b8 10 31 80 00       	mov    $0x803110,%eax
  800bc2:	0f 45 c2             	cmovne %edx,%eax
  800bc5:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800bc8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bcc:	7e 06                	jle    800bd4 <vprintfmt+0x17f>
  800bce:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800bd2:	75 0d                	jne    800be1 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bd4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800bd7:	89 c7                	mov    %eax,%edi
  800bd9:	03 45 e0             	add    -0x20(%ebp),%eax
  800bdc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800bdf:	eb 55                	jmp    800c36 <vprintfmt+0x1e1>
  800be1:	83 ec 08             	sub    $0x8,%esp
  800be4:	ff 75 d8             	pushl  -0x28(%ebp)
  800be7:	ff 75 cc             	pushl  -0x34(%ebp)
  800bea:	e8 46 03 00 00       	call   800f35 <strnlen>
  800bef:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bf2:	29 c2                	sub    %eax,%edx
  800bf4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800bf7:	83 c4 10             	add    $0x10,%esp
  800bfa:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800bfc:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800c00:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800c03:	85 ff                	test   %edi,%edi
  800c05:	7e 11                	jle    800c18 <vprintfmt+0x1c3>
					putch(padc, putdat);
  800c07:	83 ec 08             	sub    $0x8,%esp
  800c0a:	53                   	push   %ebx
  800c0b:	ff 75 e0             	pushl  -0x20(%ebp)
  800c0e:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800c10:	83 ef 01             	sub    $0x1,%edi
  800c13:	83 c4 10             	add    $0x10,%esp
  800c16:	eb eb                	jmp    800c03 <vprintfmt+0x1ae>
  800c18:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800c1b:	85 d2                	test   %edx,%edx
  800c1d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c22:	0f 49 c2             	cmovns %edx,%eax
  800c25:	29 c2                	sub    %eax,%edx
  800c27:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800c2a:	eb a8                	jmp    800bd4 <vprintfmt+0x17f>
					putch(ch, putdat);
  800c2c:	83 ec 08             	sub    $0x8,%esp
  800c2f:	53                   	push   %ebx
  800c30:	52                   	push   %edx
  800c31:	ff d6                	call   *%esi
  800c33:	83 c4 10             	add    $0x10,%esp
  800c36:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800c39:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c3b:	83 c7 01             	add    $0x1,%edi
  800c3e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800c42:	0f be d0             	movsbl %al,%edx
  800c45:	85 d2                	test   %edx,%edx
  800c47:	74 4b                	je     800c94 <vprintfmt+0x23f>
  800c49:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800c4d:	78 06                	js     800c55 <vprintfmt+0x200>
  800c4f:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800c53:	78 1e                	js     800c73 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800c55:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800c59:	74 d1                	je     800c2c <vprintfmt+0x1d7>
  800c5b:	0f be c0             	movsbl %al,%eax
  800c5e:	83 e8 20             	sub    $0x20,%eax
  800c61:	83 f8 5e             	cmp    $0x5e,%eax
  800c64:	76 c6                	jbe    800c2c <vprintfmt+0x1d7>
					putch('?', putdat);
  800c66:	83 ec 08             	sub    $0x8,%esp
  800c69:	53                   	push   %ebx
  800c6a:	6a 3f                	push   $0x3f
  800c6c:	ff d6                	call   *%esi
  800c6e:	83 c4 10             	add    $0x10,%esp
  800c71:	eb c3                	jmp    800c36 <vprintfmt+0x1e1>
  800c73:	89 cf                	mov    %ecx,%edi
  800c75:	eb 0e                	jmp    800c85 <vprintfmt+0x230>
				putch(' ', putdat);
  800c77:	83 ec 08             	sub    $0x8,%esp
  800c7a:	53                   	push   %ebx
  800c7b:	6a 20                	push   $0x20
  800c7d:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800c7f:	83 ef 01             	sub    $0x1,%edi
  800c82:	83 c4 10             	add    $0x10,%esp
  800c85:	85 ff                	test   %edi,%edi
  800c87:	7f ee                	jg     800c77 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800c89:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800c8c:	89 45 14             	mov    %eax,0x14(%ebp)
  800c8f:	e9 67 01 00 00       	jmp    800dfb <vprintfmt+0x3a6>
  800c94:	89 cf                	mov    %ecx,%edi
  800c96:	eb ed                	jmp    800c85 <vprintfmt+0x230>
	if (lflag >= 2)
  800c98:	83 f9 01             	cmp    $0x1,%ecx
  800c9b:	7f 1b                	jg     800cb8 <vprintfmt+0x263>
	else if (lflag)
  800c9d:	85 c9                	test   %ecx,%ecx
  800c9f:	74 63                	je     800d04 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800ca1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca4:	8b 00                	mov    (%eax),%eax
  800ca6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ca9:	99                   	cltd   
  800caa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800cad:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb0:	8d 40 04             	lea    0x4(%eax),%eax
  800cb3:	89 45 14             	mov    %eax,0x14(%ebp)
  800cb6:	eb 17                	jmp    800ccf <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800cb8:	8b 45 14             	mov    0x14(%ebp),%eax
  800cbb:	8b 50 04             	mov    0x4(%eax),%edx
  800cbe:	8b 00                	mov    (%eax),%eax
  800cc0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800cc3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800cc6:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc9:	8d 40 08             	lea    0x8(%eax),%eax
  800ccc:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800ccf:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800cd2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800cd5:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800cda:	85 c9                	test   %ecx,%ecx
  800cdc:	0f 89 ff 00 00 00    	jns    800de1 <vprintfmt+0x38c>
				putch('-', putdat);
  800ce2:	83 ec 08             	sub    $0x8,%esp
  800ce5:	53                   	push   %ebx
  800ce6:	6a 2d                	push   $0x2d
  800ce8:	ff d6                	call   *%esi
				num = -(long long) num;
  800cea:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800ced:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800cf0:	f7 da                	neg    %edx
  800cf2:	83 d1 00             	adc    $0x0,%ecx
  800cf5:	f7 d9                	neg    %ecx
  800cf7:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800cfa:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cff:	e9 dd 00 00 00       	jmp    800de1 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  800d04:	8b 45 14             	mov    0x14(%ebp),%eax
  800d07:	8b 00                	mov    (%eax),%eax
  800d09:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d0c:	99                   	cltd   
  800d0d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d10:	8b 45 14             	mov    0x14(%ebp),%eax
  800d13:	8d 40 04             	lea    0x4(%eax),%eax
  800d16:	89 45 14             	mov    %eax,0x14(%ebp)
  800d19:	eb b4                	jmp    800ccf <vprintfmt+0x27a>
	if (lflag >= 2)
  800d1b:	83 f9 01             	cmp    $0x1,%ecx
  800d1e:	7f 1e                	jg     800d3e <vprintfmt+0x2e9>
	else if (lflag)
  800d20:	85 c9                	test   %ecx,%ecx
  800d22:	74 32                	je     800d56 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800d24:	8b 45 14             	mov    0x14(%ebp),%eax
  800d27:	8b 10                	mov    (%eax),%edx
  800d29:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d2e:	8d 40 04             	lea    0x4(%eax),%eax
  800d31:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800d34:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800d39:	e9 a3 00 00 00       	jmp    800de1 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800d3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d41:	8b 10                	mov    (%eax),%edx
  800d43:	8b 48 04             	mov    0x4(%eax),%ecx
  800d46:	8d 40 08             	lea    0x8(%eax),%eax
  800d49:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800d4c:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800d51:	e9 8b 00 00 00       	jmp    800de1 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800d56:	8b 45 14             	mov    0x14(%ebp),%eax
  800d59:	8b 10                	mov    (%eax),%edx
  800d5b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d60:	8d 40 04             	lea    0x4(%eax),%eax
  800d63:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800d66:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800d6b:	eb 74                	jmp    800de1 <vprintfmt+0x38c>
	if (lflag >= 2)
  800d6d:	83 f9 01             	cmp    $0x1,%ecx
  800d70:	7f 1b                	jg     800d8d <vprintfmt+0x338>
	else if (lflag)
  800d72:	85 c9                	test   %ecx,%ecx
  800d74:	74 2c                	je     800da2 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800d76:	8b 45 14             	mov    0x14(%ebp),%eax
  800d79:	8b 10                	mov    (%eax),%edx
  800d7b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d80:	8d 40 04             	lea    0x4(%eax),%eax
  800d83:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800d86:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800d8b:	eb 54                	jmp    800de1 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800d8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d90:	8b 10                	mov    (%eax),%edx
  800d92:	8b 48 04             	mov    0x4(%eax),%ecx
  800d95:	8d 40 08             	lea    0x8(%eax),%eax
  800d98:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800d9b:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800da0:	eb 3f                	jmp    800de1 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800da2:	8b 45 14             	mov    0x14(%ebp),%eax
  800da5:	8b 10                	mov    (%eax),%edx
  800da7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dac:	8d 40 04             	lea    0x4(%eax),%eax
  800daf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800db2:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800db7:	eb 28                	jmp    800de1 <vprintfmt+0x38c>
			putch('0', putdat);
  800db9:	83 ec 08             	sub    $0x8,%esp
  800dbc:	53                   	push   %ebx
  800dbd:	6a 30                	push   $0x30
  800dbf:	ff d6                	call   *%esi
			putch('x', putdat);
  800dc1:	83 c4 08             	add    $0x8,%esp
  800dc4:	53                   	push   %ebx
  800dc5:	6a 78                	push   $0x78
  800dc7:	ff d6                	call   *%esi
			num = (unsigned long long)
  800dc9:	8b 45 14             	mov    0x14(%ebp),%eax
  800dcc:	8b 10                	mov    (%eax),%edx
  800dce:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800dd3:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800dd6:	8d 40 04             	lea    0x4(%eax),%eax
  800dd9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ddc:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800de1:	83 ec 0c             	sub    $0xc,%esp
  800de4:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800de8:	57                   	push   %edi
  800de9:	ff 75 e0             	pushl  -0x20(%ebp)
  800dec:	50                   	push   %eax
  800ded:	51                   	push   %ecx
  800dee:	52                   	push   %edx
  800def:	89 da                	mov    %ebx,%edx
  800df1:	89 f0                	mov    %esi,%eax
  800df3:	e8 72 fb ff ff       	call   80096a <printnum>
			break;
  800df8:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800dfb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800dfe:	83 c7 01             	add    $0x1,%edi
  800e01:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800e05:	83 f8 25             	cmp    $0x25,%eax
  800e08:	0f 84 62 fc ff ff    	je     800a70 <vprintfmt+0x1b>
			if (ch == '\0')
  800e0e:	85 c0                	test   %eax,%eax
  800e10:	0f 84 8b 00 00 00    	je     800ea1 <vprintfmt+0x44c>
			putch(ch, putdat);
  800e16:	83 ec 08             	sub    $0x8,%esp
  800e19:	53                   	push   %ebx
  800e1a:	50                   	push   %eax
  800e1b:	ff d6                	call   *%esi
  800e1d:	83 c4 10             	add    $0x10,%esp
  800e20:	eb dc                	jmp    800dfe <vprintfmt+0x3a9>
	if (lflag >= 2)
  800e22:	83 f9 01             	cmp    $0x1,%ecx
  800e25:	7f 1b                	jg     800e42 <vprintfmt+0x3ed>
	else if (lflag)
  800e27:	85 c9                	test   %ecx,%ecx
  800e29:	74 2c                	je     800e57 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800e2b:	8b 45 14             	mov    0x14(%ebp),%eax
  800e2e:	8b 10                	mov    (%eax),%edx
  800e30:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e35:	8d 40 04             	lea    0x4(%eax),%eax
  800e38:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800e3b:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800e40:	eb 9f                	jmp    800de1 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800e42:	8b 45 14             	mov    0x14(%ebp),%eax
  800e45:	8b 10                	mov    (%eax),%edx
  800e47:	8b 48 04             	mov    0x4(%eax),%ecx
  800e4a:	8d 40 08             	lea    0x8(%eax),%eax
  800e4d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800e50:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800e55:	eb 8a                	jmp    800de1 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800e57:	8b 45 14             	mov    0x14(%ebp),%eax
  800e5a:	8b 10                	mov    (%eax),%edx
  800e5c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e61:	8d 40 04             	lea    0x4(%eax),%eax
  800e64:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800e67:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800e6c:	e9 70 ff ff ff       	jmp    800de1 <vprintfmt+0x38c>
			putch(ch, putdat);
  800e71:	83 ec 08             	sub    $0x8,%esp
  800e74:	53                   	push   %ebx
  800e75:	6a 25                	push   $0x25
  800e77:	ff d6                	call   *%esi
			break;
  800e79:	83 c4 10             	add    $0x10,%esp
  800e7c:	e9 7a ff ff ff       	jmp    800dfb <vprintfmt+0x3a6>
			putch('%', putdat);
  800e81:	83 ec 08             	sub    $0x8,%esp
  800e84:	53                   	push   %ebx
  800e85:	6a 25                	push   $0x25
  800e87:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e89:	83 c4 10             	add    $0x10,%esp
  800e8c:	89 f8                	mov    %edi,%eax
  800e8e:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800e92:	74 05                	je     800e99 <vprintfmt+0x444>
  800e94:	83 e8 01             	sub    $0x1,%eax
  800e97:	eb f5                	jmp    800e8e <vprintfmt+0x439>
  800e99:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e9c:	e9 5a ff ff ff       	jmp    800dfb <vprintfmt+0x3a6>
}
  800ea1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ea4:	5b                   	pop    %ebx
  800ea5:	5e                   	pop    %esi
  800ea6:	5f                   	pop    %edi
  800ea7:	5d                   	pop    %ebp
  800ea8:	c3                   	ret    

00800ea9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ea9:	f3 0f 1e fb          	endbr32 
  800ead:	55                   	push   %ebp
  800eae:	89 e5                	mov    %esp,%ebp
  800eb0:	83 ec 18             	sub    $0x18,%esp
  800eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb6:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800eb9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ebc:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800ec0:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800ec3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800eca:	85 c0                	test   %eax,%eax
  800ecc:	74 26                	je     800ef4 <vsnprintf+0x4b>
  800ece:	85 d2                	test   %edx,%edx
  800ed0:	7e 22                	jle    800ef4 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ed2:	ff 75 14             	pushl  0x14(%ebp)
  800ed5:	ff 75 10             	pushl  0x10(%ebp)
  800ed8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800edb:	50                   	push   %eax
  800edc:	68 13 0a 80 00       	push   $0x800a13
  800ee1:	e8 6f fb ff ff       	call   800a55 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800ee6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ee9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800eef:	83 c4 10             	add    $0x10,%esp
}
  800ef2:	c9                   	leave  
  800ef3:	c3                   	ret    
		return -E_INVAL;
  800ef4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ef9:	eb f7                	jmp    800ef2 <vsnprintf+0x49>

00800efb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800efb:	f3 0f 1e fb          	endbr32 
  800eff:	55                   	push   %ebp
  800f00:	89 e5                	mov    %esp,%ebp
  800f02:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800f05:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800f08:	50                   	push   %eax
  800f09:	ff 75 10             	pushl  0x10(%ebp)
  800f0c:	ff 75 0c             	pushl  0xc(%ebp)
  800f0f:	ff 75 08             	pushl  0x8(%ebp)
  800f12:	e8 92 ff ff ff       	call   800ea9 <vsnprintf>
	va_end(ap);

	return rc;
}
  800f17:	c9                   	leave  
  800f18:	c3                   	ret    

00800f19 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800f19:	f3 0f 1e fb          	endbr32 
  800f1d:	55                   	push   %ebp
  800f1e:	89 e5                	mov    %esp,%ebp
  800f20:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800f23:	b8 00 00 00 00       	mov    $0x0,%eax
  800f28:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800f2c:	74 05                	je     800f33 <strlen+0x1a>
		n++;
  800f2e:	83 c0 01             	add    $0x1,%eax
  800f31:	eb f5                	jmp    800f28 <strlen+0xf>
	return n;
}
  800f33:	5d                   	pop    %ebp
  800f34:	c3                   	ret    

00800f35 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800f35:	f3 0f 1e fb          	endbr32 
  800f39:	55                   	push   %ebp
  800f3a:	89 e5                	mov    %esp,%ebp
  800f3c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f3f:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f42:	b8 00 00 00 00       	mov    $0x0,%eax
  800f47:	39 d0                	cmp    %edx,%eax
  800f49:	74 0d                	je     800f58 <strnlen+0x23>
  800f4b:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800f4f:	74 05                	je     800f56 <strnlen+0x21>
		n++;
  800f51:	83 c0 01             	add    $0x1,%eax
  800f54:	eb f1                	jmp    800f47 <strnlen+0x12>
  800f56:	89 c2                	mov    %eax,%edx
	return n;
}
  800f58:	89 d0                	mov    %edx,%eax
  800f5a:	5d                   	pop    %ebp
  800f5b:	c3                   	ret    

00800f5c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f5c:	f3 0f 1e fb          	endbr32 
  800f60:	55                   	push   %ebp
  800f61:	89 e5                	mov    %esp,%ebp
  800f63:	53                   	push   %ebx
  800f64:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f67:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800f6a:	b8 00 00 00 00       	mov    $0x0,%eax
  800f6f:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800f73:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800f76:	83 c0 01             	add    $0x1,%eax
  800f79:	84 d2                	test   %dl,%dl
  800f7b:	75 f2                	jne    800f6f <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800f7d:	89 c8                	mov    %ecx,%eax
  800f7f:	5b                   	pop    %ebx
  800f80:	5d                   	pop    %ebp
  800f81:	c3                   	ret    

00800f82 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f82:	f3 0f 1e fb          	endbr32 
  800f86:	55                   	push   %ebp
  800f87:	89 e5                	mov    %esp,%ebp
  800f89:	53                   	push   %ebx
  800f8a:	83 ec 10             	sub    $0x10,%esp
  800f8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800f90:	53                   	push   %ebx
  800f91:	e8 83 ff ff ff       	call   800f19 <strlen>
  800f96:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800f99:	ff 75 0c             	pushl  0xc(%ebp)
  800f9c:	01 d8                	add    %ebx,%eax
  800f9e:	50                   	push   %eax
  800f9f:	e8 b8 ff ff ff       	call   800f5c <strcpy>
	return dst;
}
  800fa4:	89 d8                	mov    %ebx,%eax
  800fa6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fa9:	c9                   	leave  
  800faa:	c3                   	ret    

00800fab <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800fab:	f3 0f 1e fb          	endbr32 
  800faf:	55                   	push   %ebp
  800fb0:	89 e5                	mov    %esp,%ebp
  800fb2:	56                   	push   %esi
  800fb3:	53                   	push   %ebx
  800fb4:	8b 75 08             	mov    0x8(%ebp),%esi
  800fb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fba:	89 f3                	mov    %esi,%ebx
  800fbc:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800fbf:	89 f0                	mov    %esi,%eax
  800fc1:	39 d8                	cmp    %ebx,%eax
  800fc3:	74 11                	je     800fd6 <strncpy+0x2b>
		*dst++ = *src;
  800fc5:	83 c0 01             	add    $0x1,%eax
  800fc8:	0f b6 0a             	movzbl (%edx),%ecx
  800fcb:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800fce:	80 f9 01             	cmp    $0x1,%cl
  800fd1:	83 da ff             	sbb    $0xffffffff,%edx
  800fd4:	eb eb                	jmp    800fc1 <strncpy+0x16>
	}
	return ret;
}
  800fd6:	89 f0                	mov    %esi,%eax
  800fd8:	5b                   	pop    %ebx
  800fd9:	5e                   	pop    %esi
  800fda:	5d                   	pop    %ebp
  800fdb:	c3                   	ret    

00800fdc <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800fdc:	f3 0f 1e fb          	endbr32 
  800fe0:	55                   	push   %ebp
  800fe1:	89 e5                	mov    %esp,%ebp
  800fe3:	56                   	push   %esi
  800fe4:	53                   	push   %ebx
  800fe5:	8b 75 08             	mov    0x8(%ebp),%esi
  800fe8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800feb:	8b 55 10             	mov    0x10(%ebp),%edx
  800fee:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ff0:	85 d2                	test   %edx,%edx
  800ff2:	74 21                	je     801015 <strlcpy+0x39>
  800ff4:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800ff8:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800ffa:	39 c2                	cmp    %eax,%edx
  800ffc:	74 14                	je     801012 <strlcpy+0x36>
  800ffe:	0f b6 19             	movzbl (%ecx),%ebx
  801001:	84 db                	test   %bl,%bl
  801003:	74 0b                	je     801010 <strlcpy+0x34>
			*dst++ = *src++;
  801005:	83 c1 01             	add    $0x1,%ecx
  801008:	83 c2 01             	add    $0x1,%edx
  80100b:	88 5a ff             	mov    %bl,-0x1(%edx)
  80100e:	eb ea                	jmp    800ffa <strlcpy+0x1e>
  801010:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  801012:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801015:	29 f0                	sub    %esi,%eax
}
  801017:	5b                   	pop    %ebx
  801018:	5e                   	pop    %esi
  801019:	5d                   	pop    %ebp
  80101a:	c3                   	ret    

0080101b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80101b:	f3 0f 1e fb          	endbr32 
  80101f:	55                   	push   %ebp
  801020:	89 e5                	mov    %esp,%ebp
  801022:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801025:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801028:	0f b6 01             	movzbl (%ecx),%eax
  80102b:	84 c0                	test   %al,%al
  80102d:	74 0c                	je     80103b <strcmp+0x20>
  80102f:	3a 02                	cmp    (%edx),%al
  801031:	75 08                	jne    80103b <strcmp+0x20>
		p++, q++;
  801033:	83 c1 01             	add    $0x1,%ecx
  801036:	83 c2 01             	add    $0x1,%edx
  801039:	eb ed                	jmp    801028 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80103b:	0f b6 c0             	movzbl %al,%eax
  80103e:	0f b6 12             	movzbl (%edx),%edx
  801041:	29 d0                	sub    %edx,%eax
}
  801043:	5d                   	pop    %ebp
  801044:	c3                   	ret    

00801045 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801045:	f3 0f 1e fb          	endbr32 
  801049:	55                   	push   %ebp
  80104a:	89 e5                	mov    %esp,%ebp
  80104c:	53                   	push   %ebx
  80104d:	8b 45 08             	mov    0x8(%ebp),%eax
  801050:	8b 55 0c             	mov    0xc(%ebp),%edx
  801053:	89 c3                	mov    %eax,%ebx
  801055:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801058:	eb 06                	jmp    801060 <strncmp+0x1b>
		n--, p++, q++;
  80105a:	83 c0 01             	add    $0x1,%eax
  80105d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  801060:	39 d8                	cmp    %ebx,%eax
  801062:	74 16                	je     80107a <strncmp+0x35>
  801064:	0f b6 08             	movzbl (%eax),%ecx
  801067:	84 c9                	test   %cl,%cl
  801069:	74 04                	je     80106f <strncmp+0x2a>
  80106b:	3a 0a                	cmp    (%edx),%cl
  80106d:	74 eb                	je     80105a <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80106f:	0f b6 00             	movzbl (%eax),%eax
  801072:	0f b6 12             	movzbl (%edx),%edx
  801075:	29 d0                	sub    %edx,%eax
}
  801077:	5b                   	pop    %ebx
  801078:	5d                   	pop    %ebp
  801079:	c3                   	ret    
		return 0;
  80107a:	b8 00 00 00 00       	mov    $0x0,%eax
  80107f:	eb f6                	jmp    801077 <strncmp+0x32>

00801081 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801081:	f3 0f 1e fb          	endbr32 
  801085:	55                   	push   %ebp
  801086:	89 e5                	mov    %esp,%ebp
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80108f:	0f b6 10             	movzbl (%eax),%edx
  801092:	84 d2                	test   %dl,%dl
  801094:	74 09                	je     80109f <strchr+0x1e>
		if (*s == c)
  801096:	38 ca                	cmp    %cl,%dl
  801098:	74 0a                	je     8010a4 <strchr+0x23>
	for (; *s; s++)
  80109a:	83 c0 01             	add    $0x1,%eax
  80109d:	eb f0                	jmp    80108f <strchr+0xe>
			return (char *) s;
	return 0;
  80109f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010a4:	5d                   	pop    %ebp
  8010a5:	c3                   	ret    

008010a6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010a6:	f3 0f 1e fb          	endbr32 
  8010aa:	55                   	push   %ebp
  8010ab:	89 e5                	mov    %esp,%ebp
  8010ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8010b4:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8010b7:	38 ca                	cmp    %cl,%dl
  8010b9:	74 09                	je     8010c4 <strfind+0x1e>
  8010bb:	84 d2                	test   %dl,%dl
  8010bd:	74 05                	je     8010c4 <strfind+0x1e>
	for (; *s; s++)
  8010bf:	83 c0 01             	add    $0x1,%eax
  8010c2:	eb f0                	jmp    8010b4 <strfind+0xe>
			break;
	return (char *) s;
}
  8010c4:	5d                   	pop    %ebp
  8010c5:	c3                   	ret    

008010c6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8010c6:	f3 0f 1e fb          	endbr32 
  8010ca:	55                   	push   %ebp
  8010cb:	89 e5                	mov    %esp,%ebp
  8010cd:	57                   	push   %edi
  8010ce:	56                   	push   %esi
  8010cf:	53                   	push   %ebx
  8010d0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8010d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8010d6:	85 c9                	test   %ecx,%ecx
  8010d8:	74 31                	je     80110b <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8010da:	89 f8                	mov    %edi,%eax
  8010dc:	09 c8                	or     %ecx,%eax
  8010de:	a8 03                	test   $0x3,%al
  8010e0:	75 23                	jne    801105 <memset+0x3f>
		c &= 0xFF;
  8010e2:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8010e6:	89 d3                	mov    %edx,%ebx
  8010e8:	c1 e3 08             	shl    $0x8,%ebx
  8010eb:	89 d0                	mov    %edx,%eax
  8010ed:	c1 e0 18             	shl    $0x18,%eax
  8010f0:	89 d6                	mov    %edx,%esi
  8010f2:	c1 e6 10             	shl    $0x10,%esi
  8010f5:	09 f0                	or     %esi,%eax
  8010f7:	09 c2                	or     %eax,%edx
  8010f9:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8010fb:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8010fe:	89 d0                	mov    %edx,%eax
  801100:	fc                   	cld    
  801101:	f3 ab                	rep stos %eax,%es:(%edi)
  801103:	eb 06                	jmp    80110b <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801105:	8b 45 0c             	mov    0xc(%ebp),%eax
  801108:	fc                   	cld    
  801109:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80110b:	89 f8                	mov    %edi,%eax
  80110d:	5b                   	pop    %ebx
  80110e:	5e                   	pop    %esi
  80110f:	5f                   	pop    %edi
  801110:	5d                   	pop    %ebp
  801111:	c3                   	ret    

00801112 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801112:	f3 0f 1e fb          	endbr32 
  801116:	55                   	push   %ebp
  801117:	89 e5                	mov    %esp,%ebp
  801119:	57                   	push   %edi
  80111a:	56                   	push   %esi
  80111b:	8b 45 08             	mov    0x8(%ebp),%eax
  80111e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801121:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801124:	39 c6                	cmp    %eax,%esi
  801126:	73 32                	jae    80115a <memmove+0x48>
  801128:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80112b:	39 c2                	cmp    %eax,%edx
  80112d:	76 2b                	jbe    80115a <memmove+0x48>
		s += n;
		d += n;
  80112f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801132:	89 fe                	mov    %edi,%esi
  801134:	09 ce                	or     %ecx,%esi
  801136:	09 d6                	or     %edx,%esi
  801138:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80113e:	75 0e                	jne    80114e <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801140:	83 ef 04             	sub    $0x4,%edi
  801143:	8d 72 fc             	lea    -0x4(%edx),%esi
  801146:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801149:	fd                   	std    
  80114a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80114c:	eb 09                	jmp    801157 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80114e:	83 ef 01             	sub    $0x1,%edi
  801151:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801154:	fd                   	std    
  801155:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801157:	fc                   	cld    
  801158:	eb 1a                	jmp    801174 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80115a:	89 c2                	mov    %eax,%edx
  80115c:	09 ca                	or     %ecx,%edx
  80115e:	09 f2                	or     %esi,%edx
  801160:	f6 c2 03             	test   $0x3,%dl
  801163:	75 0a                	jne    80116f <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801165:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801168:	89 c7                	mov    %eax,%edi
  80116a:	fc                   	cld    
  80116b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80116d:	eb 05                	jmp    801174 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  80116f:	89 c7                	mov    %eax,%edi
  801171:	fc                   	cld    
  801172:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801174:	5e                   	pop    %esi
  801175:	5f                   	pop    %edi
  801176:	5d                   	pop    %ebp
  801177:	c3                   	ret    

00801178 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801178:	f3 0f 1e fb          	endbr32 
  80117c:	55                   	push   %ebp
  80117d:	89 e5                	mov    %esp,%ebp
  80117f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801182:	ff 75 10             	pushl  0x10(%ebp)
  801185:	ff 75 0c             	pushl  0xc(%ebp)
  801188:	ff 75 08             	pushl  0x8(%ebp)
  80118b:	e8 82 ff ff ff       	call   801112 <memmove>
}
  801190:	c9                   	leave  
  801191:	c3                   	ret    

00801192 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801192:	f3 0f 1e fb          	endbr32 
  801196:	55                   	push   %ebp
  801197:	89 e5                	mov    %esp,%ebp
  801199:	56                   	push   %esi
  80119a:	53                   	push   %ebx
  80119b:	8b 45 08             	mov    0x8(%ebp),%eax
  80119e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011a1:	89 c6                	mov    %eax,%esi
  8011a3:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8011a6:	39 f0                	cmp    %esi,%eax
  8011a8:	74 1c                	je     8011c6 <memcmp+0x34>
		if (*s1 != *s2)
  8011aa:	0f b6 08             	movzbl (%eax),%ecx
  8011ad:	0f b6 1a             	movzbl (%edx),%ebx
  8011b0:	38 d9                	cmp    %bl,%cl
  8011b2:	75 08                	jne    8011bc <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8011b4:	83 c0 01             	add    $0x1,%eax
  8011b7:	83 c2 01             	add    $0x1,%edx
  8011ba:	eb ea                	jmp    8011a6 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  8011bc:	0f b6 c1             	movzbl %cl,%eax
  8011bf:	0f b6 db             	movzbl %bl,%ebx
  8011c2:	29 d8                	sub    %ebx,%eax
  8011c4:	eb 05                	jmp    8011cb <memcmp+0x39>
	}

	return 0;
  8011c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011cb:	5b                   	pop    %ebx
  8011cc:	5e                   	pop    %esi
  8011cd:	5d                   	pop    %ebp
  8011ce:	c3                   	ret    

008011cf <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8011cf:	f3 0f 1e fb          	endbr32 
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
  8011d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8011dc:	89 c2                	mov    %eax,%edx
  8011de:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8011e1:	39 d0                	cmp    %edx,%eax
  8011e3:	73 09                	jae    8011ee <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011e5:	38 08                	cmp    %cl,(%eax)
  8011e7:	74 05                	je     8011ee <memfind+0x1f>
	for (; s < ends; s++)
  8011e9:	83 c0 01             	add    $0x1,%eax
  8011ec:	eb f3                	jmp    8011e1 <memfind+0x12>
			break;
	return (void *) s;
}
  8011ee:	5d                   	pop    %ebp
  8011ef:	c3                   	ret    

008011f0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011f0:	f3 0f 1e fb          	endbr32 
  8011f4:	55                   	push   %ebp
  8011f5:	89 e5                	mov    %esp,%ebp
  8011f7:	57                   	push   %edi
  8011f8:	56                   	push   %esi
  8011f9:	53                   	push   %ebx
  8011fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011fd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801200:	eb 03                	jmp    801205 <strtol+0x15>
		s++;
  801202:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  801205:	0f b6 01             	movzbl (%ecx),%eax
  801208:	3c 20                	cmp    $0x20,%al
  80120a:	74 f6                	je     801202 <strtol+0x12>
  80120c:	3c 09                	cmp    $0x9,%al
  80120e:	74 f2                	je     801202 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  801210:	3c 2b                	cmp    $0x2b,%al
  801212:	74 2a                	je     80123e <strtol+0x4e>
	int neg = 0;
  801214:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  801219:	3c 2d                	cmp    $0x2d,%al
  80121b:	74 2b                	je     801248 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80121d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  801223:	75 0f                	jne    801234 <strtol+0x44>
  801225:	80 39 30             	cmpb   $0x30,(%ecx)
  801228:	74 28                	je     801252 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  80122a:	85 db                	test   %ebx,%ebx
  80122c:	b8 0a 00 00 00       	mov    $0xa,%eax
  801231:	0f 44 d8             	cmove  %eax,%ebx
  801234:	b8 00 00 00 00       	mov    $0x0,%eax
  801239:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80123c:	eb 46                	jmp    801284 <strtol+0x94>
		s++;
  80123e:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  801241:	bf 00 00 00 00       	mov    $0x0,%edi
  801246:	eb d5                	jmp    80121d <strtol+0x2d>
		s++, neg = 1;
  801248:	83 c1 01             	add    $0x1,%ecx
  80124b:	bf 01 00 00 00       	mov    $0x1,%edi
  801250:	eb cb                	jmp    80121d <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801252:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801256:	74 0e                	je     801266 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  801258:	85 db                	test   %ebx,%ebx
  80125a:	75 d8                	jne    801234 <strtol+0x44>
		s++, base = 8;
  80125c:	83 c1 01             	add    $0x1,%ecx
  80125f:	bb 08 00 00 00       	mov    $0x8,%ebx
  801264:	eb ce                	jmp    801234 <strtol+0x44>
		s += 2, base = 16;
  801266:	83 c1 02             	add    $0x2,%ecx
  801269:	bb 10 00 00 00       	mov    $0x10,%ebx
  80126e:	eb c4                	jmp    801234 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  801270:	0f be d2             	movsbl %dl,%edx
  801273:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801276:	3b 55 10             	cmp    0x10(%ebp),%edx
  801279:	7d 3a                	jge    8012b5 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  80127b:	83 c1 01             	add    $0x1,%ecx
  80127e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801282:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801284:	0f b6 11             	movzbl (%ecx),%edx
  801287:	8d 72 d0             	lea    -0x30(%edx),%esi
  80128a:	89 f3                	mov    %esi,%ebx
  80128c:	80 fb 09             	cmp    $0x9,%bl
  80128f:	76 df                	jbe    801270 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  801291:	8d 72 9f             	lea    -0x61(%edx),%esi
  801294:	89 f3                	mov    %esi,%ebx
  801296:	80 fb 19             	cmp    $0x19,%bl
  801299:	77 08                	ja     8012a3 <strtol+0xb3>
			dig = *s - 'a' + 10;
  80129b:	0f be d2             	movsbl %dl,%edx
  80129e:	83 ea 57             	sub    $0x57,%edx
  8012a1:	eb d3                	jmp    801276 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  8012a3:	8d 72 bf             	lea    -0x41(%edx),%esi
  8012a6:	89 f3                	mov    %esi,%ebx
  8012a8:	80 fb 19             	cmp    $0x19,%bl
  8012ab:	77 08                	ja     8012b5 <strtol+0xc5>
			dig = *s - 'A' + 10;
  8012ad:	0f be d2             	movsbl %dl,%edx
  8012b0:	83 ea 37             	sub    $0x37,%edx
  8012b3:	eb c1                	jmp    801276 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  8012b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012b9:	74 05                	je     8012c0 <strtol+0xd0>
		*endptr = (char *) s;
  8012bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012be:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8012c0:	89 c2                	mov    %eax,%edx
  8012c2:	f7 da                	neg    %edx
  8012c4:	85 ff                	test   %edi,%edi
  8012c6:	0f 45 c2             	cmovne %edx,%eax
}
  8012c9:	5b                   	pop    %ebx
  8012ca:	5e                   	pop    %esi
  8012cb:	5f                   	pop    %edi
  8012cc:	5d                   	pop    %ebp
  8012cd:	c3                   	ret    

008012ce <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8012ce:	f3 0f 1e fb          	endbr32 
  8012d2:	55                   	push   %ebp
  8012d3:	89 e5                	mov    %esp,%ebp
  8012d5:	57                   	push   %edi
  8012d6:	56                   	push   %esi
  8012d7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8012dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012e3:	89 c3                	mov    %eax,%ebx
  8012e5:	89 c7                	mov    %eax,%edi
  8012e7:	89 c6                	mov    %eax,%esi
  8012e9:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8012eb:	5b                   	pop    %ebx
  8012ec:	5e                   	pop    %esi
  8012ed:	5f                   	pop    %edi
  8012ee:	5d                   	pop    %ebp
  8012ef:	c3                   	ret    

008012f0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8012f0:	f3 0f 1e fb          	endbr32 
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
  8012f7:	57                   	push   %edi
  8012f8:	56                   	push   %esi
  8012f9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8012ff:	b8 01 00 00 00       	mov    $0x1,%eax
  801304:	89 d1                	mov    %edx,%ecx
  801306:	89 d3                	mov    %edx,%ebx
  801308:	89 d7                	mov    %edx,%edi
  80130a:	89 d6                	mov    %edx,%esi
  80130c:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80130e:	5b                   	pop    %ebx
  80130f:	5e                   	pop    %esi
  801310:	5f                   	pop    %edi
  801311:	5d                   	pop    %ebp
  801312:	c3                   	ret    

00801313 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801313:	f3 0f 1e fb          	endbr32 
  801317:	55                   	push   %ebp
  801318:	89 e5                	mov    %esp,%ebp
  80131a:	57                   	push   %edi
  80131b:	56                   	push   %esi
  80131c:	53                   	push   %ebx
  80131d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801320:	b9 00 00 00 00       	mov    $0x0,%ecx
  801325:	8b 55 08             	mov    0x8(%ebp),%edx
  801328:	b8 03 00 00 00       	mov    $0x3,%eax
  80132d:	89 cb                	mov    %ecx,%ebx
  80132f:	89 cf                	mov    %ecx,%edi
  801331:	89 ce                	mov    %ecx,%esi
  801333:	cd 30                	int    $0x30
	if(check && ret > 0)
  801335:	85 c0                	test   %eax,%eax
  801337:	7f 08                	jg     801341 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801339:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80133c:	5b                   	pop    %ebx
  80133d:	5e                   	pop    %esi
  80133e:	5f                   	pop    %edi
  80133f:	5d                   	pop    %ebp
  801340:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801341:	83 ec 0c             	sub    $0xc,%esp
  801344:	50                   	push   %eax
  801345:	6a 03                	push   $0x3
  801347:	68 ff 33 80 00       	push   $0x8033ff
  80134c:	6a 23                	push   $0x23
  80134e:	68 1c 34 80 00       	push   $0x80341c
  801353:	e8 13 f5 ff ff       	call   80086b <_panic>

00801358 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801358:	f3 0f 1e fb          	endbr32 
  80135c:	55                   	push   %ebp
  80135d:	89 e5                	mov    %esp,%ebp
  80135f:	57                   	push   %edi
  801360:	56                   	push   %esi
  801361:	53                   	push   %ebx
	asm volatile("int %1\n"
  801362:	ba 00 00 00 00       	mov    $0x0,%edx
  801367:	b8 02 00 00 00       	mov    $0x2,%eax
  80136c:	89 d1                	mov    %edx,%ecx
  80136e:	89 d3                	mov    %edx,%ebx
  801370:	89 d7                	mov    %edx,%edi
  801372:	89 d6                	mov    %edx,%esi
  801374:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801376:	5b                   	pop    %ebx
  801377:	5e                   	pop    %esi
  801378:	5f                   	pop    %edi
  801379:	5d                   	pop    %ebp
  80137a:	c3                   	ret    

0080137b <sys_yield>:

void
sys_yield(void)
{
  80137b:	f3 0f 1e fb          	endbr32 
  80137f:	55                   	push   %ebp
  801380:	89 e5                	mov    %esp,%ebp
  801382:	57                   	push   %edi
  801383:	56                   	push   %esi
  801384:	53                   	push   %ebx
	asm volatile("int %1\n"
  801385:	ba 00 00 00 00       	mov    $0x0,%edx
  80138a:	b8 0b 00 00 00       	mov    $0xb,%eax
  80138f:	89 d1                	mov    %edx,%ecx
  801391:	89 d3                	mov    %edx,%ebx
  801393:	89 d7                	mov    %edx,%edi
  801395:	89 d6                	mov    %edx,%esi
  801397:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801399:	5b                   	pop    %ebx
  80139a:	5e                   	pop    %esi
  80139b:	5f                   	pop    %edi
  80139c:	5d                   	pop    %ebp
  80139d:	c3                   	ret    

0080139e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80139e:	f3 0f 1e fb          	endbr32 
  8013a2:	55                   	push   %ebp
  8013a3:	89 e5                	mov    %esp,%ebp
  8013a5:	57                   	push   %edi
  8013a6:	56                   	push   %esi
  8013a7:	53                   	push   %ebx
  8013a8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8013ab:	be 00 00 00 00       	mov    $0x0,%esi
  8013b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8013b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013b6:	b8 04 00 00 00       	mov    $0x4,%eax
  8013bb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8013be:	89 f7                	mov    %esi,%edi
  8013c0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8013c2:	85 c0                	test   %eax,%eax
  8013c4:	7f 08                	jg     8013ce <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8013c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013c9:	5b                   	pop    %ebx
  8013ca:	5e                   	pop    %esi
  8013cb:	5f                   	pop    %edi
  8013cc:	5d                   	pop    %ebp
  8013cd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013ce:	83 ec 0c             	sub    $0xc,%esp
  8013d1:	50                   	push   %eax
  8013d2:	6a 04                	push   $0x4
  8013d4:	68 ff 33 80 00       	push   $0x8033ff
  8013d9:	6a 23                	push   $0x23
  8013db:	68 1c 34 80 00       	push   $0x80341c
  8013e0:	e8 86 f4 ff ff       	call   80086b <_panic>

008013e5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8013e5:	f3 0f 1e fb          	endbr32 
  8013e9:	55                   	push   %ebp
  8013ea:	89 e5                	mov    %esp,%ebp
  8013ec:	57                   	push   %edi
  8013ed:	56                   	push   %esi
  8013ee:	53                   	push   %ebx
  8013ef:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8013f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8013f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013f8:	b8 05 00 00 00       	mov    $0x5,%eax
  8013fd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801400:	8b 7d 14             	mov    0x14(%ebp),%edi
  801403:	8b 75 18             	mov    0x18(%ebp),%esi
  801406:	cd 30                	int    $0x30
	if(check && ret > 0)
  801408:	85 c0                	test   %eax,%eax
  80140a:	7f 08                	jg     801414 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80140c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80140f:	5b                   	pop    %ebx
  801410:	5e                   	pop    %esi
  801411:	5f                   	pop    %edi
  801412:	5d                   	pop    %ebp
  801413:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801414:	83 ec 0c             	sub    $0xc,%esp
  801417:	50                   	push   %eax
  801418:	6a 05                	push   $0x5
  80141a:	68 ff 33 80 00       	push   $0x8033ff
  80141f:	6a 23                	push   $0x23
  801421:	68 1c 34 80 00       	push   $0x80341c
  801426:	e8 40 f4 ff ff       	call   80086b <_panic>

0080142b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80142b:	f3 0f 1e fb          	endbr32 
  80142f:	55                   	push   %ebp
  801430:	89 e5                	mov    %esp,%ebp
  801432:	57                   	push   %edi
  801433:	56                   	push   %esi
  801434:	53                   	push   %ebx
  801435:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801438:	bb 00 00 00 00       	mov    $0x0,%ebx
  80143d:	8b 55 08             	mov    0x8(%ebp),%edx
  801440:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801443:	b8 06 00 00 00       	mov    $0x6,%eax
  801448:	89 df                	mov    %ebx,%edi
  80144a:	89 de                	mov    %ebx,%esi
  80144c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80144e:	85 c0                	test   %eax,%eax
  801450:	7f 08                	jg     80145a <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801452:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801455:	5b                   	pop    %ebx
  801456:	5e                   	pop    %esi
  801457:	5f                   	pop    %edi
  801458:	5d                   	pop    %ebp
  801459:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80145a:	83 ec 0c             	sub    $0xc,%esp
  80145d:	50                   	push   %eax
  80145e:	6a 06                	push   $0x6
  801460:	68 ff 33 80 00       	push   $0x8033ff
  801465:	6a 23                	push   $0x23
  801467:	68 1c 34 80 00       	push   $0x80341c
  80146c:	e8 fa f3 ff ff       	call   80086b <_panic>

00801471 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801471:	f3 0f 1e fb          	endbr32 
  801475:	55                   	push   %ebp
  801476:	89 e5                	mov    %esp,%ebp
  801478:	57                   	push   %edi
  801479:	56                   	push   %esi
  80147a:	53                   	push   %ebx
  80147b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80147e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801483:	8b 55 08             	mov    0x8(%ebp),%edx
  801486:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801489:	b8 08 00 00 00       	mov    $0x8,%eax
  80148e:	89 df                	mov    %ebx,%edi
  801490:	89 de                	mov    %ebx,%esi
  801492:	cd 30                	int    $0x30
	if(check && ret > 0)
  801494:	85 c0                	test   %eax,%eax
  801496:	7f 08                	jg     8014a0 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801498:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80149b:	5b                   	pop    %ebx
  80149c:	5e                   	pop    %esi
  80149d:	5f                   	pop    %edi
  80149e:	5d                   	pop    %ebp
  80149f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8014a0:	83 ec 0c             	sub    $0xc,%esp
  8014a3:	50                   	push   %eax
  8014a4:	6a 08                	push   $0x8
  8014a6:	68 ff 33 80 00       	push   $0x8033ff
  8014ab:	6a 23                	push   $0x23
  8014ad:	68 1c 34 80 00       	push   $0x80341c
  8014b2:	e8 b4 f3 ff ff       	call   80086b <_panic>

008014b7 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8014b7:	f3 0f 1e fb          	endbr32 
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
  8014be:	57                   	push   %edi
  8014bf:	56                   	push   %esi
  8014c0:	53                   	push   %ebx
  8014c1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8014c4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8014cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014cf:	b8 09 00 00 00       	mov    $0x9,%eax
  8014d4:	89 df                	mov    %ebx,%edi
  8014d6:	89 de                	mov    %ebx,%esi
  8014d8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8014da:	85 c0                	test   %eax,%eax
  8014dc:	7f 08                	jg     8014e6 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8014de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014e1:	5b                   	pop    %ebx
  8014e2:	5e                   	pop    %esi
  8014e3:	5f                   	pop    %edi
  8014e4:	5d                   	pop    %ebp
  8014e5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8014e6:	83 ec 0c             	sub    $0xc,%esp
  8014e9:	50                   	push   %eax
  8014ea:	6a 09                	push   $0x9
  8014ec:	68 ff 33 80 00       	push   $0x8033ff
  8014f1:	6a 23                	push   $0x23
  8014f3:	68 1c 34 80 00       	push   $0x80341c
  8014f8:	e8 6e f3 ff ff       	call   80086b <_panic>

008014fd <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8014fd:	f3 0f 1e fb          	endbr32 
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
  801504:	57                   	push   %edi
  801505:	56                   	push   %esi
  801506:	53                   	push   %ebx
  801507:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80150a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80150f:	8b 55 08             	mov    0x8(%ebp),%edx
  801512:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801515:	b8 0a 00 00 00       	mov    $0xa,%eax
  80151a:	89 df                	mov    %ebx,%edi
  80151c:	89 de                	mov    %ebx,%esi
  80151e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801520:	85 c0                	test   %eax,%eax
  801522:	7f 08                	jg     80152c <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801524:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801527:	5b                   	pop    %ebx
  801528:	5e                   	pop    %esi
  801529:	5f                   	pop    %edi
  80152a:	5d                   	pop    %ebp
  80152b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80152c:	83 ec 0c             	sub    $0xc,%esp
  80152f:	50                   	push   %eax
  801530:	6a 0a                	push   $0xa
  801532:	68 ff 33 80 00       	push   $0x8033ff
  801537:	6a 23                	push   $0x23
  801539:	68 1c 34 80 00       	push   $0x80341c
  80153e:	e8 28 f3 ff ff       	call   80086b <_panic>

00801543 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801543:	f3 0f 1e fb          	endbr32 
  801547:	55                   	push   %ebp
  801548:	89 e5                	mov    %esp,%ebp
  80154a:	57                   	push   %edi
  80154b:	56                   	push   %esi
  80154c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80154d:	8b 55 08             	mov    0x8(%ebp),%edx
  801550:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801553:	b8 0c 00 00 00       	mov    $0xc,%eax
  801558:	be 00 00 00 00       	mov    $0x0,%esi
  80155d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801560:	8b 7d 14             	mov    0x14(%ebp),%edi
  801563:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801565:	5b                   	pop    %ebx
  801566:	5e                   	pop    %esi
  801567:	5f                   	pop    %edi
  801568:	5d                   	pop    %ebp
  801569:	c3                   	ret    

0080156a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80156a:	f3 0f 1e fb          	endbr32 
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
  801571:	57                   	push   %edi
  801572:	56                   	push   %esi
  801573:	53                   	push   %ebx
  801574:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801577:	b9 00 00 00 00       	mov    $0x0,%ecx
  80157c:	8b 55 08             	mov    0x8(%ebp),%edx
  80157f:	b8 0d 00 00 00       	mov    $0xd,%eax
  801584:	89 cb                	mov    %ecx,%ebx
  801586:	89 cf                	mov    %ecx,%edi
  801588:	89 ce                	mov    %ecx,%esi
  80158a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80158c:	85 c0                	test   %eax,%eax
  80158e:	7f 08                	jg     801598 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801590:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801593:	5b                   	pop    %ebx
  801594:	5e                   	pop    %esi
  801595:	5f                   	pop    %edi
  801596:	5d                   	pop    %ebp
  801597:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801598:	83 ec 0c             	sub    $0xc,%esp
  80159b:	50                   	push   %eax
  80159c:	6a 0d                	push   $0xd
  80159e:	68 ff 33 80 00       	push   $0x8033ff
  8015a3:	6a 23                	push   $0x23
  8015a5:	68 1c 34 80 00       	push   $0x80341c
  8015aa:	e8 bc f2 ff ff       	call   80086b <_panic>

008015af <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8015af:	f3 0f 1e fb          	endbr32 
  8015b3:	55                   	push   %ebp
  8015b4:	89 e5                	mov    %esp,%ebp
  8015b6:	57                   	push   %edi
  8015b7:	56                   	push   %esi
  8015b8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8015b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8015be:	b8 0e 00 00 00       	mov    $0xe,%eax
  8015c3:	89 d1                	mov    %edx,%ecx
  8015c5:	89 d3                	mov    %edx,%ebx
  8015c7:	89 d7                	mov    %edx,%edi
  8015c9:	89 d6                	mov    %edx,%esi
  8015cb:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8015cd:	5b                   	pop    %ebx
  8015ce:	5e                   	pop    %esi
  8015cf:	5f                   	pop    %edi
  8015d0:	5d                   	pop    %ebp
  8015d1:	c3                   	ret    

008015d2 <sys_pkt_send>:

int
sys_pkt_send(void *data, size_t len)
{
  8015d2:	f3 0f 1e fb          	endbr32 
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
  8015d9:	57                   	push   %edi
  8015da:	56                   	push   %esi
  8015db:	53                   	push   %ebx
  8015dc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8015df:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8015e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015ea:	b8 0f 00 00 00       	mov    $0xf,%eax
  8015ef:	89 df                	mov    %ebx,%edi
  8015f1:	89 de                	mov    %ebx,%esi
  8015f3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8015f5:	85 c0                	test   %eax,%eax
  8015f7:	7f 08                	jg     801601 <sys_pkt_send+0x2f>
	return syscall(SYS_pkt_send, 1, (uint32_t)data, len, 0, 0, 0);
}
  8015f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015fc:	5b                   	pop    %ebx
  8015fd:	5e                   	pop    %esi
  8015fe:	5f                   	pop    %edi
  8015ff:	5d                   	pop    %ebp
  801600:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801601:	83 ec 0c             	sub    $0xc,%esp
  801604:	50                   	push   %eax
  801605:	6a 0f                	push   $0xf
  801607:	68 ff 33 80 00       	push   $0x8033ff
  80160c:	6a 23                	push   $0x23
  80160e:	68 1c 34 80 00       	push   $0x80341c
  801613:	e8 53 f2 ff ff       	call   80086b <_panic>

00801618 <sys_pkt_recv>:

int
sys_pkt_recv(void *addr, size_t *len)
{
  801618:	f3 0f 1e fb          	endbr32 
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
  80161f:	57                   	push   %edi
  801620:	56                   	push   %esi
  801621:	53                   	push   %ebx
  801622:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801625:	bb 00 00 00 00       	mov    $0x0,%ebx
  80162a:	8b 55 08             	mov    0x8(%ebp),%edx
  80162d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801630:	b8 10 00 00 00       	mov    $0x10,%eax
  801635:	89 df                	mov    %ebx,%edi
  801637:	89 de                	mov    %ebx,%esi
  801639:	cd 30                	int    $0x30
	if(check && ret > 0)
  80163b:	85 c0                	test   %eax,%eax
  80163d:	7f 08                	jg     801647 <sys_pkt_recv+0x2f>
	return syscall(SYS_pkt_recv, 1, (uint32_t)addr, (uint32_t)len, 0, 0, 0);
  80163f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801642:	5b                   	pop    %ebx
  801643:	5e                   	pop    %esi
  801644:	5f                   	pop    %edi
  801645:	5d                   	pop    %ebp
  801646:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801647:	83 ec 0c             	sub    $0xc,%esp
  80164a:	50                   	push   %eax
  80164b:	6a 10                	push   $0x10
  80164d:	68 ff 33 80 00       	push   $0x8033ff
  801652:	6a 23                	push   $0x23
  801654:	68 1c 34 80 00       	push   $0x80341c
  801659:	e8 0d f2 ff ff       	call   80086b <_panic>

0080165e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80165e:	f3 0f 1e fb          	endbr32 
  801662:	55                   	push   %ebp
  801663:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801665:	8b 45 08             	mov    0x8(%ebp),%eax
  801668:	05 00 00 00 30       	add    $0x30000000,%eax
  80166d:	c1 e8 0c             	shr    $0xc,%eax
}
  801670:	5d                   	pop    %ebp
  801671:	c3                   	ret    

00801672 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801672:	f3 0f 1e fb          	endbr32 
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801679:	8b 45 08             	mov    0x8(%ebp),%eax
  80167c:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801681:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801686:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80168b:	5d                   	pop    %ebp
  80168c:	c3                   	ret    

0080168d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80168d:	f3 0f 1e fb          	endbr32 
  801691:	55                   	push   %ebp
  801692:	89 e5                	mov    %esp,%ebp
  801694:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801699:	89 c2                	mov    %eax,%edx
  80169b:	c1 ea 16             	shr    $0x16,%edx
  80169e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8016a5:	f6 c2 01             	test   $0x1,%dl
  8016a8:	74 2d                	je     8016d7 <fd_alloc+0x4a>
  8016aa:	89 c2                	mov    %eax,%edx
  8016ac:	c1 ea 0c             	shr    $0xc,%edx
  8016af:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016b6:	f6 c2 01             	test   $0x1,%dl
  8016b9:	74 1c                	je     8016d7 <fd_alloc+0x4a>
  8016bb:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8016c0:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8016c5:	75 d2                	jne    801699 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8016c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8016d0:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8016d5:	eb 0a                	jmp    8016e1 <fd_alloc+0x54>
			*fd_store = fd;
  8016d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016da:	89 01                	mov    %eax,(%ecx)
			return 0;
  8016dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016e1:	5d                   	pop    %ebp
  8016e2:	c3                   	ret    

008016e3 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8016e3:	f3 0f 1e fb          	endbr32 
  8016e7:	55                   	push   %ebp
  8016e8:	89 e5                	mov    %esp,%ebp
  8016ea:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8016ed:	83 f8 1f             	cmp    $0x1f,%eax
  8016f0:	77 30                	ja     801722 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8016f2:	c1 e0 0c             	shl    $0xc,%eax
  8016f5:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8016fa:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801700:	f6 c2 01             	test   $0x1,%dl
  801703:	74 24                	je     801729 <fd_lookup+0x46>
  801705:	89 c2                	mov    %eax,%edx
  801707:	c1 ea 0c             	shr    $0xc,%edx
  80170a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801711:	f6 c2 01             	test   $0x1,%dl
  801714:	74 1a                	je     801730 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801716:	8b 55 0c             	mov    0xc(%ebp),%edx
  801719:	89 02                	mov    %eax,(%edx)
	return 0;
  80171b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801720:	5d                   	pop    %ebp
  801721:	c3                   	ret    
		return -E_INVAL;
  801722:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801727:	eb f7                	jmp    801720 <fd_lookup+0x3d>
		return -E_INVAL;
  801729:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80172e:	eb f0                	jmp    801720 <fd_lookup+0x3d>
  801730:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801735:	eb e9                	jmp    801720 <fd_lookup+0x3d>

00801737 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801737:	f3 0f 1e fb          	endbr32 
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
  80173e:	83 ec 08             	sub    $0x8,%esp
  801741:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801744:	ba 00 00 00 00       	mov    $0x0,%edx
  801749:	b8 24 40 80 00       	mov    $0x804024,%eax
		if (devtab[i]->dev_id == dev_id) {
  80174e:	39 08                	cmp    %ecx,(%eax)
  801750:	74 38                	je     80178a <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  801752:	83 c2 01             	add    $0x1,%edx
  801755:	8b 04 95 a8 34 80 00 	mov    0x8034a8(,%edx,4),%eax
  80175c:	85 c0                	test   %eax,%eax
  80175e:	75 ee                	jne    80174e <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801760:	a1 1c 50 80 00       	mov    0x80501c,%eax
  801765:	8b 40 48             	mov    0x48(%eax),%eax
  801768:	83 ec 04             	sub    $0x4,%esp
  80176b:	51                   	push   %ecx
  80176c:	50                   	push   %eax
  80176d:	68 2c 34 80 00       	push   $0x80342c
  801772:	e8 db f1 ff ff       	call   800952 <cprintf>
	*dev = 0;
  801777:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801780:	83 c4 10             	add    $0x10,%esp
  801783:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801788:	c9                   	leave  
  801789:	c3                   	ret    
			*dev = devtab[i];
  80178a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80178d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80178f:	b8 00 00 00 00       	mov    $0x0,%eax
  801794:	eb f2                	jmp    801788 <dev_lookup+0x51>

00801796 <fd_close>:
{
  801796:	f3 0f 1e fb          	endbr32 
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
  80179d:	57                   	push   %edi
  80179e:	56                   	push   %esi
  80179f:	53                   	push   %ebx
  8017a0:	83 ec 24             	sub    $0x24,%esp
  8017a3:	8b 75 08             	mov    0x8(%ebp),%esi
  8017a6:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017a9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017ac:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017ad:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8017b3:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017b6:	50                   	push   %eax
  8017b7:	e8 27 ff ff ff       	call   8016e3 <fd_lookup>
  8017bc:	89 c3                	mov    %eax,%ebx
  8017be:	83 c4 10             	add    $0x10,%esp
  8017c1:	85 c0                	test   %eax,%eax
  8017c3:	78 05                	js     8017ca <fd_close+0x34>
	    || fd != fd2)
  8017c5:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8017c8:	74 16                	je     8017e0 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8017ca:	89 f8                	mov    %edi,%eax
  8017cc:	84 c0                	test   %al,%al
  8017ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d3:	0f 44 d8             	cmove  %eax,%ebx
}
  8017d6:	89 d8                	mov    %ebx,%eax
  8017d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017db:	5b                   	pop    %ebx
  8017dc:	5e                   	pop    %esi
  8017dd:	5f                   	pop    %edi
  8017de:	5d                   	pop    %ebp
  8017df:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8017e0:	83 ec 08             	sub    $0x8,%esp
  8017e3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8017e6:	50                   	push   %eax
  8017e7:	ff 36                	pushl  (%esi)
  8017e9:	e8 49 ff ff ff       	call   801737 <dev_lookup>
  8017ee:	89 c3                	mov    %eax,%ebx
  8017f0:	83 c4 10             	add    $0x10,%esp
  8017f3:	85 c0                	test   %eax,%eax
  8017f5:	78 1a                	js     801811 <fd_close+0x7b>
		if (dev->dev_close)
  8017f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017fa:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8017fd:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801802:	85 c0                	test   %eax,%eax
  801804:	74 0b                	je     801811 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801806:	83 ec 0c             	sub    $0xc,%esp
  801809:	56                   	push   %esi
  80180a:	ff d0                	call   *%eax
  80180c:	89 c3                	mov    %eax,%ebx
  80180e:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801811:	83 ec 08             	sub    $0x8,%esp
  801814:	56                   	push   %esi
  801815:	6a 00                	push   $0x0
  801817:	e8 0f fc ff ff       	call   80142b <sys_page_unmap>
	return r;
  80181c:	83 c4 10             	add    $0x10,%esp
  80181f:	eb b5                	jmp    8017d6 <fd_close+0x40>

00801821 <close>:

int
close(int fdnum)
{
  801821:	f3 0f 1e fb          	endbr32 
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
  801828:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80182b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80182e:	50                   	push   %eax
  80182f:	ff 75 08             	pushl  0x8(%ebp)
  801832:	e8 ac fe ff ff       	call   8016e3 <fd_lookup>
  801837:	83 c4 10             	add    $0x10,%esp
  80183a:	85 c0                	test   %eax,%eax
  80183c:	79 02                	jns    801840 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80183e:	c9                   	leave  
  80183f:	c3                   	ret    
		return fd_close(fd, 1);
  801840:	83 ec 08             	sub    $0x8,%esp
  801843:	6a 01                	push   $0x1
  801845:	ff 75 f4             	pushl  -0xc(%ebp)
  801848:	e8 49 ff ff ff       	call   801796 <fd_close>
  80184d:	83 c4 10             	add    $0x10,%esp
  801850:	eb ec                	jmp    80183e <close+0x1d>

00801852 <close_all>:

void
close_all(void)
{
  801852:	f3 0f 1e fb          	endbr32 
  801856:	55                   	push   %ebp
  801857:	89 e5                	mov    %esp,%ebp
  801859:	53                   	push   %ebx
  80185a:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80185d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801862:	83 ec 0c             	sub    $0xc,%esp
  801865:	53                   	push   %ebx
  801866:	e8 b6 ff ff ff       	call   801821 <close>
	for (i = 0; i < MAXFD; i++)
  80186b:	83 c3 01             	add    $0x1,%ebx
  80186e:	83 c4 10             	add    $0x10,%esp
  801871:	83 fb 20             	cmp    $0x20,%ebx
  801874:	75 ec                	jne    801862 <close_all+0x10>
}
  801876:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801879:	c9                   	leave  
  80187a:	c3                   	ret    

0080187b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80187b:	f3 0f 1e fb          	endbr32 
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
  801882:	57                   	push   %edi
  801883:	56                   	push   %esi
  801884:	53                   	push   %ebx
  801885:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801888:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80188b:	50                   	push   %eax
  80188c:	ff 75 08             	pushl  0x8(%ebp)
  80188f:	e8 4f fe ff ff       	call   8016e3 <fd_lookup>
  801894:	89 c3                	mov    %eax,%ebx
  801896:	83 c4 10             	add    $0x10,%esp
  801899:	85 c0                	test   %eax,%eax
  80189b:	0f 88 81 00 00 00    	js     801922 <dup+0xa7>
		return r;
	close(newfdnum);
  8018a1:	83 ec 0c             	sub    $0xc,%esp
  8018a4:	ff 75 0c             	pushl  0xc(%ebp)
  8018a7:	e8 75 ff ff ff       	call   801821 <close>

	newfd = INDEX2FD(newfdnum);
  8018ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  8018af:	c1 e6 0c             	shl    $0xc,%esi
  8018b2:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8018b8:	83 c4 04             	add    $0x4,%esp
  8018bb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018be:	e8 af fd ff ff       	call   801672 <fd2data>
  8018c3:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8018c5:	89 34 24             	mov    %esi,(%esp)
  8018c8:	e8 a5 fd ff ff       	call   801672 <fd2data>
  8018cd:	83 c4 10             	add    $0x10,%esp
  8018d0:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8018d2:	89 d8                	mov    %ebx,%eax
  8018d4:	c1 e8 16             	shr    $0x16,%eax
  8018d7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8018de:	a8 01                	test   $0x1,%al
  8018e0:	74 11                	je     8018f3 <dup+0x78>
  8018e2:	89 d8                	mov    %ebx,%eax
  8018e4:	c1 e8 0c             	shr    $0xc,%eax
  8018e7:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8018ee:	f6 c2 01             	test   $0x1,%dl
  8018f1:	75 39                	jne    80192c <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8018f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8018f6:	89 d0                	mov    %edx,%eax
  8018f8:	c1 e8 0c             	shr    $0xc,%eax
  8018fb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801902:	83 ec 0c             	sub    $0xc,%esp
  801905:	25 07 0e 00 00       	and    $0xe07,%eax
  80190a:	50                   	push   %eax
  80190b:	56                   	push   %esi
  80190c:	6a 00                	push   $0x0
  80190e:	52                   	push   %edx
  80190f:	6a 00                	push   $0x0
  801911:	e8 cf fa ff ff       	call   8013e5 <sys_page_map>
  801916:	89 c3                	mov    %eax,%ebx
  801918:	83 c4 20             	add    $0x20,%esp
  80191b:	85 c0                	test   %eax,%eax
  80191d:	78 31                	js     801950 <dup+0xd5>
		goto err;

	return newfdnum;
  80191f:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801922:	89 d8                	mov    %ebx,%eax
  801924:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801927:	5b                   	pop    %ebx
  801928:	5e                   	pop    %esi
  801929:	5f                   	pop    %edi
  80192a:	5d                   	pop    %ebp
  80192b:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80192c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801933:	83 ec 0c             	sub    $0xc,%esp
  801936:	25 07 0e 00 00       	and    $0xe07,%eax
  80193b:	50                   	push   %eax
  80193c:	57                   	push   %edi
  80193d:	6a 00                	push   $0x0
  80193f:	53                   	push   %ebx
  801940:	6a 00                	push   $0x0
  801942:	e8 9e fa ff ff       	call   8013e5 <sys_page_map>
  801947:	89 c3                	mov    %eax,%ebx
  801949:	83 c4 20             	add    $0x20,%esp
  80194c:	85 c0                	test   %eax,%eax
  80194e:	79 a3                	jns    8018f3 <dup+0x78>
	sys_page_unmap(0, newfd);
  801950:	83 ec 08             	sub    $0x8,%esp
  801953:	56                   	push   %esi
  801954:	6a 00                	push   $0x0
  801956:	e8 d0 fa ff ff       	call   80142b <sys_page_unmap>
	sys_page_unmap(0, nva);
  80195b:	83 c4 08             	add    $0x8,%esp
  80195e:	57                   	push   %edi
  80195f:	6a 00                	push   $0x0
  801961:	e8 c5 fa ff ff       	call   80142b <sys_page_unmap>
	return r;
  801966:	83 c4 10             	add    $0x10,%esp
  801969:	eb b7                	jmp    801922 <dup+0xa7>

0080196b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80196b:	f3 0f 1e fb          	endbr32 
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
  801972:	53                   	push   %ebx
  801973:	83 ec 1c             	sub    $0x1c,%esp
  801976:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801979:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80197c:	50                   	push   %eax
  80197d:	53                   	push   %ebx
  80197e:	e8 60 fd ff ff       	call   8016e3 <fd_lookup>
  801983:	83 c4 10             	add    $0x10,%esp
  801986:	85 c0                	test   %eax,%eax
  801988:	78 3f                	js     8019c9 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80198a:	83 ec 08             	sub    $0x8,%esp
  80198d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801990:	50                   	push   %eax
  801991:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801994:	ff 30                	pushl  (%eax)
  801996:	e8 9c fd ff ff       	call   801737 <dev_lookup>
  80199b:	83 c4 10             	add    $0x10,%esp
  80199e:	85 c0                	test   %eax,%eax
  8019a0:	78 27                	js     8019c9 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8019a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019a5:	8b 42 08             	mov    0x8(%edx),%eax
  8019a8:	83 e0 03             	and    $0x3,%eax
  8019ab:	83 f8 01             	cmp    $0x1,%eax
  8019ae:	74 1e                	je     8019ce <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8019b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b3:	8b 40 08             	mov    0x8(%eax),%eax
  8019b6:	85 c0                	test   %eax,%eax
  8019b8:	74 35                	je     8019ef <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8019ba:	83 ec 04             	sub    $0x4,%esp
  8019bd:	ff 75 10             	pushl  0x10(%ebp)
  8019c0:	ff 75 0c             	pushl  0xc(%ebp)
  8019c3:	52                   	push   %edx
  8019c4:	ff d0                	call   *%eax
  8019c6:	83 c4 10             	add    $0x10,%esp
}
  8019c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019cc:	c9                   	leave  
  8019cd:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8019ce:	a1 1c 50 80 00       	mov    0x80501c,%eax
  8019d3:	8b 40 48             	mov    0x48(%eax),%eax
  8019d6:	83 ec 04             	sub    $0x4,%esp
  8019d9:	53                   	push   %ebx
  8019da:	50                   	push   %eax
  8019db:	68 6d 34 80 00       	push   $0x80346d
  8019e0:	e8 6d ef ff ff       	call   800952 <cprintf>
		return -E_INVAL;
  8019e5:	83 c4 10             	add    $0x10,%esp
  8019e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019ed:	eb da                	jmp    8019c9 <read+0x5e>
		return -E_NOT_SUPP;
  8019ef:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019f4:	eb d3                	jmp    8019c9 <read+0x5e>

008019f6 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8019f6:	f3 0f 1e fb          	endbr32 
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
  8019fd:	57                   	push   %edi
  8019fe:	56                   	push   %esi
  8019ff:	53                   	push   %ebx
  801a00:	83 ec 0c             	sub    $0xc,%esp
  801a03:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a06:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a09:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a0e:	eb 02                	jmp    801a12 <readn+0x1c>
  801a10:	01 c3                	add    %eax,%ebx
  801a12:	39 f3                	cmp    %esi,%ebx
  801a14:	73 21                	jae    801a37 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a16:	83 ec 04             	sub    $0x4,%esp
  801a19:	89 f0                	mov    %esi,%eax
  801a1b:	29 d8                	sub    %ebx,%eax
  801a1d:	50                   	push   %eax
  801a1e:	89 d8                	mov    %ebx,%eax
  801a20:	03 45 0c             	add    0xc(%ebp),%eax
  801a23:	50                   	push   %eax
  801a24:	57                   	push   %edi
  801a25:	e8 41 ff ff ff       	call   80196b <read>
		if (m < 0)
  801a2a:	83 c4 10             	add    $0x10,%esp
  801a2d:	85 c0                	test   %eax,%eax
  801a2f:	78 04                	js     801a35 <readn+0x3f>
			return m;
		if (m == 0)
  801a31:	75 dd                	jne    801a10 <readn+0x1a>
  801a33:	eb 02                	jmp    801a37 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a35:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801a37:	89 d8                	mov    %ebx,%eax
  801a39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a3c:	5b                   	pop    %ebx
  801a3d:	5e                   	pop    %esi
  801a3e:	5f                   	pop    %edi
  801a3f:	5d                   	pop    %ebp
  801a40:	c3                   	ret    

00801a41 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a41:	f3 0f 1e fb          	endbr32 
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
  801a48:	53                   	push   %ebx
  801a49:	83 ec 1c             	sub    $0x1c,%esp
  801a4c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a4f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a52:	50                   	push   %eax
  801a53:	53                   	push   %ebx
  801a54:	e8 8a fc ff ff       	call   8016e3 <fd_lookup>
  801a59:	83 c4 10             	add    $0x10,%esp
  801a5c:	85 c0                	test   %eax,%eax
  801a5e:	78 3a                	js     801a9a <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a60:	83 ec 08             	sub    $0x8,%esp
  801a63:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a66:	50                   	push   %eax
  801a67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a6a:	ff 30                	pushl  (%eax)
  801a6c:	e8 c6 fc ff ff       	call   801737 <dev_lookup>
  801a71:	83 c4 10             	add    $0x10,%esp
  801a74:	85 c0                	test   %eax,%eax
  801a76:	78 22                	js     801a9a <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a7b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a7f:	74 1e                	je     801a9f <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a84:	8b 52 0c             	mov    0xc(%edx),%edx
  801a87:	85 d2                	test   %edx,%edx
  801a89:	74 35                	je     801ac0 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a8b:	83 ec 04             	sub    $0x4,%esp
  801a8e:	ff 75 10             	pushl  0x10(%ebp)
  801a91:	ff 75 0c             	pushl  0xc(%ebp)
  801a94:	50                   	push   %eax
  801a95:	ff d2                	call   *%edx
  801a97:	83 c4 10             	add    $0x10,%esp
}
  801a9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a9d:	c9                   	leave  
  801a9e:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a9f:	a1 1c 50 80 00       	mov    0x80501c,%eax
  801aa4:	8b 40 48             	mov    0x48(%eax),%eax
  801aa7:	83 ec 04             	sub    $0x4,%esp
  801aaa:	53                   	push   %ebx
  801aab:	50                   	push   %eax
  801aac:	68 89 34 80 00       	push   $0x803489
  801ab1:	e8 9c ee ff ff       	call   800952 <cprintf>
		return -E_INVAL;
  801ab6:	83 c4 10             	add    $0x10,%esp
  801ab9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801abe:	eb da                	jmp    801a9a <write+0x59>
		return -E_NOT_SUPP;
  801ac0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ac5:	eb d3                	jmp    801a9a <write+0x59>

00801ac7 <seek>:

int
seek(int fdnum, off_t offset)
{
  801ac7:	f3 0f 1e fb          	endbr32 
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
  801ace:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ad1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ad4:	50                   	push   %eax
  801ad5:	ff 75 08             	pushl  0x8(%ebp)
  801ad8:	e8 06 fc ff ff       	call   8016e3 <fd_lookup>
  801add:	83 c4 10             	add    $0x10,%esp
  801ae0:	85 c0                	test   %eax,%eax
  801ae2:	78 0e                	js     801af2 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801ae4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aea:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801aed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801af2:	c9                   	leave  
  801af3:	c3                   	ret    

00801af4 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801af4:	f3 0f 1e fb          	endbr32 
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
  801afb:	53                   	push   %ebx
  801afc:	83 ec 1c             	sub    $0x1c,%esp
  801aff:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b02:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b05:	50                   	push   %eax
  801b06:	53                   	push   %ebx
  801b07:	e8 d7 fb ff ff       	call   8016e3 <fd_lookup>
  801b0c:	83 c4 10             	add    $0x10,%esp
  801b0f:	85 c0                	test   %eax,%eax
  801b11:	78 37                	js     801b4a <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b13:	83 ec 08             	sub    $0x8,%esp
  801b16:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b19:	50                   	push   %eax
  801b1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b1d:	ff 30                	pushl  (%eax)
  801b1f:	e8 13 fc ff ff       	call   801737 <dev_lookup>
  801b24:	83 c4 10             	add    $0x10,%esp
  801b27:	85 c0                	test   %eax,%eax
  801b29:	78 1f                	js     801b4a <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b2e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b32:	74 1b                	je     801b4f <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801b34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b37:	8b 52 18             	mov    0x18(%edx),%edx
  801b3a:	85 d2                	test   %edx,%edx
  801b3c:	74 32                	je     801b70 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b3e:	83 ec 08             	sub    $0x8,%esp
  801b41:	ff 75 0c             	pushl  0xc(%ebp)
  801b44:	50                   	push   %eax
  801b45:	ff d2                	call   *%edx
  801b47:	83 c4 10             	add    $0x10,%esp
}
  801b4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b4d:	c9                   	leave  
  801b4e:	c3                   	ret    
			thisenv->env_id, fdnum);
  801b4f:	a1 1c 50 80 00       	mov    0x80501c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b54:	8b 40 48             	mov    0x48(%eax),%eax
  801b57:	83 ec 04             	sub    $0x4,%esp
  801b5a:	53                   	push   %ebx
  801b5b:	50                   	push   %eax
  801b5c:	68 4c 34 80 00       	push   $0x80344c
  801b61:	e8 ec ed ff ff       	call   800952 <cprintf>
		return -E_INVAL;
  801b66:	83 c4 10             	add    $0x10,%esp
  801b69:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b6e:	eb da                	jmp    801b4a <ftruncate+0x56>
		return -E_NOT_SUPP;
  801b70:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b75:	eb d3                	jmp    801b4a <ftruncate+0x56>

00801b77 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b77:	f3 0f 1e fb          	endbr32 
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
  801b7e:	53                   	push   %ebx
  801b7f:	83 ec 1c             	sub    $0x1c,%esp
  801b82:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b85:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b88:	50                   	push   %eax
  801b89:	ff 75 08             	pushl  0x8(%ebp)
  801b8c:	e8 52 fb ff ff       	call   8016e3 <fd_lookup>
  801b91:	83 c4 10             	add    $0x10,%esp
  801b94:	85 c0                	test   %eax,%eax
  801b96:	78 4b                	js     801be3 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b98:	83 ec 08             	sub    $0x8,%esp
  801b9b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b9e:	50                   	push   %eax
  801b9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ba2:	ff 30                	pushl  (%eax)
  801ba4:	e8 8e fb ff ff       	call   801737 <dev_lookup>
  801ba9:	83 c4 10             	add    $0x10,%esp
  801bac:	85 c0                	test   %eax,%eax
  801bae:	78 33                	js     801be3 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801bb7:	74 2f                	je     801be8 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801bb9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801bbc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801bc3:	00 00 00 
	stat->st_isdir = 0;
  801bc6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bcd:	00 00 00 
	stat->st_dev = dev;
  801bd0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801bd6:	83 ec 08             	sub    $0x8,%esp
  801bd9:	53                   	push   %ebx
  801bda:	ff 75 f0             	pushl  -0x10(%ebp)
  801bdd:	ff 50 14             	call   *0x14(%eax)
  801be0:	83 c4 10             	add    $0x10,%esp
}
  801be3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801be6:	c9                   	leave  
  801be7:	c3                   	ret    
		return -E_NOT_SUPP;
  801be8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bed:	eb f4                	jmp    801be3 <fstat+0x6c>

00801bef <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801bef:	f3 0f 1e fb          	endbr32 
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
  801bf6:	56                   	push   %esi
  801bf7:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801bf8:	83 ec 08             	sub    $0x8,%esp
  801bfb:	6a 00                	push   $0x0
  801bfd:	ff 75 08             	pushl  0x8(%ebp)
  801c00:	e8 fb 01 00 00       	call   801e00 <open>
  801c05:	89 c3                	mov    %eax,%ebx
  801c07:	83 c4 10             	add    $0x10,%esp
  801c0a:	85 c0                	test   %eax,%eax
  801c0c:	78 1b                	js     801c29 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801c0e:	83 ec 08             	sub    $0x8,%esp
  801c11:	ff 75 0c             	pushl  0xc(%ebp)
  801c14:	50                   	push   %eax
  801c15:	e8 5d ff ff ff       	call   801b77 <fstat>
  801c1a:	89 c6                	mov    %eax,%esi
	close(fd);
  801c1c:	89 1c 24             	mov    %ebx,(%esp)
  801c1f:	e8 fd fb ff ff       	call   801821 <close>
	return r;
  801c24:	83 c4 10             	add    $0x10,%esp
  801c27:	89 f3                	mov    %esi,%ebx
}
  801c29:	89 d8                	mov    %ebx,%eax
  801c2b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c2e:	5b                   	pop    %ebx
  801c2f:	5e                   	pop    %esi
  801c30:	5d                   	pop    %ebp
  801c31:	c3                   	ret    

00801c32 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
  801c35:	56                   	push   %esi
  801c36:	53                   	push   %ebx
  801c37:	89 c6                	mov    %eax,%esi
  801c39:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801c3b:	83 3d 10 50 80 00 00 	cmpl   $0x0,0x805010
  801c42:	74 27                	je     801c6b <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c44:	6a 07                	push   $0x7
  801c46:	68 00 60 80 00       	push   $0x806000
  801c4b:	56                   	push   %esi
  801c4c:	ff 35 10 50 80 00    	pushl  0x805010
  801c52:	e8 33 0f 00 00       	call   802b8a <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c57:	83 c4 0c             	add    $0xc,%esp
  801c5a:	6a 00                	push   $0x0
  801c5c:	53                   	push   %ebx
  801c5d:	6a 00                	push   $0x0
  801c5f:	e8 a1 0e 00 00       	call   802b05 <ipc_recv>
}
  801c64:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c67:	5b                   	pop    %ebx
  801c68:	5e                   	pop    %esi
  801c69:	5d                   	pop    %ebp
  801c6a:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c6b:	83 ec 0c             	sub    $0xc,%esp
  801c6e:	6a 01                	push   $0x1
  801c70:	e8 6d 0f 00 00       	call   802be2 <ipc_find_env>
  801c75:	a3 10 50 80 00       	mov    %eax,0x805010
  801c7a:	83 c4 10             	add    $0x10,%esp
  801c7d:	eb c5                	jmp    801c44 <fsipc+0x12>

00801c7f <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c7f:	f3 0f 1e fb          	endbr32 
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
  801c86:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c89:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8c:	8b 40 0c             	mov    0xc(%eax),%eax
  801c8f:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801c94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c97:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c9c:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca1:	b8 02 00 00 00       	mov    $0x2,%eax
  801ca6:	e8 87 ff ff ff       	call   801c32 <fsipc>
}
  801cab:	c9                   	leave  
  801cac:	c3                   	ret    

00801cad <devfile_flush>:
{
  801cad:	f3 0f 1e fb          	endbr32 
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
  801cb4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cba:	8b 40 0c             	mov    0xc(%eax),%eax
  801cbd:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801cc2:	ba 00 00 00 00       	mov    $0x0,%edx
  801cc7:	b8 06 00 00 00       	mov    $0x6,%eax
  801ccc:	e8 61 ff ff ff       	call   801c32 <fsipc>
}
  801cd1:	c9                   	leave  
  801cd2:	c3                   	ret    

00801cd3 <devfile_stat>:
{
  801cd3:	f3 0f 1e fb          	endbr32 
  801cd7:	55                   	push   %ebp
  801cd8:	89 e5                	mov    %esp,%ebp
  801cda:	53                   	push   %ebx
  801cdb:	83 ec 04             	sub    $0x4,%esp
  801cde:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce4:	8b 40 0c             	mov    0xc(%eax),%eax
  801ce7:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801cec:	ba 00 00 00 00       	mov    $0x0,%edx
  801cf1:	b8 05 00 00 00       	mov    $0x5,%eax
  801cf6:	e8 37 ff ff ff       	call   801c32 <fsipc>
  801cfb:	85 c0                	test   %eax,%eax
  801cfd:	78 2c                	js     801d2b <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801cff:	83 ec 08             	sub    $0x8,%esp
  801d02:	68 00 60 80 00       	push   $0x806000
  801d07:	53                   	push   %ebx
  801d08:	e8 4f f2 ff ff       	call   800f5c <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801d0d:	a1 80 60 80 00       	mov    0x806080,%eax
  801d12:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d18:	a1 84 60 80 00       	mov    0x806084,%eax
  801d1d:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801d23:	83 c4 10             	add    $0x10,%esp
  801d26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d2e:	c9                   	leave  
  801d2f:	c3                   	ret    

00801d30 <devfile_write>:
{
  801d30:	f3 0f 1e fb          	endbr32 
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
  801d37:	83 ec 0c             	sub    $0xc,%esp
  801d3a:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801d3d:	8b 55 08             	mov    0x8(%ebp),%edx
  801d40:	8b 52 0c             	mov    0xc(%edx),%edx
  801d43:	89 15 00 60 80 00    	mov    %edx,0x806000
	n = n > sizeof(fsipcbuf.write.req_buf) ? sizeof(fsipcbuf.write.req_buf) : n;
  801d49:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801d4e:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801d53:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_n = n;
  801d56:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801d5b:	50                   	push   %eax
  801d5c:	ff 75 0c             	pushl  0xc(%ebp)
  801d5f:	68 08 60 80 00       	push   $0x806008
  801d64:	e8 a9 f3 ff ff       	call   801112 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801d69:	ba 00 00 00 00       	mov    $0x0,%edx
  801d6e:	b8 04 00 00 00       	mov    $0x4,%eax
  801d73:	e8 ba fe ff ff       	call   801c32 <fsipc>
}
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    

00801d7a <devfile_read>:
{
  801d7a:	f3 0f 1e fb          	endbr32 
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
  801d81:	56                   	push   %esi
  801d82:	53                   	push   %ebx
  801d83:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d86:	8b 45 08             	mov    0x8(%ebp),%eax
  801d89:	8b 40 0c             	mov    0xc(%eax),%eax
  801d8c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801d91:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801d97:	ba 00 00 00 00       	mov    $0x0,%edx
  801d9c:	b8 03 00 00 00       	mov    $0x3,%eax
  801da1:	e8 8c fe ff ff       	call   801c32 <fsipc>
  801da6:	89 c3                	mov    %eax,%ebx
  801da8:	85 c0                	test   %eax,%eax
  801daa:	78 1f                	js     801dcb <devfile_read+0x51>
	assert(r <= n);
  801dac:	39 f0                	cmp    %esi,%eax
  801dae:	77 24                	ja     801dd4 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801db0:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801db5:	7f 33                	jg     801dea <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801db7:	83 ec 04             	sub    $0x4,%esp
  801dba:	50                   	push   %eax
  801dbb:	68 00 60 80 00       	push   $0x806000
  801dc0:	ff 75 0c             	pushl  0xc(%ebp)
  801dc3:	e8 4a f3 ff ff       	call   801112 <memmove>
	return r;
  801dc8:	83 c4 10             	add    $0x10,%esp
}
  801dcb:	89 d8                	mov    %ebx,%eax
  801dcd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dd0:	5b                   	pop    %ebx
  801dd1:	5e                   	pop    %esi
  801dd2:	5d                   	pop    %ebp
  801dd3:	c3                   	ret    
	assert(r <= n);
  801dd4:	68 bc 34 80 00       	push   $0x8034bc
  801dd9:	68 c3 34 80 00       	push   $0x8034c3
  801dde:	6a 7c                	push   $0x7c
  801de0:	68 d8 34 80 00       	push   $0x8034d8
  801de5:	e8 81 ea ff ff       	call   80086b <_panic>
	assert(r <= PGSIZE);
  801dea:	68 e3 34 80 00       	push   $0x8034e3
  801def:	68 c3 34 80 00       	push   $0x8034c3
  801df4:	6a 7d                	push   $0x7d
  801df6:	68 d8 34 80 00       	push   $0x8034d8
  801dfb:	e8 6b ea ff ff       	call   80086b <_panic>

00801e00 <open>:
{
  801e00:	f3 0f 1e fb          	endbr32 
  801e04:	55                   	push   %ebp
  801e05:	89 e5                	mov    %esp,%ebp
  801e07:	56                   	push   %esi
  801e08:	53                   	push   %ebx
  801e09:	83 ec 1c             	sub    $0x1c,%esp
  801e0c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801e0f:	56                   	push   %esi
  801e10:	e8 04 f1 ff ff       	call   800f19 <strlen>
  801e15:	83 c4 10             	add    $0x10,%esp
  801e18:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e1d:	7f 6c                	jg     801e8b <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801e1f:	83 ec 0c             	sub    $0xc,%esp
  801e22:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e25:	50                   	push   %eax
  801e26:	e8 62 f8 ff ff       	call   80168d <fd_alloc>
  801e2b:	89 c3                	mov    %eax,%ebx
  801e2d:	83 c4 10             	add    $0x10,%esp
  801e30:	85 c0                	test   %eax,%eax
  801e32:	78 3c                	js     801e70 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801e34:	83 ec 08             	sub    $0x8,%esp
  801e37:	56                   	push   %esi
  801e38:	68 00 60 80 00       	push   $0x806000
  801e3d:	e8 1a f1 ff ff       	call   800f5c <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e42:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e45:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e4d:	b8 01 00 00 00       	mov    $0x1,%eax
  801e52:	e8 db fd ff ff       	call   801c32 <fsipc>
  801e57:	89 c3                	mov    %eax,%ebx
  801e59:	83 c4 10             	add    $0x10,%esp
  801e5c:	85 c0                	test   %eax,%eax
  801e5e:	78 19                	js     801e79 <open+0x79>
	return fd2num(fd);
  801e60:	83 ec 0c             	sub    $0xc,%esp
  801e63:	ff 75 f4             	pushl  -0xc(%ebp)
  801e66:	e8 f3 f7 ff ff       	call   80165e <fd2num>
  801e6b:	89 c3                	mov    %eax,%ebx
  801e6d:	83 c4 10             	add    $0x10,%esp
}
  801e70:	89 d8                	mov    %ebx,%eax
  801e72:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e75:	5b                   	pop    %ebx
  801e76:	5e                   	pop    %esi
  801e77:	5d                   	pop    %ebp
  801e78:	c3                   	ret    
		fd_close(fd, 0);
  801e79:	83 ec 08             	sub    $0x8,%esp
  801e7c:	6a 00                	push   $0x0
  801e7e:	ff 75 f4             	pushl  -0xc(%ebp)
  801e81:	e8 10 f9 ff ff       	call   801796 <fd_close>
		return r;
  801e86:	83 c4 10             	add    $0x10,%esp
  801e89:	eb e5                	jmp    801e70 <open+0x70>
		return -E_BAD_PATH;
  801e8b:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801e90:	eb de                	jmp    801e70 <open+0x70>

00801e92 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801e92:	f3 0f 1e fb          	endbr32 
  801e96:	55                   	push   %ebp
  801e97:	89 e5                	mov    %esp,%ebp
  801e99:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801e9c:	ba 00 00 00 00       	mov    $0x0,%edx
  801ea1:	b8 08 00 00 00       	mov    $0x8,%eax
  801ea6:	e8 87 fd ff ff       	call   801c32 <fsipc>
}
  801eab:	c9                   	leave  
  801eac:	c3                   	ret    

00801ead <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ead:	f3 0f 1e fb          	endbr32 
  801eb1:	55                   	push   %ebp
  801eb2:	89 e5                	mov    %esp,%ebp
  801eb4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801eb7:	68 ef 34 80 00       	push   $0x8034ef
  801ebc:	ff 75 0c             	pushl  0xc(%ebp)
  801ebf:	e8 98 f0 ff ff       	call   800f5c <strcpy>
	return 0;
}
  801ec4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec9:	c9                   	leave  
  801eca:	c3                   	ret    

00801ecb <devsock_close>:
{
  801ecb:	f3 0f 1e fb          	endbr32 
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
  801ed2:	53                   	push   %ebx
  801ed3:	83 ec 10             	sub    $0x10,%esp
  801ed6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801ed9:	53                   	push   %ebx
  801eda:	e8 40 0d 00 00       	call   802c1f <pageref>
  801edf:	89 c2                	mov    %eax,%edx
  801ee1:	83 c4 10             	add    $0x10,%esp
		return 0;
  801ee4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801ee9:	83 fa 01             	cmp    $0x1,%edx
  801eec:	74 05                	je     801ef3 <devsock_close+0x28>
}
  801eee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ef1:	c9                   	leave  
  801ef2:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801ef3:	83 ec 0c             	sub    $0xc,%esp
  801ef6:	ff 73 0c             	pushl  0xc(%ebx)
  801ef9:	e8 e3 02 00 00       	call   8021e1 <nsipc_close>
  801efe:	83 c4 10             	add    $0x10,%esp
  801f01:	eb eb                	jmp    801eee <devsock_close+0x23>

00801f03 <devsock_write>:
{
  801f03:	f3 0f 1e fb          	endbr32 
  801f07:	55                   	push   %ebp
  801f08:	89 e5                	mov    %esp,%ebp
  801f0a:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f0d:	6a 00                	push   $0x0
  801f0f:	ff 75 10             	pushl  0x10(%ebp)
  801f12:	ff 75 0c             	pushl  0xc(%ebp)
  801f15:	8b 45 08             	mov    0x8(%ebp),%eax
  801f18:	ff 70 0c             	pushl  0xc(%eax)
  801f1b:	e8 b5 03 00 00       	call   8022d5 <nsipc_send>
}
  801f20:	c9                   	leave  
  801f21:	c3                   	ret    

00801f22 <devsock_read>:
{
  801f22:	f3 0f 1e fb          	endbr32 
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
  801f29:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f2c:	6a 00                	push   $0x0
  801f2e:	ff 75 10             	pushl  0x10(%ebp)
  801f31:	ff 75 0c             	pushl  0xc(%ebp)
  801f34:	8b 45 08             	mov    0x8(%ebp),%eax
  801f37:	ff 70 0c             	pushl  0xc(%eax)
  801f3a:	e8 1f 03 00 00       	call   80225e <nsipc_recv>
}
  801f3f:	c9                   	leave  
  801f40:	c3                   	ret    

00801f41 <fd2sockid>:
{
  801f41:	55                   	push   %ebp
  801f42:	89 e5                	mov    %esp,%ebp
  801f44:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f47:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f4a:	52                   	push   %edx
  801f4b:	50                   	push   %eax
  801f4c:	e8 92 f7 ff ff       	call   8016e3 <fd_lookup>
  801f51:	83 c4 10             	add    $0x10,%esp
  801f54:	85 c0                	test   %eax,%eax
  801f56:	78 10                	js     801f68 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5b:	8b 0d 40 40 80 00    	mov    0x804040,%ecx
  801f61:	39 08                	cmp    %ecx,(%eax)
  801f63:	75 05                	jne    801f6a <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801f65:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801f68:	c9                   	leave  
  801f69:	c3                   	ret    
		return -E_NOT_SUPP;
  801f6a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f6f:	eb f7                	jmp    801f68 <fd2sockid+0x27>

00801f71 <alloc_sockfd>:
{
  801f71:	55                   	push   %ebp
  801f72:	89 e5                	mov    %esp,%ebp
  801f74:	56                   	push   %esi
  801f75:	53                   	push   %ebx
  801f76:	83 ec 1c             	sub    $0x1c,%esp
  801f79:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801f7b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f7e:	50                   	push   %eax
  801f7f:	e8 09 f7 ff ff       	call   80168d <fd_alloc>
  801f84:	89 c3                	mov    %eax,%ebx
  801f86:	83 c4 10             	add    $0x10,%esp
  801f89:	85 c0                	test   %eax,%eax
  801f8b:	78 43                	js     801fd0 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f8d:	83 ec 04             	sub    $0x4,%esp
  801f90:	68 07 04 00 00       	push   $0x407
  801f95:	ff 75 f4             	pushl  -0xc(%ebp)
  801f98:	6a 00                	push   $0x0
  801f9a:	e8 ff f3 ff ff       	call   80139e <sys_page_alloc>
  801f9f:	89 c3                	mov    %eax,%ebx
  801fa1:	83 c4 10             	add    $0x10,%esp
  801fa4:	85 c0                	test   %eax,%eax
  801fa6:	78 28                	js     801fd0 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fab:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801fb1:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801fbd:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801fc0:	83 ec 0c             	sub    $0xc,%esp
  801fc3:	50                   	push   %eax
  801fc4:	e8 95 f6 ff ff       	call   80165e <fd2num>
  801fc9:	89 c3                	mov    %eax,%ebx
  801fcb:	83 c4 10             	add    $0x10,%esp
  801fce:	eb 0c                	jmp    801fdc <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801fd0:	83 ec 0c             	sub    $0xc,%esp
  801fd3:	56                   	push   %esi
  801fd4:	e8 08 02 00 00       	call   8021e1 <nsipc_close>
		return r;
  801fd9:	83 c4 10             	add    $0x10,%esp
}
  801fdc:	89 d8                	mov    %ebx,%eax
  801fde:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fe1:	5b                   	pop    %ebx
  801fe2:	5e                   	pop    %esi
  801fe3:	5d                   	pop    %ebp
  801fe4:	c3                   	ret    

00801fe5 <accept>:
{
  801fe5:	f3 0f 1e fb          	endbr32 
  801fe9:	55                   	push   %ebp
  801fea:	89 e5                	mov    %esp,%ebp
  801fec:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801fef:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff2:	e8 4a ff ff ff       	call   801f41 <fd2sockid>
  801ff7:	85 c0                	test   %eax,%eax
  801ff9:	78 1b                	js     802016 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ffb:	83 ec 04             	sub    $0x4,%esp
  801ffe:	ff 75 10             	pushl  0x10(%ebp)
  802001:	ff 75 0c             	pushl  0xc(%ebp)
  802004:	50                   	push   %eax
  802005:	e8 22 01 00 00       	call   80212c <nsipc_accept>
  80200a:	83 c4 10             	add    $0x10,%esp
  80200d:	85 c0                	test   %eax,%eax
  80200f:	78 05                	js     802016 <accept+0x31>
	return alloc_sockfd(r);
  802011:	e8 5b ff ff ff       	call   801f71 <alloc_sockfd>
}
  802016:	c9                   	leave  
  802017:	c3                   	ret    

00802018 <bind>:
{
  802018:	f3 0f 1e fb          	endbr32 
  80201c:	55                   	push   %ebp
  80201d:	89 e5                	mov    %esp,%ebp
  80201f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802022:	8b 45 08             	mov    0x8(%ebp),%eax
  802025:	e8 17 ff ff ff       	call   801f41 <fd2sockid>
  80202a:	85 c0                	test   %eax,%eax
  80202c:	78 12                	js     802040 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  80202e:	83 ec 04             	sub    $0x4,%esp
  802031:	ff 75 10             	pushl  0x10(%ebp)
  802034:	ff 75 0c             	pushl  0xc(%ebp)
  802037:	50                   	push   %eax
  802038:	e8 45 01 00 00       	call   802182 <nsipc_bind>
  80203d:	83 c4 10             	add    $0x10,%esp
}
  802040:	c9                   	leave  
  802041:	c3                   	ret    

00802042 <shutdown>:
{
  802042:	f3 0f 1e fb          	endbr32 
  802046:	55                   	push   %ebp
  802047:	89 e5                	mov    %esp,%ebp
  802049:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80204c:	8b 45 08             	mov    0x8(%ebp),%eax
  80204f:	e8 ed fe ff ff       	call   801f41 <fd2sockid>
  802054:	85 c0                	test   %eax,%eax
  802056:	78 0f                	js     802067 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  802058:	83 ec 08             	sub    $0x8,%esp
  80205b:	ff 75 0c             	pushl  0xc(%ebp)
  80205e:	50                   	push   %eax
  80205f:	e8 57 01 00 00       	call   8021bb <nsipc_shutdown>
  802064:	83 c4 10             	add    $0x10,%esp
}
  802067:	c9                   	leave  
  802068:	c3                   	ret    

00802069 <connect>:
{
  802069:	f3 0f 1e fb          	endbr32 
  80206d:	55                   	push   %ebp
  80206e:	89 e5                	mov    %esp,%ebp
  802070:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802073:	8b 45 08             	mov    0x8(%ebp),%eax
  802076:	e8 c6 fe ff ff       	call   801f41 <fd2sockid>
  80207b:	85 c0                	test   %eax,%eax
  80207d:	78 12                	js     802091 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  80207f:	83 ec 04             	sub    $0x4,%esp
  802082:	ff 75 10             	pushl  0x10(%ebp)
  802085:	ff 75 0c             	pushl  0xc(%ebp)
  802088:	50                   	push   %eax
  802089:	e8 71 01 00 00       	call   8021ff <nsipc_connect>
  80208e:	83 c4 10             	add    $0x10,%esp
}
  802091:	c9                   	leave  
  802092:	c3                   	ret    

00802093 <listen>:
{
  802093:	f3 0f 1e fb          	endbr32 
  802097:	55                   	push   %ebp
  802098:	89 e5                	mov    %esp,%ebp
  80209a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80209d:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a0:	e8 9c fe ff ff       	call   801f41 <fd2sockid>
  8020a5:	85 c0                	test   %eax,%eax
  8020a7:	78 0f                	js     8020b8 <listen+0x25>
	return nsipc_listen(r, backlog);
  8020a9:	83 ec 08             	sub    $0x8,%esp
  8020ac:	ff 75 0c             	pushl  0xc(%ebp)
  8020af:	50                   	push   %eax
  8020b0:	e8 83 01 00 00       	call   802238 <nsipc_listen>
  8020b5:	83 c4 10             	add    $0x10,%esp
}
  8020b8:	c9                   	leave  
  8020b9:	c3                   	ret    

008020ba <socket>:

int
socket(int domain, int type, int protocol)
{
  8020ba:	f3 0f 1e fb          	endbr32 
  8020be:	55                   	push   %ebp
  8020bf:	89 e5                	mov    %esp,%ebp
  8020c1:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8020c4:	ff 75 10             	pushl  0x10(%ebp)
  8020c7:	ff 75 0c             	pushl  0xc(%ebp)
  8020ca:	ff 75 08             	pushl  0x8(%ebp)
  8020cd:	e8 65 02 00 00       	call   802337 <nsipc_socket>
  8020d2:	83 c4 10             	add    $0x10,%esp
  8020d5:	85 c0                	test   %eax,%eax
  8020d7:	78 05                	js     8020de <socket+0x24>
		return r;
	return alloc_sockfd(r);
  8020d9:	e8 93 fe ff ff       	call   801f71 <alloc_sockfd>
}
  8020de:	c9                   	leave  
  8020df:	c3                   	ret    

008020e0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8020e0:	55                   	push   %ebp
  8020e1:	89 e5                	mov    %esp,%ebp
  8020e3:	53                   	push   %ebx
  8020e4:	83 ec 04             	sub    $0x4,%esp
  8020e7:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8020e9:	83 3d 14 50 80 00 00 	cmpl   $0x0,0x805014
  8020f0:	74 26                	je     802118 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8020f2:	6a 07                	push   $0x7
  8020f4:	68 00 70 80 00       	push   $0x807000
  8020f9:	53                   	push   %ebx
  8020fa:	ff 35 14 50 80 00    	pushl  0x805014
  802100:	e8 85 0a 00 00       	call   802b8a <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802105:	83 c4 0c             	add    $0xc,%esp
  802108:	6a 00                	push   $0x0
  80210a:	6a 00                	push   $0x0
  80210c:	6a 00                	push   $0x0
  80210e:	e8 f2 09 00 00       	call   802b05 <ipc_recv>
}
  802113:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802116:	c9                   	leave  
  802117:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802118:	83 ec 0c             	sub    $0xc,%esp
  80211b:	6a 02                	push   $0x2
  80211d:	e8 c0 0a 00 00       	call   802be2 <ipc_find_env>
  802122:	a3 14 50 80 00       	mov    %eax,0x805014
  802127:	83 c4 10             	add    $0x10,%esp
  80212a:	eb c6                	jmp    8020f2 <nsipc+0x12>

0080212c <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80212c:	f3 0f 1e fb          	endbr32 
  802130:	55                   	push   %ebp
  802131:	89 e5                	mov    %esp,%ebp
  802133:	56                   	push   %esi
  802134:	53                   	push   %ebx
  802135:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802138:	8b 45 08             	mov    0x8(%ebp),%eax
  80213b:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802140:	8b 06                	mov    (%esi),%eax
  802142:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802147:	b8 01 00 00 00       	mov    $0x1,%eax
  80214c:	e8 8f ff ff ff       	call   8020e0 <nsipc>
  802151:	89 c3                	mov    %eax,%ebx
  802153:	85 c0                	test   %eax,%eax
  802155:	79 09                	jns    802160 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  802157:	89 d8                	mov    %ebx,%eax
  802159:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80215c:	5b                   	pop    %ebx
  80215d:	5e                   	pop    %esi
  80215e:	5d                   	pop    %ebp
  80215f:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802160:	83 ec 04             	sub    $0x4,%esp
  802163:	ff 35 10 70 80 00    	pushl  0x807010
  802169:	68 00 70 80 00       	push   $0x807000
  80216e:	ff 75 0c             	pushl  0xc(%ebp)
  802171:	e8 9c ef ff ff       	call   801112 <memmove>
		*addrlen = ret->ret_addrlen;
  802176:	a1 10 70 80 00       	mov    0x807010,%eax
  80217b:	89 06                	mov    %eax,(%esi)
  80217d:	83 c4 10             	add    $0x10,%esp
	return r;
  802180:	eb d5                	jmp    802157 <nsipc_accept+0x2b>

00802182 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802182:	f3 0f 1e fb          	endbr32 
  802186:	55                   	push   %ebp
  802187:	89 e5                	mov    %esp,%ebp
  802189:	53                   	push   %ebx
  80218a:	83 ec 08             	sub    $0x8,%esp
  80218d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802190:	8b 45 08             	mov    0x8(%ebp),%eax
  802193:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802198:	53                   	push   %ebx
  802199:	ff 75 0c             	pushl  0xc(%ebp)
  80219c:	68 04 70 80 00       	push   $0x807004
  8021a1:	e8 6c ef ff ff       	call   801112 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8021a6:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8021ac:	b8 02 00 00 00       	mov    $0x2,%eax
  8021b1:	e8 2a ff ff ff       	call   8020e0 <nsipc>
}
  8021b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021b9:	c9                   	leave  
  8021ba:	c3                   	ret    

008021bb <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8021bb:	f3 0f 1e fb          	endbr32 
  8021bf:	55                   	push   %ebp
  8021c0:	89 e5                	mov    %esp,%ebp
  8021c2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8021c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c8:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8021cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021d0:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8021d5:	b8 03 00 00 00       	mov    $0x3,%eax
  8021da:	e8 01 ff ff ff       	call   8020e0 <nsipc>
}
  8021df:	c9                   	leave  
  8021e0:	c3                   	ret    

008021e1 <nsipc_close>:

int
nsipc_close(int s)
{
  8021e1:	f3 0f 1e fb          	endbr32 
  8021e5:	55                   	push   %ebp
  8021e6:	89 e5                	mov    %esp,%ebp
  8021e8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8021eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ee:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8021f3:	b8 04 00 00 00       	mov    $0x4,%eax
  8021f8:	e8 e3 fe ff ff       	call   8020e0 <nsipc>
}
  8021fd:	c9                   	leave  
  8021fe:	c3                   	ret    

008021ff <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8021ff:	f3 0f 1e fb          	endbr32 
  802203:	55                   	push   %ebp
  802204:	89 e5                	mov    %esp,%ebp
  802206:	53                   	push   %ebx
  802207:	83 ec 08             	sub    $0x8,%esp
  80220a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80220d:	8b 45 08             	mov    0x8(%ebp),%eax
  802210:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802215:	53                   	push   %ebx
  802216:	ff 75 0c             	pushl  0xc(%ebp)
  802219:	68 04 70 80 00       	push   $0x807004
  80221e:	e8 ef ee ff ff       	call   801112 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802223:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802229:	b8 05 00 00 00       	mov    $0x5,%eax
  80222e:	e8 ad fe ff ff       	call   8020e0 <nsipc>
}
  802233:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802236:	c9                   	leave  
  802237:	c3                   	ret    

00802238 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802238:	f3 0f 1e fb          	endbr32 
  80223c:	55                   	push   %ebp
  80223d:	89 e5                	mov    %esp,%ebp
  80223f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802242:	8b 45 08             	mov    0x8(%ebp),%eax
  802245:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80224a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80224d:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802252:	b8 06 00 00 00       	mov    $0x6,%eax
  802257:	e8 84 fe ff ff       	call   8020e0 <nsipc>
}
  80225c:	c9                   	leave  
  80225d:	c3                   	ret    

0080225e <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80225e:	f3 0f 1e fb          	endbr32 
  802262:	55                   	push   %ebp
  802263:	89 e5                	mov    %esp,%ebp
  802265:	56                   	push   %esi
  802266:	53                   	push   %ebx
  802267:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80226a:	8b 45 08             	mov    0x8(%ebp),%eax
  80226d:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802272:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802278:	8b 45 14             	mov    0x14(%ebp),%eax
  80227b:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802280:	b8 07 00 00 00       	mov    $0x7,%eax
  802285:	e8 56 fe ff ff       	call   8020e0 <nsipc>
  80228a:	89 c3                	mov    %eax,%ebx
  80228c:	85 c0                	test   %eax,%eax
  80228e:	78 26                	js     8022b6 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  802290:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  802296:	b8 3f 06 00 00       	mov    $0x63f,%eax
  80229b:	0f 4e c6             	cmovle %esi,%eax
  80229e:	39 c3                	cmp    %eax,%ebx
  8022a0:	7f 1d                	jg     8022bf <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8022a2:	83 ec 04             	sub    $0x4,%esp
  8022a5:	53                   	push   %ebx
  8022a6:	68 00 70 80 00       	push   $0x807000
  8022ab:	ff 75 0c             	pushl  0xc(%ebp)
  8022ae:	e8 5f ee ff ff       	call   801112 <memmove>
  8022b3:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8022b6:	89 d8                	mov    %ebx,%eax
  8022b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022bb:	5b                   	pop    %ebx
  8022bc:	5e                   	pop    %esi
  8022bd:	5d                   	pop    %ebp
  8022be:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8022bf:	68 fb 34 80 00       	push   $0x8034fb
  8022c4:	68 c3 34 80 00       	push   $0x8034c3
  8022c9:	6a 62                	push   $0x62
  8022cb:	68 10 35 80 00       	push   $0x803510
  8022d0:	e8 96 e5 ff ff       	call   80086b <_panic>

008022d5 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8022d5:	f3 0f 1e fb          	endbr32 
  8022d9:	55                   	push   %ebp
  8022da:	89 e5                	mov    %esp,%ebp
  8022dc:	53                   	push   %ebx
  8022dd:	83 ec 04             	sub    $0x4,%esp
  8022e0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8022e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e6:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8022eb:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8022f1:	7f 2e                	jg     802321 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8022f3:	83 ec 04             	sub    $0x4,%esp
  8022f6:	53                   	push   %ebx
  8022f7:	ff 75 0c             	pushl  0xc(%ebp)
  8022fa:	68 0c 70 80 00       	push   $0x80700c
  8022ff:	e8 0e ee ff ff       	call   801112 <memmove>
	nsipcbuf.send.req_size = size;
  802304:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  80230a:	8b 45 14             	mov    0x14(%ebp),%eax
  80230d:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802312:	b8 08 00 00 00       	mov    $0x8,%eax
  802317:	e8 c4 fd ff ff       	call   8020e0 <nsipc>
}
  80231c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80231f:	c9                   	leave  
  802320:	c3                   	ret    
	assert(size < 1600);
  802321:	68 1c 35 80 00       	push   $0x80351c
  802326:	68 c3 34 80 00       	push   $0x8034c3
  80232b:	6a 6d                	push   $0x6d
  80232d:	68 10 35 80 00       	push   $0x803510
  802332:	e8 34 e5 ff ff       	call   80086b <_panic>

00802337 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802337:	f3 0f 1e fb          	endbr32 
  80233b:	55                   	push   %ebp
  80233c:	89 e5                	mov    %esp,%ebp
  80233e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802341:	8b 45 08             	mov    0x8(%ebp),%eax
  802344:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802349:	8b 45 0c             	mov    0xc(%ebp),%eax
  80234c:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802351:	8b 45 10             	mov    0x10(%ebp),%eax
  802354:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802359:	b8 09 00 00 00       	mov    $0x9,%eax
  80235e:	e8 7d fd ff ff       	call   8020e0 <nsipc>
}
  802363:	c9                   	leave  
  802364:	c3                   	ret    

00802365 <free>:
	return v;
}

void
free(void *v)
{
  802365:	f3 0f 1e fb          	endbr32 
  802369:	55                   	push   %ebp
  80236a:	89 e5                	mov    %esp,%ebp
  80236c:	53                   	push   %ebx
  80236d:	83 ec 04             	sub    $0x4,%esp
  802370:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint8_t *c;
	uint32_t *ref;

	if (v == 0)
  802373:	85 db                	test   %ebx,%ebx
  802375:	0f 84 85 00 00 00    	je     802400 <free+0x9b>
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  80237b:	8d 83 00 00 00 f8    	lea    -0x8000000(%ebx),%eax
  802381:	3d ff ff ff 07       	cmp    $0x7ffffff,%eax
  802386:	77 51                	ja     8023d9 <free+0x74>

	c = ROUNDDOWN(v, PGSIZE);
  802388:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  80238e:	89 d8                	mov    %ebx,%eax
  802390:	c1 e8 0c             	shr    $0xc,%eax
  802393:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80239a:	f6 c4 02             	test   $0x2,%ah
  80239d:	74 50                	je     8023ef <free+0x8a>
		sys_page_unmap(0, c);
  80239f:	83 ec 08             	sub    $0x8,%esp
  8023a2:	53                   	push   %ebx
  8023a3:	6a 00                	push   $0x0
  8023a5:	e8 81 f0 ff ff       	call   80142b <sys_page_unmap>
		c += PGSIZE;
  8023aa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		assert(mbegin <= c && c < mend);
  8023b0:	8d 83 00 00 00 f8    	lea    -0x8000000(%ebx),%eax
  8023b6:	83 c4 10             	add    $0x10,%esp
  8023b9:	3d ff ff ff 07       	cmp    $0x7ffffff,%eax
  8023be:	76 ce                	jbe    80238e <free+0x29>
  8023c0:	68 63 35 80 00       	push   $0x803563
  8023c5:	68 c3 34 80 00       	push   $0x8034c3
  8023ca:	68 81 00 00 00       	push   $0x81
  8023cf:	68 56 35 80 00       	push   $0x803556
  8023d4:	e8 92 e4 ff ff       	call   80086b <_panic>
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  8023d9:	68 28 35 80 00       	push   $0x803528
  8023de:	68 c3 34 80 00       	push   $0x8034c3
  8023e3:	6a 7a                	push   $0x7a
  8023e5:	68 56 35 80 00       	push   $0x803556
  8023ea:	e8 7c e4 ff ff       	call   80086b <_panic>
	/*
	 * c is just a piece of this page, so dec the ref count
	 * and maybe free the page.
	 */
	ref = (uint32_t*) (c + PGSIZE - 4);
	if (--(*ref) == 0)
  8023ef:	8b 83 fc 0f 00 00    	mov    0xffc(%ebx),%eax
  8023f5:	83 e8 01             	sub    $0x1,%eax
  8023f8:	89 83 fc 0f 00 00    	mov    %eax,0xffc(%ebx)
  8023fe:	74 05                	je     802405 <free+0xa0>
		sys_page_unmap(0, c);
}
  802400:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802403:	c9                   	leave  
  802404:	c3                   	ret    
		sys_page_unmap(0, c);
  802405:	83 ec 08             	sub    $0x8,%esp
  802408:	53                   	push   %ebx
  802409:	6a 00                	push   $0x0
  80240b:	e8 1b f0 ff ff       	call   80142b <sys_page_unmap>
  802410:	83 c4 10             	add    $0x10,%esp
  802413:	eb eb                	jmp    802400 <free+0x9b>

00802415 <malloc>:
{
  802415:	f3 0f 1e fb          	endbr32 
  802419:	55                   	push   %ebp
  80241a:	89 e5                	mov    %esp,%ebp
  80241c:	57                   	push   %edi
  80241d:	56                   	push   %esi
  80241e:	53                   	push   %ebx
  80241f:	83 ec 1c             	sub    $0x1c,%esp
	if (mptr == 0)
  802422:	a1 18 50 80 00       	mov    0x805018,%eax
  802427:	85 c0                	test   %eax,%eax
  802429:	74 74                	je     80249f <malloc+0x8a>
	n = ROUNDUP(n, 4);
  80242b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80242e:	8d 51 03             	lea    0x3(%ecx),%edx
  802431:	83 e2 fc             	and    $0xfffffffc,%edx
  802434:	89 d6                	mov    %edx,%esi
  802436:	89 55 dc             	mov    %edx,-0x24(%ebp)
	if (n >= MAXMALLOC)
  802439:	81 fa ff ff 0f 00    	cmp    $0xfffff,%edx
  80243f:	0f 87 12 01 00 00    	ja     802557 <malloc+0x142>
	if ((uintptr_t) mptr % PGSIZE){
  802445:	89 c1                	mov    %eax,%ecx
  802447:	a9 ff 0f 00 00       	test   $0xfff,%eax
  80244c:	74 30                	je     80247e <malloc+0x69>
		if ((uintptr_t) mptr / PGSIZE == (uintptr_t) (mptr + n - 1 + 4) / PGSIZE) {
  80244e:	89 c3                	mov    %eax,%ebx
  802450:	c1 eb 0c             	shr    $0xc,%ebx
  802453:	8d 54 10 03          	lea    0x3(%eax,%edx,1),%edx
  802457:	c1 ea 0c             	shr    $0xc,%edx
  80245a:	39 d3                	cmp    %edx,%ebx
  80245c:	74 64                	je     8024c2 <malloc+0xad>
		free(mptr);	/* drop reference to this page */
  80245e:	83 ec 0c             	sub    $0xc,%esp
  802461:	50                   	push   %eax
  802462:	e8 fe fe ff ff       	call   802365 <free>
		mptr = ROUNDDOWN(mptr + PGSIZE, PGSIZE);
  802467:	a1 18 50 80 00       	mov    0x805018,%eax
  80246c:	05 00 10 00 00       	add    $0x1000,%eax
  802471:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802476:	a3 18 50 80 00       	mov    %eax,0x805018
  80247b:	83 c4 10             	add    $0x10,%esp
  80247e:	8b 15 18 50 80 00    	mov    0x805018,%edx
{
  802484:	c7 45 d8 02 00 00 00 	movl   $0x2,-0x28(%ebp)
  80248b:	be 00 00 00 00       	mov    $0x0,%esi
		if (isfree(mptr, n + 4))
  802490:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802493:	8d 78 04             	lea    0x4(%eax),%edi
  802496:	c6 45 e3 01          	movb   $0x1,-0x1d(%ebp)
  80249a:	e9 86 00 00 00       	jmp    802525 <malloc+0x110>
		mptr = mbegin;
  80249f:	c7 05 18 50 80 00 00 	movl   $0x8000000,0x805018
  8024a6:	00 00 08 
	n = ROUNDUP(n, 4);
  8024a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024ac:	8d 51 03             	lea    0x3(%ecx),%edx
  8024af:	83 e2 fc             	and    $0xfffffffc,%edx
  8024b2:	89 55 dc             	mov    %edx,-0x24(%ebp)
	if (n >= MAXMALLOC)
  8024b5:	81 fa ff ff 0f 00    	cmp    $0xfffff,%edx
  8024bb:	76 c1                	jbe    80247e <malloc+0x69>
  8024bd:	e9 fb 00 00 00       	jmp    8025bd <malloc+0x1a8>
		ref = (uint32_t*) (ROUNDUP(mptr, PGSIZE) - 4);
  8024c2:	81 c1 ff 0f 00 00    	add    $0xfff,%ecx
  8024c8:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
			(*ref)++;
  8024ce:	83 41 fc 01          	addl   $0x1,-0x4(%ecx)
			mptr += n;
  8024d2:	89 f2                	mov    %esi,%edx
  8024d4:	01 c2                	add    %eax,%edx
  8024d6:	89 15 18 50 80 00    	mov    %edx,0x805018
			return v;
  8024dc:	e9 dc 00 00 00       	jmp    8025bd <malloc+0x1a8>
	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  8024e1:	05 00 10 00 00       	add    $0x1000,%eax
  8024e6:	39 c1                	cmp    %eax,%ecx
  8024e8:	76 74                	jbe    80255e <malloc+0x149>
		if (va >= (uintptr_t) mend
  8024ea:	3d ff ff ff 0f       	cmp    $0xfffffff,%eax
  8024ef:	77 22                	ja     802513 <malloc+0xfe>
		    || ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P)))
  8024f1:	89 c3                	mov    %eax,%ebx
  8024f3:	c1 eb 16             	shr    $0x16,%ebx
  8024f6:	8b 1c 9d 00 d0 7b ef 	mov    -0x10843000(,%ebx,4),%ebx
  8024fd:	f6 c3 01             	test   $0x1,%bl
  802500:	74 df                	je     8024e1 <malloc+0xcc>
  802502:	89 c3                	mov    %eax,%ebx
  802504:	c1 eb 0c             	shr    $0xc,%ebx
  802507:	8b 1c 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%ebx
  80250e:	f6 c3 01             	test   $0x1,%bl
  802511:	74 ce                	je     8024e1 <malloc+0xcc>
  802513:	81 c2 00 10 00 00    	add    $0x1000,%edx
  802519:	0f b6 75 e3          	movzbl -0x1d(%ebp),%esi
		if (mptr == mend) {
  80251d:	81 fa 00 00 00 10    	cmp    $0x10000000,%edx
  802523:	74 0a                	je     80252f <malloc+0x11a>
  802525:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  802528:	89 d0                	mov    %edx,%eax
  80252a:	8d 0c 17             	lea    (%edi,%edx,1),%ecx
  80252d:	eb b7                	jmp    8024e6 <malloc+0xd1>
			mptr = mbegin;
  80252f:	ba 00 00 00 08       	mov    $0x8000000,%edx
  802534:	be 01 00 00 00       	mov    $0x1,%esi
			if (++nwrap == 2)
  802539:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80253d:	75 e6                	jne    802525 <malloc+0x110>
  80253f:	c7 05 18 50 80 00 00 	movl   $0x8000000,0x805018
  802546:	00 00 08 
				return 0;	/* out of address space */
  802549:	b8 00 00 00 00       	mov    $0x0,%eax
  80254e:	eb 6d                	jmp    8025bd <malloc+0x1a8>
			return 0;	/* out of physical memory */
  802550:	b8 00 00 00 00       	mov    $0x0,%eax
  802555:	eb 66                	jmp    8025bd <malloc+0x1a8>
		return 0;
  802557:	b8 00 00 00 00       	mov    $0x0,%eax
  80255c:	eb 5f                	jmp    8025bd <malloc+0x1a8>
  80255e:	89 f0                	mov    %esi,%eax
  802560:	84 c0                	test   %al,%al
  802562:	74 08                	je     80256c <malloc+0x157>
  802564:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802567:	a3 18 50 80 00       	mov    %eax,0x805018
	for (i = 0; i < n + 4; i += PGSIZE){
  80256c:	bb 00 00 00 00       	mov    $0x0,%ebx
  802571:	89 de                	mov    %ebx,%esi
  802573:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
  802576:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80257c:	39 df                	cmp    %ebx,%edi
  80257e:	76 45                	jbe    8025c5 <malloc+0x1b0>
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  802580:	83 ec 04             	sub    $0x4,%esp
  802583:	68 07 02 00 00       	push   $0x207
  802588:	03 35 18 50 80 00    	add    0x805018,%esi
  80258e:	56                   	push   %esi
  80258f:	6a 00                	push   $0x0
  802591:	e8 08 ee ff ff       	call   80139e <sys_page_alloc>
  802596:	83 c4 10             	add    $0x10,%esp
  802599:	85 c0                	test   %eax,%eax
  80259b:	79 d4                	jns    802571 <malloc+0x15c>
  80259d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8025a0:	eb 42                	jmp    8025e4 <malloc+0x1cf>
	ref = (uint32_t*) (mptr + i - 4);
  8025a2:	a1 18 50 80 00       	mov    0x805018,%eax
	*ref = 2;	/* reference for mptr, reference for returned block */
  8025a7:	c7 84 30 fc 0f 00 00 	movl   $0x2,0xffc(%eax,%esi,1)
  8025ae:	02 00 00 00 
	mptr += n;
  8025b2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025b5:	01 c2                	add    %eax,%edx
  8025b7:	89 15 18 50 80 00    	mov    %edx,0x805018
}
  8025bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025c0:	5b                   	pop    %ebx
  8025c1:	5e                   	pop    %esi
  8025c2:	5f                   	pop    %edi
  8025c3:	5d                   	pop    %ebp
  8025c4:	c3                   	ret    
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  8025c5:	83 ec 04             	sub    $0x4,%esp
  8025c8:	6a 07                	push   $0x7
  8025ca:	89 f0                	mov    %esi,%eax
  8025cc:	03 05 18 50 80 00    	add    0x805018,%eax
  8025d2:	50                   	push   %eax
  8025d3:	6a 00                	push   $0x0
  8025d5:	e8 c4 ed ff ff       	call   80139e <sys_page_alloc>
  8025da:	83 c4 10             	add    $0x10,%esp
  8025dd:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8025e0:	85 c0                	test   %eax,%eax
  8025e2:	79 be                	jns    8025a2 <malloc+0x18d>
			for (; i >= 0; i -= PGSIZE)
  8025e4:	85 db                	test   %ebx,%ebx
  8025e6:	0f 88 64 ff ff ff    	js     802550 <malloc+0x13b>
				sys_page_unmap(0, mptr + i);
  8025ec:	83 ec 08             	sub    $0x8,%esp
  8025ef:	89 d8                	mov    %ebx,%eax
  8025f1:	03 05 18 50 80 00    	add    0x805018,%eax
  8025f7:	50                   	push   %eax
  8025f8:	6a 00                	push   $0x0
  8025fa:	e8 2c ee ff ff       	call   80142b <sys_page_unmap>
			for (; i >= 0; i -= PGSIZE)
  8025ff:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
  802605:	83 c4 10             	add    $0x10,%esp
  802608:	eb da                	jmp    8025e4 <malloc+0x1cf>

0080260a <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80260a:	f3 0f 1e fb          	endbr32 
  80260e:	55                   	push   %ebp
  80260f:	89 e5                	mov    %esp,%ebp
  802611:	56                   	push   %esi
  802612:	53                   	push   %ebx
  802613:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802616:	83 ec 0c             	sub    $0xc,%esp
  802619:	ff 75 08             	pushl  0x8(%ebp)
  80261c:	e8 51 f0 ff ff       	call   801672 <fd2data>
  802621:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802623:	83 c4 08             	add    $0x8,%esp
  802626:	68 7b 35 80 00       	push   $0x80357b
  80262b:	53                   	push   %ebx
  80262c:	e8 2b e9 ff ff       	call   800f5c <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802631:	8b 46 04             	mov    0x4(%esi),%eax
  802634:	2b 06                	sub    (%esi),%eax
  802636:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80263c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802643:	00 00 00 
	stat->st_dev = &devpipe;
  802646:	c7 83 88 00 00 00 5c 	movl   $0x80405c,0x88(%ebx)
  80264d:	40 80 00 
	return 0;
}
  802650:	b8 00 00 00 00       	mov    $0x0,%eax
  802655:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802658:	5b                   	pop    %ebx
  802659:	5e                   	pop    %esi
  80265a:	5d                   	pop    %ebp
  80265b:	c3                   	ret    

0080265c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80265c:	f3 0f 1e fb          	endbr32 
  802660:	55                   	push   %ebp
  802661:	89 e5                	mov    %esp,%ebp
  802663:	53                   	push   %ebx
  802664:	83 ec 0c             	sub    $0xc,%esp
  802667:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80266a:	53                   	push   %ebx
  80266b:	6a 00                	push   $0x0
  80266d:	e8 b9 ed ff ff       	call   80142b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802672:	89 1c 24             	mov    %ebx,(%esp)
  802675:	e8 f8 ef ff ff       	call   801672 <fd2data>
  80267a:	83 c4 08             	add    $0x8,%esp
  80267d:	50                   	push   %eax
  80267e:	6a 00                	push   $0x0
  802680:	e8 a6 ed ff ff       	call   80142b <sys_page_unmap>
}
  802685:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802688:	c9                   	leave  
  802689:	c3                   	ret    

0080268a <_pipeisclosed>:
{
  80268a:	55                   	push   %ebp
  80268b:	89 e5                	mov    %esp,%ebp
  80268d:	57                   	push   %edi
  80268e:	56                   	push   %esi
  80268f:	53                   	push   %ebx
  802690:	83 ec 1c             	sub    $0x1c,%esp
  802693:	89 c7                	mov    %eax,%edi
  802695:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802697:	a1 1c 50 80 00       	mov    0x80501c,%eax
  80269c:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80269f:	83 ec 0c             	sub    $0xc,%esp
  8026a2:	57                   	push   %edi
  8026a3:	e8 77 05 00 00       	call   802c1f <pageref>
  8026a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8026ab:	89 34 24             	mov    %esi,(%esp)
  8026ae:	e8 6c 05 00 00       	call   802c1f <pageref>
		nn = thisenv->env_runs;
  8026b3:	8b 15 1c 50 80 00    	mov    0x80501c,%edx
  8026b9:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8026bc:	83 c4 10             	add    $0x10,%esp
  8026bf:	39 cb                	cmp    %ecx,%ebx
  8026c1:	74 1b                	je     8026de <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8026c3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8026c6:	75 cf                	jne    802697 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8026c8:	8b 42 58             	mov    0x58(%edx),%eax
  8026cb:	6a 01                	push   $0x1
  8026cd:	50                   	push   %eax
  8026ce:	53                   	push   %ebx
  8026cf:	68 82 35 80 00       	push   $0x803582
  8026d4:	e8 79 e2 ff ff       	call   800952 <cprintf>
  8026d9:	83 c4 10             	add    $0x10,%esp
  8026dc:	eb b9                	jmp    802697 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8026de:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8026e1:	0f 94 c0             	sete   %al
  8026e4:	0f b6 c0             	movzbl %al,%eax
}
  8026e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026ea:	5b                   	pop    %ebx
  8026eb:	5e                   	pop    %esi
  8026ec:	5f                   	pop    %edi
  8026ed:	5d                   	pop    %ebp
  8026ee:	c3                   	ret    

008026ef <devpipe_write>:
{
  8026ef:	f3 0f 1e fb          	endbr32 
  8026f3:	55                   	push   %ebp
  8026f4:	89 e5                	mov    %esp,%ebp
  8026f6:	57                   	push   %edi
  8026f7:	56                   	push   %esi
  8026f8:	53                   	push   %ebx
  8026f9:	83 ec 28             	sub    $0x28,%esp
  8026fc:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8026ff:	56                   	push   %esi
  802700:	e8 6d ef ff ff       	call   801672 <fd2data>
  802705:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802707:	83 c4 10             	add    $0x10,%esp
  80270a:	bf 00 00 00 00       	mov    $0x0,%edi
  80270f:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802712:	74 4f                	je     802763 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802714:	8b 43 04             	mov    0x4(%ebx),%eax
  802717:	8b 0b                	mov    (%ebx),%ecx
  802719:	8d 51 20             	lea    0x20(%ecx),%edx
  80271c:	39 d0                	cmp    %edx,%eax
  80271e:	72 14                	jb     802734 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  802720:	89 da                	mov    %ebx,%edx
  802722:	89 f0                	mov    %esi,%eax
  802724:	e8 61 ff ff ff       	call   80268a <_pipeisclosed>
  802729:	85 c0                	test   %eax,%eax
  80272b:	75 3b                	jne    802768 <devpipe_write+0x79>
			sys_yield();
  80272d:	e8 49 ec ff ff       	call   80137b <sys_yield>
  802732:	eb e0                	jmp    802714 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802734:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802737:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80273b:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80273e:	89 c2                	mov    %eax,%edx
  802740:	c1 fa 1f             	sar    $0x1f,%edx
  802743:	89 d1                	mov    %edx,%ecx
  802745:	c1 e9 1b             	shr    $0x1b,%ecx
  802748:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80274b:	83 e2 1f             	and    $0x1f,%edx
  80274e:	29 ca                	sub    %ecx,%edx
  802750:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802754:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802758:	83 c0 01             	add    $0x1,%eax
  80275b:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80275e:	83 c7 01             	add    $0x1,%edi
  802761:	eb ac                	jmp    80270f <devpipe_write+0x20>
	return i;
  802763:	8b 45 10             	mov    0x10(%ebp),%eax
  802766:	eb 05                	jmp    80276d <devpipe_write+0x7e>
				return 0;
  802768:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80276d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802770:	5b                   	pop    %ebx
  802771:	5e                   	pop    %esi
  802772:	5f                   	pop    %edi
  802773:	5d                   	pop    %ebp
  802774:	c3                   	ret    

00802775 <devpipe_read>:
{
  802775:	f3 0f 1e fb          	endbr32 
  802779:	55                   	push   %ebp
  80277a:	89 e5                	mov    %esp,%ebp
  80277c:	57                   	push   %edi
  80277d:	56                   	push   %esi
  80277e:	53                   	push   %ebx
  80277f:	83 ec 18             	sub    $0x18,%esp
  802782:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802785:	57                   	push   %edi
  802786:	e8 e7 ee ff ff       	call   801672 <fd2data>
  80278b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80278d:	83 c4 10             	add    $0x10,%esp
  802790:	be 00 00 00 00       	mov    $0x0,%esi
  802795:	3b 75 10             	cmp    0x10(%ebp),%esi
  802798:	75 14                	jne    8027ae <devpipe_read+0x39>
	return i;
  80279a:	8b 45 10             	mov    0x10(%ebp),%eax
  80279d:	eb 02                	jmp    8027a1 <devpipe_read+0x2c>
				return i;
  80279f:	89 f0                	mov    %esi,%eax
}
  8027a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027a4:	5b                   	pop    %ebx
  8027a5:	5e                   	pop    %esi
  8027a6:	5f                   	pop    %edi
  8027a7:	5d                   	pop    %ebp
  8027a8:	c3                   	ret    
			sys_yield();
  8027a9:	e8 cd eb ff ff       	call   80137b <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8027ae:	8b 03                	mov    (%ebx),%eax
  8027b0:	3b 43 04             	cmp    0x4(%ebx),%eax
  8027b3:	75 18                	jne    8027cd <devpipe_read+0x58>
			if (i > 0)
  8027b5:	85 f6                	test   %esi,%esi
  8027b7:	75 e6                	jne    80279f <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8027b9:	89 da                	mov    %ebx,%edx
  8027bb:	89 f8                	mov    %edi,%eax
  8027bd:	e8 c8 fe ff ff       	call   80268a <_pipeisclosed>
  8027c2:	85 c0                	test   %eax,%eax
  8027c4:	74 e3                	je     8027a9 <devpipe_read+0x34>
				return 0;
  8027c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8027cb:	eb d4                	jmp    8027a1 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8027cd:	99                   	cltd   
  8027ce:	c1 ea 1b             	shr    $0x1b,%edx
  8027d1:	01 d0                	add    %edx,%eax
  8027d3:	83 e0 1f             	and    $0x1f,%eax
  8027d6:	29 d0                	sub    %edx,%eax
  8027d8:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8027dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8027e0:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8027e3:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8027e6:	83 c6 01             	add    $0x1,%esi
  8027e9:	eb aa                	jmp    802795 <devpipe_read+0x20>

008027eb <pipe>:
{
  8027eb:	f3 0f 1e fb          	endbr32 
  8027ef:	55                   	push   %ebp
  8027f0:	89 e5                	mov    %esp,%ebp
  8027f2:	56                   	push   %esi
  8027f3:	53                   	push   %ebx
  8027f4:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8027f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027fa:	50                   	push   %eax
  8027fb:	e8 8d ee ff ff       	call   80168d <fd_alloc>
  802800:	89 c3                	mov    %eax,%ebx
  802802:	83 c4 10             	add    $0x10,%esp
  802805:	85 c0                	test   %eax,%eax
  802807:	0f 88 23 01 00 00    	js     802930 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80280d:	83 ec 04             	sub    $0x4,%esp
  802810:	68 07 04 00 00       	push   $0x407
  802815:	ff 75 f4             	pushl  -0xc(%ebp)
  802818:	6a 00                	push   $0x0
  80281a:	e8 7f eb ff ff       	call   80139e <sys_page_alloc>
  80281f:	89 c3                	mov    %eax,%ebx
  802821:	83 c4 10             	add    $0x10,%esp
  802824:	85 c0                	test   %eax,%eax
  802826:	0f 88 04 01 00 00    	js     802930 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  80282c:	83 ec 0c             	sub    $0xc,%esp
  80282f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802832:	50                   	push   %eax
  802833:	e8 55 ee ff ff       	call   80168d <fd_alloc>
  802838:	89 c3                	mov    %eax,%ebx
  80283a:	83 c4 10             	add    $0x10,%esp
  80283d:	85 c0                	test   %eax,%eax
  80283f:	0f 88 db 00 00 00    	js     802920 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802845:	83 ec 04             	sub    $0x4,%esp
  802848:	68 07 04 00 00       	push   $0x407
  80284d:	ff 75 f0             	pushl  -0x10(%ebp)
  802850:	6a 00                	push   $0x0
  802852:	e8 47 eb ff ff       	call   80139e <sys_page_alloc>
  802857:	89 c3                	mov    %eax,%ebx
  802859:	83 c4 10             	add    $0x10,%esp
  80285c:	85 c0                	test   %eax,%eax
  80285e:	0f 88 bc 00 00 00    	js     802920 <pipe+0x135>
	va = fd2data(fd0);
  802864:	83 ec 0c             	sub    $0xc,%esp
  802867:	ff 75 f4             	pushl  -0xc(%ebp)
  80286a:	e8 03 ee ff ff       	call   801672 <fd2data>
  80286f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802871:	83 c4 0c             	add    $0xc,%esp
  802874:	68 07 04 00 00       	push   $0x407
  802879:	50                   	push   %eax
  80287a:	6a 00                	push   $0x0
  80287c:	e8 1d eb ff ff       	call   80139e <sys_page_alloc>
  802881:	89 c3                	mov    %eax,%ebx
  802883:	83 c4 10             	add    $0x10,%esp
  802886:	85 c0                	test   %eax,%eax
  802888:	0f 88 82 00 00 00    	js     802910 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80288e:	83 ec 0c             	sub    $0xc,%esp
  802891:	ff 75 f0             	pushl  -0x10(%ebp)
  802894:	e8 d9 ed ff ff       	call   801672 <fd2data>
  802899:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8028a0:	50                   	push   %eax
  8028a1:	6a 00                	push   $0x0
  8028a3:	56                   	push   %esi
  8028a4:	6a 00                	push   $0x0
  8028a6:	e8 3a eb ff ff       	call   8013e5 <sys_page_map>
  8028ab:	89 c3                	mov    %eax,%ebx
  8028ad:	83 c4 20             	add    $0x20,%esp
  8028b0:	85 c0                	test   %eax,%eax
  8028b2:	78 4e                	js     802902 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8028b4:	a1 5c 40 80 00       	mov    0x80405c,%eax
  8028b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028bc:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8028be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028c1:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8028c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028cb:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8028cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8028d7:	83 ec 0c             	sub    $0xc,%esp
  8028da:	ff 75 f4             	pushl  -0xc(%ebp)
  8028dd:	e8 7c ed ff ff       	call   80165e <fd2num>
  8028e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8028e5:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8028e7:	83 c4 04             	add    $0x4,%esp
  8028ea:	ff 75 f0             	pushl  -0x10(%ebp)
  8028ed:	e8 6c ed ff ff       	call   80165e <fd2num>
  8028f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8028f5:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8028f8:	83 c4 10             	add    $0x10,%esp
  8028fb:	bb 00 00 00 00       	mov    $0x0,%ebx
  802900:	eb 2e                	jmp    802930 <pipe+0x145>
	sys_page_unmap(0, va);
  802902:	83 ec 08             	sub    $0x8,%esp
  802905:	56                   	push   %esi
  802906:	6a 00                	push   $0x0
  802908:	e8 1e eb ff ff       	call   80142b <sys_page_unmap>
  80290d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802910:	83 ec 08             	sub    $0x8,%esp
  802913:	ff 75 f0             	pushl  -0x10(%ebp)
  802916:	6a 00                	push   $0x0
  802918:	e8 0e eb ff ff       	call   80142b <sys_page_unmap>
  80291d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802920:	83 ec 08             	sub    $0x8,%esp
  802923:	ff 75 f4             	pushl  -0xc(%ebp)
  802926:	6a 00                	push   $0x0
  802928:	e8 fe ea ff ff       	call   80142b <sys_page_unmap>
  80292d:	83 c4 10             	add    $0x10,%esp
}
  802930:	89 d8                	mov    %ebx,%eax
  802932:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802935:	5b                   	pop    %ebx
  802936:	5e                   	pop    %esi
  802937:	5d                   	pop    %ebp
  802938:	c3                   	ret    

00802939 <pipeisclosed>:
{
  802939:	f3 0f 1e fb          	endbr32 
  80293d:	55                   	push   %ebp
  80293e:	89 e5                	mov    %esp,%ebp
  802940:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802943:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802946:	50                   	push   %eax
  802947:	ff 75 08             	pushl  0x8(%ebp)
  80294a:	e8 94 ed ff ff       	call   8016e3 <fd_lookup>
  80294f:	83 c4 10             	add    $0x10,%esp
  802952:	85 c0                	test   %eax,%eax
  802954:	78 18                	js     80296e <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  802956:	83 ec 0c             	sub    $0xc,%esp
  802959:	ff 75 f4             	pushl  -0xc(%ebp)
  80295c:	e8 11 ed ff ff       	call   801672 <fd2data>
  802961:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802963:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802966:	e8 1f fd ff ff       	call   80268a <_pipeisclosed>
  80296b:	83 c4 10             	add    $0x10,%esp
}
  80296e:	c9                   	leave  
  80296f:	c3                   	ret    

00802970 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802970:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  802974:	b8 00 00 00 00       	mov    $0x0,%eax
  802979:	c3                   	ret    

0080297a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80297a:	f3 0f 1e fb          	endbr32 
  80297e:	55                   	push   %ebp
  80297f:	89 e5                	mov    %esp,%ebp
  802981:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802984:	68 9a 35 80 00       	push   $0x80359a
  802989:	ff 75 0c             	pushl  0xc(%ebp)
  80298c:	e8 cb e5 ff ff       	call   800f5c <strcpy>
	return 0;
}
  802991:	b8 00 00 00 00       	mov    $0x0,%eax
  802996:	c9                   	leave  
  802997:	c3                   	ret    

00802998 <devcons_write>:
{
  802998:	f3 0f 1e fb          	endbr32 
  80299c:	55                   	push   %ebp
  80299d:	89 e5                	mov    %esp,%ebp
  80299f:	57                   	push   %edi
  8029a0:	56                   	push   %esi
  8029a1:	53                   	push   %ebx
  8029a2:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8029a8:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8029ad:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8029b3:	3b 75 10             	cmp    0x10(%ebp),%esi
  8029b6:	73 31                	jae    8029e9 <devcons_write+0x51>
		m = n - tot;
  8029b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8029bb:	29 f3                	sub    %esi,%ebx
  8029bd:	83 fb 7f             	cmp    $0x7f,%ebx
  8029c0:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8029c5:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8029c8:	83 ec 04             	sub    $0x4,%esp
  8029cb:	53                   	push   %ebx
  8029cc:	89 f0                	mov    %esi,%eax
  8029ce:	03 45 0c             	add    0xc(%ebp),%eax
  8029d1:	50                   	push   %eax
  8029d2:	57                   	push   %edi
  8029d3:	e8 3a e7 ff ff       	call   801112 <memmove>
		sys_cputs(buf, m);
  8029d8:	83 c4 08             	add    $0x8,%esp
  8029db:	53                   	push   %ebx
  8029dc:	57                   	push   %edi
  8029dd:	e8 ec e8 ff ff       	call   8012ce <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8029e2:	01 de                	add    %ebx,%esi
  8029e4:	83 c4 10             	add    $0x10,%esp
  8029e7:	eb ca                	jmp    8029b3 <devcons_write+0x1b>
}
  8029e9:	89 f0                	mov    %esi,%eax
  8029eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8029ee:	5b                   	pop    %ebx
  8029ef:	5e                   	pop    %esi
  8029f0:	5f                   	pop    %edi
  8029f1:	5d                   	pop    %ebp
  8029f2:	c3                   	ret    

008029f3 <devcons_read>:
{
  8029f3:	f3 0f 1e fb          	endbr32 
  8029f7:	55                   	push   %ebp
  8029f8:	89 e5                	mov    %esp,%ebp
  8029fa:	83 ec 08             	sub    $0x8,%esp
  8029fd:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802a02:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802a06:	74 21                	je     802a29 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  802a08:	e8 e3 e8 ff ff       	call   8012f0 <sys_cgetc>
  802a0d:	85 c0                	test   %eax,%eax
  802a0f:	75 07                	jne    802a18 <devcons_read+0x25>
		sys_yield();
  802a11:	e8 65 e9 ff ff       	call   80137b <sys_yield>
  802a16:	eb f0                	jmp    802a08 <devcons_read+0x15>
	if (c < 0)
  802a18:	78 0f                	js     802a29 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  802a1a:	83 f8 04             	cmp    $0x4,%eax
  802a1d:	74 0c                	je     802a2b <devcons_read+0x38>
	*(char*)vbuf = c;
  802a1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a22:	88 02                	mov    %al,(%edx)
	return 1;
  802a24:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802a29:	c9                   	leave  
  802a2a:	c3                   	ret    
		return 0;
  802a2b:	b8 00 00 00 00       	mov    $0x0,%eax
  802a30:	eb f7                	jmp    802a29 <devcons_read+0x36>

00802a32 <cputchar>:
{
  802a32:	f3 0f 1e fb          	endbr32 
  802a36:	55                   	push   %ebp
  802a37:	89 e5                	mov    %esp,%ebp
  802a39:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3f:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802a42:	6a 01                	push   $0x1
  802a44:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802a47:	50                   	push   %eax
  802a48:	e8 81 e8 ff ff       	call   8012ce <sys_cputs>
}
  802a4d:	83 c4 10             	add    $0x10,%esp
  802a50:	c9                   	leave  
  802a51:	c3                   	ret    

00802a52 <getchar>:
{
  802a52:	f3 0f 1e fb          	endbr32 
  802a56:	55                   	push   %ebp
  802a57:	89 e5                	mov    %esp,%ebp
  802a59:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802a5c:	6a 01                	push   $0x1
  802a5e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802a61:	50                   	push   %eax
  802a62:	6a 00                	push   $0x0
  802a64:	e8 02 ef ff ff       	call   80196b <read>
	if (r < 0)
  802a69:	83 c4 10             	add    $0x10,%esp
  802a6c:	85 c0                	test   %eax,%eax
  802a6e:	78 06                	js     802a76 <getchar+0x24>
	if (r < 1)
  802a70:	74 06                	je     802a78 <getchar+0x26>
	return c;
  802a72:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802a76:	c9                   	leave  
  802a77:	c3                   	ret    
		return -E_EOF;
  802a78:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802a7d:	eb f7                	jmp    802a76 <getchar+0x24>

00802a7f <iscons>:
{
  802a7f:	f3 0f 1e fb          	endbr32 
  802a83:	55                   	push   %ebp
  802a84:	89 e5                	mov    %esp,%ebp
  802a86:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a89:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a8c:	50                   	push   %eax
  802a8d:	ff 75 08             	pushl  0x8(%ebp)
  802a90:	e8 4e ec ff ff       	call   8016e3 <fd_lookup>
  802a95:	83 c4 10             	add    $0x10,%esp
  802a98:	85 c0                	test   %eax,%eax
  802a9a:	78 11                	js     802aad <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  802a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9f:	8b 15 78 40 80 00    	mov    0x804078,%edx
  802aa5:	39 10                	cmp    %edx,(%eax)
  802aa7:	0f 94 c0             	sete   %al
  802aaa:	0f b6 c0             	movzbl %al,%eax
}
  802aad:	c9                   	leave  
  802aae:	c3                   	ret    

00802aaf <opencons>:
{
  802aaf:	f3 0f 1e fb          	endbr32 
  802ab3:	55                   	push   %ebp
  802ab4:	89 e5                	mov    %esp,%ebp
  802ab6:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802ab9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802abc:	50                   	push   %eax
  802abd:	e8 cb eb ff ff       	call   80168d <fd_alloc>
  802ac2:	83 c4 10             	add    $0x10,%esp
  802ac5:	85 c0                	test   %eax,%eax
  802ac7:	78 3a                	js     802b03 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802ac9:	83 ec 04             	sub    $0x4,%esp
  802acc:	68 07 04 00 00       	push   $0x407
  802ad1:	ff 75 f4             	pushl  -0xc(%ebp)
  802ad4:	6a 00                	push   $0x0
  802ad6:	e8 c3 e8 ff ff       	call   80139e <sys_page_alloc>
  802adb:	83 c4 10             	add    $0x10,%esp
  802ade:	85 c0                	test   %eax,%eax
  802ae0:	78 21                	js     802b03 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae5:	8b 15 78 40 80 00    	mov    0x804078,%edx
  802aeb:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802af7:	83 ec 0c             	sub    $0xc,%esp
  802afa:	50                   	push   %eax
  802afb:	e8 5e eb ff ff       	call   80165e <fd2num>
  802b00:	83 c4 10             	add    $0x10,%esp
}
  802b03:	c9                   	leave  
  802b04:	c3                   	ret    

00802b05 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802b05:	f3 0f 1e fb          	endbr32 
  802b09:	55                   	push   %ebp
  802b0a:	89 e5                	mov    %esp,%ebp
  802b0c:	56                   	push   %esi
  802b0d:	53                   	push   %ebx
  802b0e:	8b 75 08             	mov    0x8(%ebp),%esi
  802b11:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b14:	8b 5d 10             	mov    0x10(%ebp),%ebx
	//	that address.

	//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
	//   as meaning "no page".  (Zero is not the right value, since that's
	//   a perfectly valid place to map a page.)
	if(pg){
  802b17:	85 c0                	test   %eax,%eax
  802b19:	74 3d                	je     802b58 <ipc_recv+0x53>
		r = sys_ipc_recv(pg);
  802b1b:	83 ec 0c             	sub    $0xc,%esp
  802b1e:	50                   	push   %eax
  802b1f:	e8 46 ea ff ff       	call   80156a <sys_ipc_recv>
  802b24:	83 c4 10             	add    $0x10,%esp
	}

	// If 'from_env_store' is nonnull, then store the IPC sender's envid in
	//	*from_env_store.
	//   Use 'thisenv' to discover the value and who sent it.
	if(from_env_store){
  802b27:	85 f6                	test   %esi,%esi
  802b29:	74 0b                	je     802b36 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  802b2b:	8b 15 1c 50 80 00    	mov    0x80501c,%edx
  802b31:	8b 52 74             	mov    0x74(%edx),%edx
  802b34:	89 16                	mov    %edx,(%esi)
	}

	// If 'perm_store' is nonnull, then store the IPC sender's page permission
	//	in *perm_store (this is nonzero iff a page was successfully
	//	transferred to 'pg').
	if(perm_store){
  802b36:	85 db                	test   %ebx,%ebx
  802b38:	74 0b                	je     802b45 <ipc_recv+0x40>
		*perm_store = thisenv->env_ipc_perm;
  802b3a:	8b 15 1c 50 80 00    	mov    0x80501c,%edx
  802b40:	8b 52 78             	mov    0x78(%edx),%edx
  802b43:	89 13                	mov    %edx,(%ebx)
	}

	// If the system call fails, then store 0 in *fromenv and *perm (if
	//	they're nonnull) and return the error.
	// Otherwise, return the value sent by the sender
	if(r < 0){
  802b45:	85 c0                	test   %eax,%eax
  802b47:	78 21                	js     802b6a <ipc_recv+0x65>
		if(!from_env_store) *from_env_store = 0;
		if(!perm_store) *perm_store = 0;
		return r;
	}

	return thisenv->env_ipc_value;
  802b49:	a1 1c 50 80 00       	mov    0x80501c,%eax
  802b4e:	8b 40 70             	mov    0x70(%eax),%eax
}
  802b51:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802b54:	5b                   	pop    %ebx
  802b55:	5e                   	pop    %esi
  802b56:	5d                   	pop    %ebp
  802b57:	c3                   	ret    
		r = sys_ipc_recv((void*)UTOP);
  802b58:	83 ec 0c             	sub    $0xc,%esp
  802b5b:	68 00 00 c0 ee       	push   $0xeec00000
  802b60:	e8 05 ea ff ff       	call   80156a <sys_ipc_recv>
  802b65:	83 c4 10             	add    $0x10,%esp
  802b68:	eb bd                	jmp    802b27 <ipc_recv+0x22>
		if(!from_env_store) *from_env_store = 0;
  802b6a:	85 f6                	test   %esi,%esi
  802b6c:	74 10                	je     802b7e <ipc_recv+0x79>
		if(!perm_store) *perm_store = 0;
  802b6e:	85 db                	test   %ebx,%ebx
  802b70:	75 df                	jne    802b51 <ipc_recv+0x4c>
  802b72:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802b79:	00 00 00 
  802b7c:	eb d3                	jmp    802b51 <ipc_recv+0x4c>
		if(!from_env_store) *from_env_store = 0;
  802b7e:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  802b85:	00 00 00 
  802b88:	eb e4                	jmp    802b6e <ipc_recv+0x69>

00802b8a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802b8a:	f3 0f 1e fb          	endbr32 
  802b8e:	55                   	push   %ebp
  802b8f:	89 e5                	mov    %esp,%ebp
  802b91:	57                   	push   %edi
  802b92:	56                   	push   %esi
  802b93:	53                   	push   %ebx
  802b94:	83 ec 0c             	sub    $0xc,%esp
  802b97:	8b 7d 08             	mov    0x8(%ebp),%edi
  802b9a:	8b 75 0c             	mov    0xc(%ebp),%esi
  802b9d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	int r;

	if(!pg) pg = (void*)UTOP;
  802ba0:	85 db                	test   %ebx,%ebx
  802ba2:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802ba7:	0f 44 d8             	cmove  %eax,%ebx

	while((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0){
  802baa:	ff 75 14             	pushl  0x14(%ebp)
  802bad:	53                   	push   %ebx
  802bae:	56                   	push   %esi
  802baf:	57                   	push   %edi
  802bb0:	e8 8e e9 ff ff       	call   801543 <sys_ipc_try_send>
  802bb5:	83 c4 10             	add    $0x10,%esp
  802bb8:	85 c0                	test   %eax,%eax
  802bba:	79 1e                	jns    802bda <ipc_send+0x50>
		if(r != -E_IPC_NOT_RECV){
  802bbc:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802bbf:	75 07                	jne    802bc8 <ipc_send+0x3e>
			panic("sys_ipc_try_send error %d\n", r);
		}
		sys_yield();
  802bc1:	e8 b5 e7 ff ff       	call   80137b <sys_yield>
  802bc6:	eb e2                	jmp    802baa <ipc_send+0x20>
			panic("sys_ipc_try_send error %d\n", r);
  802bc8:	50                   	push   %eax
  802bc9:	68 a6 35 80 00       	push   $0x8035a6
  802bce:	6a 59                	push   $0x59
  802bd0:	68 c1 35 80 00       	push   $0x8035c1
  802bd5:	e8 91 dc ff ff       	call   80086b <_panic>
	}
}
  802bda:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802bdd:	5b                   	pop    %ebx
  802bde:	5e                   	pop    %esi
  802bdf:	5f                   	pop    %edi
  802be0:	5d                   	pop    %ebp
  802be1:	c3                   	ret    

00802be2 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802be2:	f3 0f 1e fb          	endbr32 
  802be6:	55                   	push   %ebp
  802be7:	89 e5                	mov    %esp,%ebp
  802be9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802bec:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802bf1:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802bf4:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802bfa:	8b 52 50             	mov    0x50(%edx),%edx
  802bfd:	39 ca                	cmp    %ecx,%edx
  802bff:	74 11                	je     802c12 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802c01:	83 c0 01             	add    $0x1,%eax
  802c04:	3d 00 04 00 00       	cmp    $0x400,%eax
  802c09:	75 e6                	jne    802bf1 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802c0b:	b8 00 00 00 00       	mov    $0x0,%eax
  802c10:	eb 0b                	jmp    802c1d <ipc_find_env+0x3b>
			return envs[i].env_id;
  802c12:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802c15:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802c1a:	8b 40 48             	mov    0x48(%eax),%eax
}
  802c1d:	5d                   	pop    %ebp
  802c1e:	c3                   	ret    

00802c1f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802c1f:	f3 0f 1e fb          	endbr32 
  802c23:	55                   	push   %ebp
  802c24:	89 e5                	mov    %esp,%ebp
  802c26:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802c29:	89 c2                	mov    %eax,%edx
  802c2b:	c1 ea 16             	shr    $0x16,%edx
  802c2e:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802c35:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802c3a:	f6 c1 01             	test   $0x1,%cl
  802c3d:	74 1c                	je     802c5b <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802c3f:	c1 e8 0c             	shr    $0xc,%eax
  802c42:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802c49:	a8 01                	test   $0x1,%al
  802c4b:	74 0e                	je     802c5b <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802c4d:	c1 e8 0c             	shr    $0xc,%eax
  802c50:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802c57:	ef 
  802c58:	0f b7 d2             	movzwl %dx,%edx
}
  802c5b:	89 d0                	mov    %edx,%eax
  802c5d:	5d                   	pop    %ebp
  802c5e:	c3                   	ret    
  802c5f:	90                   	nop

00802c60 <__udivdi3>:
  802c60:	f3 0f 1e fb          	endbr32 
  802c64:	55                   	push   %ebp
  802c65:	57                   	push   %edi
  802c66:	56                   	push   %esi
  802c67:	53                   	push   %ebx
  802c68:	83 ec 1c             	sub    $0x1c,%esp
  802c6b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802c6f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802c73:	8b 74 24 34          	mov    0x34(%esp),%esi
  802c77:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802c7b:	85 d2                	test   %edx,%edx
  802c7d:	75 19                	jne    802c98 <__udivdi3+0x38>
  802c7f:	39 f3                	cmp    %esi,%ebx
  802c81:	76 4d                	jbe    802cd0 <__udivdi3+0x70>
  802c83:	31 ff                	xor    %edi,%edi
  802c85:	89 e8                	mov    %ebp,%eax
  802c87:	89 f2                	mov    %esi,%edx
  802c89:	f7 f3                	div    %ebx
  802c8b:	89 fa                	mov    %edi,%edx
  802c8d:	83 c4 1c             	add    $0x1c,%esp
  802c90:	5b                   	pop    %ebx
  802c91:	5e                   	pop    %esi
  802c92:	5f                   	pop    %edi
  802c93:	5d                   	pop    %ebp
  802c94:	c3                   	ret    
  802c95:	8d 76 00             	lea    0x0(%esi),%esi
  802c98:	39 f2                	cmp    %esi,%edx
  802c9a:	76 14                	jbe    802cb0 <__udivdi3+0x50>
  802c9c:	31 ff                	xor    %edi,%edi
  802c9e:	31 c0                	xor    %eax,%eax
  802ca0:	89 fa                	mov    %edi,%edx
  802ca2:	83 c4 1c             	add    $0x1c,%esp
  802ca5:	5b                   	pop    %ebx
  802ca6:	5e                   	pop    %esi
  802ca7:	5f                   	pop    %edi
  802ca8:	5d                   	pop    %ebp
  802ca9:	c3                   	ret    
  802caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802cb0:	0f bd fa             	bsr    %edx,%edi
  802cb3:	83 f7 1f             	xor    $0x1f,%edi
  802cb6:	75 48                	jne    802d00 <__udivdi3+0xa0>
  802cb8:	39 f2                	cmp    %esi,%edx
  802cba:	72 06                	jb     802cc2 <__udivdi3+0x62>
  802cbc:	31 c0                	xor    %eax,%eax
  802cbe:	39 eb                	cmp    %ebp,%ebx
  802cc0:	77 de                	ja     802ca0 <__udivdi3+0x40>
  802cc2:	b8 01 00 00 00       	mov    $0x1,%eax
  802cc7:	eb d7                	jmp    802ca0 <__udivdi3+0x40>
  802cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802cd0:	89 d9                	mov    %ebx,%ecx
  802cd2:	85 db                	test   %ebx,%ebx
  802cd4:	75 0b                	jne    802ce1 <__udivdi3+0x81>
  802cd6:	b8 01 00 00 00       	mov    $0x1,%eax
  802cdb:	31 d2                	xor    %edx,%edx
  802cdd:	f7 f3                	div    %ebx
  802cdf:	89 c1                	mov    %eax,%ecx
  802ce1:	31 d2                	xor    %edx,%edx
  802ce3:	89 f0                	mov    %esi,%eax
  802ce5:	f7 f1                	div    %ecx
  802ce7:	89 c6                	mov    %eax,%esi
  802ce9:	89 e8                	mov    %ebp,%eax
  802ceb:	89 f7                	mov    %esi,%edi
  802ced:	f7 f1                	div    %ecx
  802cef:	89 fa                	mov    %edi,%edx
  802cf1:	83 c4 1c             	add    $0x1c,%esp
  802cf4:	5b                   	pop    %ebx
  802cf5:	5e                   	pop    %esi
  802cf6:	5f                   	pop    %edi
  802cf7:	5d                   	pop    %ebp
  802cf8:	c3                   	ret    
  802cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802d00:	89 f9                	mov    %edi,%ecx
  802d02:	b8 20 00 00 00       	mov    $0x20,%eax
  802d07:	29 f8                	sub    %edi,%eax
  802d09:	d3 e2                	shl    %cl,%edx
  802d0b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802d0f:	89 c1                	mov    %eax,%ecx
  802d11:	89 da                	mov    %ebx,%edx
  802d13:	d3 ea                	shr    %cl,%edx
  802d15:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802d19:	09 d1                	or     %edx,%ecx
  802d1b:	89 f2                	mov    %esi,%edx
  802d1d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802d21:	89 f9                	mov    %edi,%ecx
  802d23:	d3 e3                	shl    %cl,%ebx
  802d25:	89 c1                	mov    %eax,%ecx
  802d27:	d3 ea                	shr    %cl,%edx
  802d29:	89 f9                	mov    %edi,%ecx
  802d2b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802d2f:	89 eb                	mov    %ebp,%ebx
  802d31:	d3 e6                	shl    %cl,%esi
  802d33:	89 c1                	mov    %eax,%ecx
  802d35:	d3 eb                	shr    %cl,%ebx
  802d37:	09 de                	or     %ebx,%esi
  802d39:	89 f0                	mov    %esi,%eax
  802d3b:	f7 74 24 08          	divl   0x8(%esp)
  802d3f:	89 d6                	mov    %edx,%esi
  802d41:	89 c3                	mov    %eax,%ebx
  802d43:	f7 64 24 0c          	mull   0xc(%esp)
  802d47:	39 d6                	cmp    %edx,%esi
  802d49:	72 15                	jb     802d60 <__udivdi3+0x100>
  802d4b:	89 f9                	mov    %edi,%ecx
  802d4d:	d3 e5                	shl    %cl,%ebp
  802d4f:	39 c5                	cmp    %eax,%ebp
  802d51:	73 04                	jae    802d57 <__udivdi3+0xf7>
  802d53:	39 d6                	cmp    %edx,%esi
  802d55:	74 09                	je     802d60 <__udivdi3+0x100>
  802d57:	89 d8                	mov    %ebx,%eax
  802d59:	31 ff                	xor    %edi,%edi
  802d5b:	e9 40 ff ff ff       	jmp    802ca0 <__udivdi3+0x40>
  802d60:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802d63:	31 ff                	xor    %edi,%edi
  802d65:	e9 36 ff ff ff       	jmp    802ca0 <__udivdi3+0x40>
  802d6a:	66 90                	xchg   %ax,%ax
  802d6c:	66 90                	xchg   %ax,%ax
  802d6e:	66 90                	xchg   %ax,%ax

00802d70 <__umoddi3>:
  802d70:	f3 0f 1e fb          	endbr32 
  802d74:	55                   	push   %ebp
  802d75:	57                   	push   %edi
  802d76:	56                   	push   %esi
  802d77:	53                   	push   %ebx
  802d78:	83 ec 1c             	sub    $0x1c,%esp
  802d7b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802d7f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802d83:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802d87:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802d8b:	85 c0                	test   %eax,%eax
  802d8d:	75 19                	jne    802da8 <__umoddi3+0x38>
  802d8f:	39 df                	cmp    %ebx,%edi
  802d91:	76 5d                	jbe    802df0 <__umoddi3+0x80>
  802d93:	89 f0                	mov    %esi,%eax
  802d95:	89 da                	mov    %ebx,%edx
  802d97:	f7 f7                	div    %edi
  802d99:	89 d0                	mov    %edx,%eax
  802d9b:	31 d2                	xor    %edx,%edx
  802d9d:	83 c4 1c             	add    $0x1c,%esp
  802da0:	5b                   	pop    %ebx
  802da1:	5e                   	pop    %esi
  802da2:	5f                   	pop    %edi
  802da3:	5d                   	pop    %ebp
  802da4:	c3                   	ret    
  802da5:	8d 76 00             	lea    0x0(%esi),%esi
  802da8:	89 f2                	mov    %esi,%edx
  802daa:	39 d8                	cmp    %ebx,%eax
  802dac:	76 12                	jbe    802dc0 <__umoddi3+0x50>
  802dae:	89 f0                	mov    %esi,%eax
  802db0:	89 da                	mov    %ebx,%edx
  802db2:	83 c4 1c             	add    $0x1c,%esp
  802db5:	5b                   	pop    %ebx
  802db6:	5e                   	pop    %esi
  802db7:	5f                   	pop    %edi
  802db8:	5d                   	pop    %ebp
  802db9:	c3                   	ret    
  802dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802dc0:	0f bd e8             	bsr    %eax,%ebp
  802dc3:	83 f5 1f             	xor    $0x1f,%ebp
  802dc6:	75 50                	jne    802e18 <__umoddi3+0xa8>
  802dc8:	39 d8                	cmp    %ebx,%eax
  802dca:	0f 82 e0 00 00 00    	jb     802eb0 <__umoddi3+0x140>
  802dd0:	89 d9                	mov    %ebx,%ecx
  802dd2:	39 f7                	cmp    %esi,%edi
  802dd4:	0f 86 d6 00 00 00    	jbe    802eb0 <__umoddi3+0x140>
  802dda:	89 d0                	mov    %edx,%eax
  802ddc:	89 ca                	mov    %ecx,%edx
  802dde:	83 c4 1c             	add    $0x1c,%esp
  802de1:	5b                   	pop    %ebx
  802de2:	5e                   	pop    %esi
  802de3:	5f                   	pop    %edi
  802de4:	5d                   	pop    %ebp
  802de5:	c3                   	ret    
  802de6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ded:	8d 76 00             	lea    0x0(%esi),%esi
  802df0:	89 fd                	mov    %edi,%ebp
  802df2:	85 ff                	test   %edi,%edi
  802df4:	75 0b                	jne    802e01 <__umoddi3+0x91>
  802df6:	b8 01 00 00 00       	mov    $0x1,%eax
  802dfb:	31 d2                	xor    %edx,%edx
  802dfd:	f7 f7                	div    %edi
  802dff:	89 c5                	mov    %eax,%ebp
  802e01:	89 d8                	mov    %ebx,%eax
  802e03:	31 d2                	xor    %edx,%edx
  802e05:	f7 f5                	div    %ebp
  802e07:	89 f0                	mov    %esi,%eax
  802e09:	f7 f5                	div    %ebp
  802e0b:	89 d0                	mov    %edx,%eax
  802e0d:	31 d2                	xor    %edx,%edx
  802e0f:	eb 8c                	jmp    802d9d <__umoddi3+0x2d>
  802e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802e18:	89 e9                	mov    %ebp,%ecx
  802e1a:	ba 20 00 00 00       	mov    $0x20,%edx
  802e1f:	29 ea                	sub    %ebp,%edx
  802e21:	d3 e0                	shl    %cl,%eax
  802e23:	89 44 24 08          	mov    %eax,0x8(%esp)
  802e27:	89 d1                	mov    %edx,%ecx
  802e29:	89 f8                	mov    %edi,%eax
  802e2b:	d3 e8                	shr    %cl,%eax
  802e2d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802e31:	89 54 24 04          	mov    %edx,0x4(%esp)
  802e35:	8b 54 24 04          	mov    0x4(%esp),%edx
  802e39:	09 c1                	or     %eax,%ecx
  802e3b:	89 d8                	mov    %ebx,%eax
  802e3d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802e41:	89 e9                	mov    %ebp,%ecx
  802e43:	d3 e7                	shl    %cl,%edi
  802e45:	89 d1                	mov    %edx,%ecx
  802e47:	d3 e8                	shr    %cl,%eax
  802e49:	89 e9                	mov    %ebp,%ecx
  802e4b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802e4f:	d3 e3                	shl    %cl,%ebx
  802e51:	89 c7                	mov    %eax,%edi
  802e53:	89 d1                	mov    %edx,%ecx
  802e55:	89 f0                	mov    %esi,%eax
  802e57:	d3 e8                	shr    %cl,%eax
  802e59:	89 e9                	mov    %ebp,%ecx
  802e5b:	89 fa                	mov    %edi,%edx
  802e5d:	d3 e6                	shl    %cl,%esi
  802e5f:	09 d8                	or     %ebx,%eax
  802e61:	f7 74 24 08          	divl   0x8(%esp)
  802e65:	89 d1                	mov    %edx,%ecx
  802e67:	89 f3                	mov    %esi,%ebx
  802e69:	f7 64 24 0c          	mull   0xc(%esp)
  802e6d:	89 c6                	mov    %eax,%esi
  802e6f:	89 d7                	mov    %edx,%edi
  802e71:	39 d1                	cmp    %edx,%ecx
  802e73:	72 06                	jb     802e7b <__umoddi3+0x10b>
  802e75:	75 10                	jne    802e87 <__umoddi3+0x117>
  802e77:	39 c3                	cmp    %eax,%ebx
  802e79:	73 0c                	jae    802e87 <__umoddi3+0x117>
  802e7b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802e7f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802e83:	89 d7                	mov    %edx,%edi
  802e85:	89 c6                	mov    %eax,%esi
  802e87:	89 ca                	mov    %ecx,%edx
  802e89:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802e8e:	29 f3                	sub    %esi,%ebx
  802e90:	19 fa                	sbb    %edi,%edx
  802e92:	89 d0                	mov    %edx,%eax
  802e94:	d3 e0                	shl    %cl,%eax
  802e96:	89 e9                	mov    %ebp,%ecx
  802e98:	d3 eb                	shr    %cl,%ebx
  802e9a:	d3 ea                	shr    %cl,%edx
  802e9c:	09 d8                	or     %ebx,%eax
  802e9e:	83 c4 1c             	add    $0x1c,%esp
  802ea1:	5b                   	pop    %ebx
  802ea2:	5e                   	pop    %esi
  802ea3:	5f                   	pop    %edi
  802ea4:	5d                   	pop    %ebp
  802ea5:	c3                   	ret    
  802ea6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ead:	8d 76 00             	lea    0x0(%esi),%esi
  802eb0:	29 fe                	sub    %edi,%esi
  802eb2:	19 c3                	sbb    %eax,%ebx
  802eb4:	89 f2                	mov    %esi,%edx
  802eb6:	89 d9                	mov    %ebx,%ecx
  802eb8:	e9 1d ff ff ff       	jmp    802dda <__umoddi3+0x6a>
