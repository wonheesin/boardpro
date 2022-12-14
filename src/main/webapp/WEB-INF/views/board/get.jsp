<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


<%@include file="../includes/header.jsp" %>
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">Tables</h1>
                </div>
            </div>
 
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            Board Read Page
                        </div>

                        <div class="panel-body">
	                       	<div class="form-group">
	                       		<label>Bno</label>
	                       		<input class="form-control" value="<c:out value="${board.bno}" />" name="bno" readonly>
	                       	</div>
	                       	<div class="form-group">
	                       		<label>Title</label>
	                       		<input class="form-control" value="<c:out value="${board.title}" />" name="title" readonly>
	                       	</div>
	                       	<div class="form-group">
	                       		<label>Text area</label>
	                       		<textarea class="form-control" rows="3" name="content" readonly><c:out value="${board.content}" /></textarea>
	                       	</div>
	                       	<div class="form-group">
	                       		<label>Writer</label>
	                       		<input class="form-control" value="<c:out value="${board.writer}" />" name="writer" readonly>
	                       	</div>
	                       	<button data-oper="modify" class="btn btn-default">Modify</button>
	                       	<button data-oper="list" class="btn btn-default">List</button>
	                       	
	                       	<form id='operForm' action="/board/modify" method="get">
	                       		<input type="hidden" id="bno" name="bno" value='<c:out value="${board.bno }"/>'>
	                       		<input type="hidden" name="pageNum" value='<c:out value="${cri.pageNum }"/>'>
	                       		<input type="hidden" name="amount" value='<c:out value="${cri.amount }"/>'>
	                       		<input type="hidden" name="type" value="<c:out value="${cri.type}" />">
	                       		<input type="hidden" name="keyword" value="<c:out value="${cri.keyword }" />">
	                       		
	                       	</form>
                       	</div>
                        <!-- /.panel-body -->
                    </div>
                    <!-- /.panel -->
                </div>
            </div>
            <!-- /.row -->
            <div class="bigPictureWrapper">
            	<div class='bigPicture'>
            	</div>
            </div>
<style>
.uploadResult{
	width:100%;
	background-color: gray;
}

.uploadResult ul {
	display: flex;
	flex-flow: row;
	justify-content: center;
	align-items: center;
}

.uploadResult ul li {
	list-style: none;
	padding: 10px;
	align-content: center;
	text-align: center;
}
.uploadResult ul li img{
	width:100px;
}
.uploadResult ul li span{
	color:white;
}
.bigPictureWrapper {
	position: absolute;
	display: none;
	justify-content: center;
	align-items: center;
	top:0%;
	width:100%;
	height:100%;
	background-color: gray;
	z-index: 100;	
	background:rgba(255,255,255,0.5);
}
.bigPicture{
	position: relative;
	display: flex;
	justify-content: center;
	align-items: center;
}
.bigPicture img{
	width:600px;
}
</style>
            
            <div class="row">
            	<div class="col-lg-12">
            		<div class="panel panel-default">
            		
            			<div class="panel-heading">Files</div>
            			
            			<div class="panel-body">
            				<div class="uploadResult">
            					<ul>
            					</ul>
            				</div>
            			</div>
            		
            		</div>
            	</div>
            </div>
            
            <div class="row">
            	<div class="col-lg-12">
            		<div class="panel panel-default">
            			<div class="panel-heading">
            				<i class="fa fa-comments fa-fw"></i> Reply
            				<button id='addReplyBtn' class='btn btn-primary btn-xs pull-right'>New Reply</button>
            			</div>
            			
            			<div class="panel-body">
            				<ul class="chat">
            					<li></li>
            				</ul>
            			</div>
            			<div class="panel-footer">
            			
            			</div>
            		</div>
            	</div>
            </div>
            
            <!-- Modal -->
            <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            	<div class="modal-dialog">
            		<div class="modal-content">
            			<div class="modal-header">
            				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            				<h4 class="modal-title" id="myModalLabel">REPLY MODAL</h4>
            			</div>
            			<div class="modal-body">
            				<div class="form-group">
            					<label>Reply</label>
            					<input class="form-control" name='reply' value='New Reply!!!!'>
            				</div>
            				<div class="form-group">
            					<label>Replyer</label>
            					<input class="form-control" name='replyer' value='New Replyer'>
            				</div>
            				<div class="form-group">
            					<label>Reply Date</label>
            					<input class="form-control" name='replyDate' value=''>
            				</div>
            			</div>
            			<div class="modal-footer">
            				<button id='modalModBtn' type="button" class="btn btn-warning">Modify</button>
            				<button id='modalRemoveBtn' type="button" class="btn btn-danger">Remove</button>
            				<button id='modalRegBtn' type="button" class="btn btn-success">register</button>
            				<button id='modalCloseBtn' type="button" class="btn btn-default">Close</button>
            			</div>
            		</div>
            	</div>
            </div>

<%@include file="../includes/footer.jsp" %>
<script src="/resources/js/reply.js"></script>
<script>
	$(document).ready(function(){
			let bno = '<c:out value="${board.bno}"/>';
			
		    $.getJSON("/board/getAttachList", {bno: bno}, function(arr){
		        console.log(arr);

		        let str = "";

		        $(arr).each(function(i, attach){

		            //image type
		            if(attach.fileType){
		                let fileCallPath = encodeURIComponent(attach.uploadPath + "/s_"+attach.uuid+"_"+attach.fileName);
		                str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"'><div>";
		                str += "    <img src='/display?fileName="+fileCallPath+"'>";
		                str += "</div></li>";
		            }else{
		                str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"'><div>";
		                str += "    <span>"+attach.fileName+"</span><br>";
		                str += "    <img src='/resources/img/attach.png'>";
		                str += "</div></li>";
		            }
		        });
		        $(".uploadResult ul").html(str);
		    });
		    
		    $(".uploadResult").on("click", "li", function(e){
		    	console.log("view image");
		    	let liObj = $(this);
		    	
		    	let path = encodeURIComponent(liObj.data("path")+"/" + liObj.data("uuid")+"_"+liObj.data("filename"));
		    	
		    	if(liObj.data("type")){
		    		showImage(path.replace(new RegExp(/\\/g),"/"));
		    	}else {
		    		self.location = "/download?fileName=" + path;
		    	}
		    });
		    
		    function showImage(fileCallPath){
		    	
		    	$(".bigPictureWrapper").css("display", "flex").show();
		    	
		    	$(".bigPicture").html("<img src='/display?fileName="+fileCallPath+"'>").animate({width:'100%', height: '100%'}, 1000);
		    }
		    
		    $(".bigPictureWrapper").on("click", function(e){
		    	$(".bigPicture").animate({width:'0%', height:'0%'}, 1000);
		    	setTimeout(function(){
		    	$(".bigPictureWrapper").hide();	
		    	}, 1000);
		    });
		    
		    
		});
</script>

<script>
	$(document).ready(function(){
		

		
		let bnoValue = '<c:out value="${board.bno}"/>';
		let replyUL = $(".chat");
		
		showList(1);
		
		function showList(page){
			
			console.log("show list " + page);
			
			replyService.getList({bno:bnoValue, page: page||1}, 
			function(replyCnt, list){
				console.log("replyCnt: " + replyCnt);	
				console.log("list: " + list);		
				
				if(page==-1){
					pageNum = Math.ceil(replyCnt/10.0);
					showList(pageNum);
					return;
				}
				
				let str="";
				if(list == null || list.length == 0){
					replyUL.html("");
					return;
				}
				
				for(let i = 0, len = list.length || 0; i < len; i++){
					str += "<li class='left clearfix' data-rno='" + list[i].rno+"'>";
					str += "	<div><div class='header'><strong class='primary-font'>" + list[i].replyer+"</strong>";
					str += "			<small class='pull-right text-muted'>"+replyService.displayTime(list[i].replyDate)+"</small></div>";
					str += "			<p>"+list[i].reply+"</p></div></li>";
				}
				replyUL.html(str);
				showReplyPage(replyCnt);
			});
		}
		
		let modal = $(".modal");
		let modalInputReply = modal.find("input[name='reply']");
		let modalInputReplyer = modal.find("input[name='replyer']");
		let modalInputReplyDate = modal.find("input[name='replyDate']");
		
		let modalModBtn = $("#modalModBtn");
		let modalRemoveBtn = $("#modalRemoveBtn");
		let modalRegBtn = $("#modalRegBtn");
		let modalCloseBtn = $("#modalCloseBtn");
		
		modalCloseBtn.on("click", function(e){
			$(".modal").modal("hide");
		});
		
		$("#addReplyBtn").on("click", function(e){
			modal.find("input").val("");
			modalInputReplyDate.closest("div").hide();
			modal.find("button[id != 'modalCloseBtn']").hide();
			
			modalRegBtn.show();
			
			$(".modal").modal("show");
		});
		
		modalRegBtn.on("click", function(e){
			
			let reply = {
					reply : modalInputReply.val(),
					replyer : modalInputReplyer.val(),
					bno : bnoValue
			};
			replyService.add(reply, function(result){
				alert(result);
				
				modal.find("input").val("");
				modal.modal("hide");
				
				showList(-1);
			});
			
		});
		
		$(".chat").on("click", "li", function(e){
			let rno = $(this).data("rno");
			replyService.get(rno, function(reply){
				modalInputReply.val(reply.reply);
				modalInputReplyer.val(reply.replyer);
				modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly", "readonly");
				modal.data('rno', reply.rno);
				
				modal.find("button[id != 'modalCloseBtn']").hide();
				modalModBtn.show();
				modalRemoveBtn.show();
				
				$(".modal").modal("show");
			});
		
		});
		
		modalModBtn.on("click", function(e){
			let reply = {rno:modal.data("rno"), reply:modalInputReply.val()};
			
			replyService.update(reply, function(result){
				alert(result);
				modal.modal("hide");
				showList(pageNum);
			});
		});
		
		modalRemoveBtn.on("click", function(e){
			let rno = modal.data("rno");
			
			replyService.remove(rno, function(result){
				alert(result);
				modal.modal("hide");
				showList(pageNum);
			});
		});
		
		let pageNum = 1;
		let replyPageFooter = $(".panel-footer");
		
		function showReplyPage(replyCnt){
			let endNum = Math.ceil(pageNum / 10.0) * 10;
			let startNum = endNum - 9;
			
			let prev = startNum != 1;
			let next = false;
			
			if(endNum * 10 >= replyCnt){
				endNum = Math.ceil(replyCnt/10.0);
			}
			
			if(endNum * 10 < replyCnt){
				next = true;
			}
			
			let str = "<ul class='pagination pull-right'>"
			if(prev){
				str += "<li class='page-item'><a class='page-link' href='"+(startNum -1)+"'>Previous</a></li>";
			}
			
			for(let i = startNum; i<= endNum; i++){
				let active = pageNum == i ? "active":"";
				
				str += "<li class='page-item "+active+"'><a class='page-link' href='"+i+"'>"+i+"</a></li>";
			}
			if(next){
				str +="<li class='page-item'><a class='page-item' href='"+(endNum +1)+"'>Next</a></li>";
			}
			
			str += "</ul>";
			
			console.log(str);
			replyPageFooter.html(str);
		}
		
		replyPageFooter.on("click", "li a", function(e){
			e.preventDefault();
			console.log("page click");
			
			let targetPageNum = $(this).attr("href");
			
			console.log("targetPageNum: " + targetPageNum);
			pageNum = targetPageNum;
			
			showList(pageNum);
		});
		
	});

</script>
<script>
	$(document).ready(function(){
		let operForm = $("#operForm");
		
		$("button[data-oper='modify']").on("click", function(e){
			operForm.attr("action", "/board/modify").submit();
		});
		
		$("button[data-oper='list']").on("click", function(e){
			
			operForm.find("#bno").remove();
			operForm.attr("action", "/board/list").submit();
			
		});	
		
	});
</script>