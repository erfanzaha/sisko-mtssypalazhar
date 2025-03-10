<?php defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * CMS Sekolahku Premium Version
 * @version    2.5.4
 * @author     Anton Sofyan | https://facebook.com/antonsofyan | 4ntonsofyan@gmail.com | 0857 5988 8922
 * @copyright  (c) 2017-2023
 * @link       https://sekolahku.web.id
 *
 * PERINGATAN :
 * 1. TIDAK DIPERKENANKAN MENGGUNAKAN CMS INI TANPA SEIZIN DARI PIHAK PENGEMBANG APLIKASI.
 * 2. TIDAK DIPERKENANKAN MEMPERJUALBELIKAN APLIKASI INI TANPA SEIZIN DARI PIHAK PENGEMBANG APLIKASI.
 * 3. TIDAK DIPERKENANKAN MENGHAPUS KODE SUMBER APLIKASI.
 */

class Readmore extends Public_Controller {

	/**
	 * Class Constructor
	 *
	 * @return Void
	 */
	public function __construct() {
		parent::__construct();
		$this->load->model([
			'public/m_posts'
			, 'm_post_comments'
		]);
	}

	/**
	 * Readmore
	 */
	public function index() {
		$this->load->helper(['text', 'form']);
		$id = _toInteger($this->uri->segment(2));
		if (_isNaturalNumber( $id )) {
			$this->vars['query'] = $this->model->RowObject('id', $id, 'posts');
			if (filter_var((string) $this->vars['query']->is_deleted, FILTER_VALIDATE_BOOLEAN)) {
				return redirect(base_url(), 'refresh');
			}
			if ($this->vars['query']->post_status == 'draft') {
				return redirect(base_url(), 'refresh');
			}
			if ($this->vars['query']->post_visibility == 'private' && ! $this->auth->logged_in()) {
				return redirect(base_url(), 'refresh');
			}
			$this->m_posts->set_post_counter($id);
			$limit = __session('reading')['comment_per_page'];
			$total_rows = $this->m_post_comments->get_post_comments($id)->num_rows();
			$this->vars['total_page'] = ceil(_toInteger($total_rows) / _toInteger($limit));
			$this->vars['post_comments'] = $this->m_post_comments->get_post_comments($id, $limit);
			$this->vars['page_title'] = $this->vars['query']->post_title;
			$this->vars['post_counter'] = $this->vars['query']->post_counter;
			$this->vars['post_type'] = $this->vars['query']->post_type === 'page' ? 'page' : 'post';
			$this->vars['post_author'] = $this->model->RowObject('id', $this->vars['query']->post_author, 'users')->full_name;
			$this->vars['content'] = 'themes/'.theme_folder().'/single-post';
			$this->load->view('themes/'.theme_folder().'/index', $this->vars);
		} else {
			show_404();
		}
	}
}
