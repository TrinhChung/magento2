<?php

namespace HiepDao\News\Block;

use Magento\Framework\View\Element\Template;
use Magento\Framework\HTTP\Client\Curl;

class News extends Template
{
    protected Curl $curl;

    public function __construct(Template\Context $context, Curl $curl)
    {
        parent::__construct($context);
        $this->curl = $curl;
    }

    protected function _prepareLayout()
    {
        return parent::_prepareLayout();
    }

    public function getPriceRate()
    {
        try {
            $url = 'https://vnexpress.net/rss/tin-moi-nhat.rss';
            $this->curl->get($url);
            $xml_text = $this->curl->getBody();

            $xml = simplexml_load_string($xml_text);
            return $xml;
        } catch (\Exception $e) {
            return $e->getMessage();
        }
    }
}
