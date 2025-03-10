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

class MY_Controller extends CI_Controller {

	/**
	 * General Variable
	 * @var Array
	 */
	protected $vars = [];

	/**
	 * Flags that should be used when encoding to JSON.
	 *
	 * @var int
	 */
	public const REQUIRED_FLAGS = JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_AMP | JSON_HEX_QUOT | JSON_THROW_ON_ERROR | JSON_UNESCAPED_SLASHES;

	public function __construct() {
		parent::__construct();
		$timezone = NULL !== $this->session->userdata('general') && isset(__session('general')['timezone']) 
			? __session('general')['timezone'] 
			: 'Asia/Jakarta';
		date_default_timezone_set($timezone);
	}
}

require_once(APPPATH.'/core/Public_Controller.php');
require_once(APPPATH.'/core/Admin_Controller.php');
