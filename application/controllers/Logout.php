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

class Logout extends CI_Controller {

	/**
	 * Flags that should be used when encoding to JSON.
	 *
	 * @var int
	 */
	public const REQUIRED_FLAGS = JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_AMP | JSON_HEX_QUOT | JSON_THROW_ON_ERROR | JSON_UNESCAPED_SLASHES;
	
	/**
	 * Class Constructor
	 *
	 * @return Void
	 */
	public function __construct() {
		parent::__construct();
		$timezone = NULL !== __session('general')['timezone'] ? __session('general')['timezone'] : 'Asia/Jakarta';
		date_default_timezone_set($timezone);
		$this->load->model('m_users');
	}

	/**
	 * Index
	 * @return Void
	 */
	public function index() {
		if ( ! $this->auth->logged_in()) return redirect(base_url(), 'refresh');
		$id = _toInteger(__session('user_id'));
		if (_isNaturalNumber( $id )) {
			$this->session->sess_destroy();
			$this->m_users->reset_logged_in($id);
		}
		return redirect('login', 'refresh');
	}
 }
