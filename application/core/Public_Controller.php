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

class Public_Controller extends MY_Controller {

	/**
	 * General Variable
	 * @var Array
	 */
	protected $vars = [];

	/**
	 * Class Constructor
	 *
	 * @return Void
	 */
	public function __construct() {
		parent::__construct();

		// Load Text Helper
		$this->load->helper(['text', 'blog_helper']);

		// Load Token Library
		$this->load->library('token');

		// CSRF Token
		$session_data['csrf_token'] = $this->token->get_token();

		// set session data
		$this->session->set_userdata($session_data);

		// redirect if under construction
		if (NULL !== $this->session->userdata('general') && isset(__session('general')['site_maintenance'])) {
			if (filter_var(__session('general')['site_maintenance'], FILTER_VALIDATE_BOOLEAN) && __session('general')['site_maintenance_end_date'] >= date('Y-m-d') &&
			$this->uri->segment(1) !== 'login') {
				return redirect('under-construction');
			}
		}
		
		//  cache file
		if (NULL !== $this->session->userdata('general') && isset(__session('general')['site_cache'])) {
			if (filter_var(__session('general')['site_cache'], FILTER_VALIDATE_BOOLEAN) && (int) __session('general')['site_cache_time'] > 0) {
				$this->output->cache(__session('general')['site_cache_time']);
			}
		}
	}
}
