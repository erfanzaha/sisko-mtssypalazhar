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

class Home extends Public_Controller {

	/**
	 * Index
	 * @return Void
	 */
	public function index() {
		$this->vars['title'] = __session('school_profile')['website'] . ' | ' . __session('school_profile')['tagline'];
		$this->vars['content'] = 'themes/'.theme_folder().'/home';
		$this->load->view('themes/'.theme_folder().'/index', $this->vars);
	}
}
