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

class Feed extends Public_Controller {

	/**
	 * Class Constructor
	 *
	 * @return Void
	 */
	public function __construct() {
		parent::__construct();
		$this->load->model('public/m_posts');
		$this->load->helper(['xml', 'text']);
	}

	/**
	 * Index
	 * @return Void
	 */
	public function index() {
		$this->vars['feed_name'] = __session('school_profile')['website'];
		$this->vars['encoding'] = 'utf-8';
		$this->vars['feed_url'] = base_url().'feed';
		$this->vars['page_description'] = __session('general')['meta_description'];
		$this->vars['page_language'] = 'en-en';
		$this->vars['creator_email'] = __session('school_profile')['email'];
		$this->vars['posts'] = $this->m_posts->feed();
		header('Content-Type: text/xml; charset=utf-8', true);
		$this->load->view('feed', $this->vars);
	}
}
