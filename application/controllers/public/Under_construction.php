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

class Under_construction extends CI_Controller {

	/**
	 * Class Constructor
	 *
	 * @return Void
	 */
	public function __construct() {
		parent::__construct();
		$site_maintenance = __session('general')['site_maintenance'];
		if (NULL !== $site_maintenance && ! filter_var((string) $site_maintenance, FILTER_VALIDATE_BOOLEAN)) {
			return redirect(base_url(), 'refresh');
		}
	}

	/**
	 * Index
	 */
	public function index() {
		$this->load->view('under_construction');
	}
}
