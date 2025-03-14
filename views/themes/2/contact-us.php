<style type="text/css">
.mapouter {
	position:relative;
	text-align:right;
}
.gmap_canvas {
	overflow:hidden;
	background:none!important;
}
</style>
<div class="col-lg-8 col-md-8 col-sm-12 ">
	<h5 class="page-title mb-3"><?=strtoupper($page_title);?></h5>
	<div class="mapouter border border-secondary mb-3">
		<div class="gmap_canvas">
			<?=__session('general')['map_location'] ?>
		</div>
	</div>
	<div class="card rounded-0 border border-secondary mb-3">
		<div class="card-body">
			<div class="form-group row mb-2">
				<label for="comment_author" class="col-sm-3 control-label">Nama Lengkap <span style="color: red">*</span></label>
				<div class="col-sm-9">
					<input type="text" class="form-control form-control-sm rounded-0 border border-secondary" id="comment_author" name="comment_author">
				</div>
			</div>
			<div class="form-group row mb-2">
				<label for="comment_email" class="col-sm-3 control-label">Email <span style="color: red">*</span></label>
				<div class="col-sm-9">
					<input type="text" class="form-control form-control-sm rounded-0 border border-secondary" id="comment_email" name="comment_email">
				</div>
			</div>
			<div class="form-group row mb-2">
				<label for="comment_url" class="col-sm-3 control-label">URL</label>
				<div class="col-sm-9">
					<input type="text" class="form-control form-control-sm rounded-0 border border-secondary" id="comment_url" name="comment_url">
				</div>
			</div>
			<div class="form-group row mb-2">
				<label for="comment_content" class="col-sm-3 control-label">Pesan <span style="color: red">*</span></label>
				<div class="col-sm-9">
					<textarea name="name" class="form-control form-control-sm rounded-0 border border-secondary" id="comment_content" rows="4"></textarea>
				</div>
			</div>
			<?php if (NULL !== __session('general')['recaptcha_status'] && __session('general')['recaptcha_status'] == 'enable') { ?>
				<input type="hidden" class="g-recaptcha-response" name="g-recaptcha-response">
			<?php } ?>
		</div>
		<div class="card-footer">
			<div class="form-group row mb-0">
				<div class="offset-sm-3 col-sm-9">
					<button type="button" onclick="send_message(); return false;" class="btn btn-success rounded-0"><i class="fa fa-send"></i> Submit</button>
				</div>
			</div>
		</div>
	</div>
</div>
<?php $this->load->view('themes/1/sidebar')?>
